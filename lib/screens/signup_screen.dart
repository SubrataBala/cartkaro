import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ── MEMORY IMPORT ──

import 'login_screen.dart'
    show Country, CountryPickerSheet, LoginScreen, kCountries;

class SignupScreen extends StatefulWidget {
  final VoidCallback? onSkip;
  const SignupScreen({super.key, this.onSkip});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  Country _country = kCountries.first;
  bool _isLoading = false;
  bool _otpSent = false;
  bool _agreedToTerms = false;
  bool _canResend = false;
  int _resendSeconds = 30;
  Timer? _resendTimer;
  String? _verificationId;
  int? _resendToken;
  ConfirmationResult? _webConfirmationResult;
  RecaptchaVerifier? _webRecaptchaVerifier;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const kGreen = Color(0xFF0C831F);
  static const kGreenLight = Color(0xFFE8F5E9);
  static const kSurface = Color(0xFFF6F6F6);
  static const kTextDark = Color(0xFF1A1A1A);
  static const kTextMuted = Color(0xFF757575);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    _webRecaptchaVerifier?.clear();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      _showSnack(
        'Please agree to the Terms & Conditions to continue.',
        isError: true,
      );
      return;
    }
    setState(() => _isLoading = true);
    await _sendFirebaseOtp();
  }

  Future<void> _sendFirebaseOtp({int? forceResendingToken}) async {
    final phoneNumber = '${_country.dialCode}${_mobileController.text.trim()}';
    await FirebaseAuth.instance.setLanguageCode('en');

    if (kIsWeb) {
      await _sendWebFirebaseOtp(phoneNumber);
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: forceResendingToken,
        verificationCompleted: (credential) async {
          await _signInWithCredential(credential);
        },
        verificationFailed: (e) {
          print(
            'Firebase verification failed. Code: ${e.code}, Message: ${e.message}',
          );
          if (!mounted) return;
          setState(() => _isLoading = false);
          _showSnack(_firebaseAuthErrorMessage(e), isError: true);
        },
        codeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
            _otpSent = true;
            _verificationId = verificationId;
            _resendToken = resendToken;
          });
          _startResendTimer();
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) _otpFocusNodes[0].requestFocus();
          });
          _showSnack(
            'OTP sent to ${_country.dialCode} ${_mobileController.text.trim()}',
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationId = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      print(
        'Firebase verification could not start. Code: ${e.code}, Message: ${e.message}',
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack(_firebaseAuthErrorMessage(e), isError: true);
    } catch (e) {
      print('Firebase verification could not start: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack(
        'Could not start phone verification. Please try again.',
        isError: true,
      );
    }
  }

  Future<void> _sendWebFirebaseOtp(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.setLanguageCode('en');
      _webRecaptchaVerifier?.clear();
      _webRecaptchaVerifier = RecaptchaVerifier(
        auth: FirebaseAuthPlatform.instanceFor(
          app: FirebaseAuth.instance.app,
          pluginConstants: const {},
        ),
        // By not providing a `container`, the reCAPTCHA will be invisible.
        theme: RecaptchaVerifierTheme.light,
        onExpired: () {
          if (mounted) {
            _showSnack(
              'reCAPTCHA expired. Please request OTP again.',
              isError: true,
            );
          }
        },
        onError: (error) {
          if (mounted) {
            _showSnack('reCAPTCHA failed: $error', isError: true);
          }
        },
      );

      final confirmationResult = await FirebaseAuth.instance
          .signInWithPhoneNumber(phoneNumber, _webRecaptchaVerifier);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _otpSent = true;
        _webConfirmationResult = confirmationResult;
        _verificationId = null;
      });
      _startResendTimer();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _otpFocusNodes[0].requestFocus();
      });
      _showSnack(
        'OTP sent to ${_country.dialCode} ${_mobileController.text.trim()}',
      );
    } on FirebaseAuthException catch (e) {
      print(
        '🔥 Firebase web verification failed! Code: ${e.code}, Message: ${e.message}',
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack(_firebaseAuthErrorMessage(e), isError: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack('Could not start phone verification: $e', isError: true);
    }
  }

  Future<void> _verifyAndCreate() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      _showSnack('Please enter the complete 6-digit OTP', isError: true);
      return;
    }
    if (kIsWeb) {
      final confirmationResult = _webConfirmationResult;
      if (confirmationResult == null) {
        _showSnack('Please request OTP again.', isError: true);
        return;
      }
      setState(() => _isLoading = true);
      try {
        final userCredential = await confirmationResult.confirm(otp);
        await _handleSignedInUser(userCredential);
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showSnack(_firebaseAuthErrorMessage(e), isError: true);
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showSnack('An unexpected error occurred: $e', isError: true);
      }
      return;
    }
    if (_verificationId == null) {
      _showSnack('Please request OTP again.', isError: true);
      return;
    }
    setState(() => _isLoading = true);

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    await _signInWithCredential(credential);
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      await _handleSignedInUser(userCredential);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack(_firebaseAuthErrorMessage(e), isError: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack('An unexpected error occurred: $e', isError: true);
    }
  }

  Future<void> _handleSignedInUser(UserCredential userCredential) async {
    if (!mounted) return;

    // Store user details in Firestore for persistence across devices.
    if (userCredential.user != null) {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid);
      await userRef.set({
        'uid': userCredential.user!.uid,
        'name': _nameController.text.trim(),
        'phone': '${_country.dialCode}${_mobileController.text.trim()}',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // You can still keep the UID in SharedPreferences for quick synchronous access if needed.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firebaseUid', userCredential.user!.uid);
    }
    // The SnackBar may not be visible as the screen is removed immediately.
    _showSnack('Account created! Welcome to Cartkaro');

    // The AuthGate will handle navigation. We just need to pop this screen.
    // Using popUntil to clear the entire auth flow (login, signup) from the stack.
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendSeconds = 30;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds <= 1) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;
    for (final c in _otpControllers) {
      c.clear();
    }
    _otpFocusNodes[0].requestFocus();
    setState(() => _isLoading = true);
    await _sendFirebaseOtp(forceResendingToken: _resendToken);
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.redAccent : kGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _changeNumber() {
    _resendTimer?.cancel();
    for (final c in _otpControllers) {
      c.clear();
    }
    setState(() {
      _otpSent = false;
      _canResend = false;
      _resendSeconds = 30;
      _verificationId = null;
      _resendToken = null;
    });
  }

  String _firebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Please enter a valid phone number.';
      case 'invalid-verification-code':
        return 'The OTP is incorrect. Please check and try again.';
      case 'session-expired':
        return 'OTP expired. Please request a new one.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'app-not-authorized':
      case 'missing-client-identifier':
        return 'Firebase phone auth is not configured for this app yet.';
      default:
        return e.message ?? 'Firebase authentication failed.';
    }
  }

  void _skipToHome() {
    // This creates a temporary guest session. Restarting app will require login.
    widget.onSkip?.call();
  }

  Future<void> _pickCountry() async {
    final r = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (_) => CountryPickerSheet(selected: _country),
    );
    if (r != null) setState(() => _country = r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ── TOP ROW: BACK & SKIP BUTTONS ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _otpSent
                            ? _changeNumber
                            : () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: kSurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: kTextDark,
                          ),
                        ),
                      ),
                      if (!_otpSent)
                        TextButton(
                          onPressed: _skipToHome,
                          style: TextButton.styleFrom(
                            foregroundColor: kTextMuted,
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 36),
                  _buildHeader(),
                  const SizedBox(height: 28),

                  if (!_otpSent) ...[
                    _buildPerksStrip(),
                    const SizedBox(height: 28),
                  ],

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: _otpSent
                        ? _buildOtpStep(key: const ValueKey('otp'))
                        : _buildDetailsStep(key: const ValueKey('details')),
                  ),

                  const SizedBox(height: 28),
                  _buildLoginLink(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.shopping_cart_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Cartkaro',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          _otpSent ? 'Verify Number 🔐' : 'Create Account ✨',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kTextDark,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _otpSent
              ? 'Enter the 6-digit OTP sent to\n${_country.dialCode} ${_mobileController.text.trim()}'
              : 'Join thousands getting groceries in 10 mins',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: kTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildPerksStrip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: kGreenLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _PerkChip(icon: Icons.bolt_rounded, label: '10 min\ndelivery'),
          _PerkDivider(),
          _PerkChip(icon: Icons.discount_outlined, label: 'Exclusive\noffers'),
          _PerkDivider(),
          _PerkChip(icon: Icons.track_changes_rounded, label: 'Live\ntracking'),
        ],
      ),
    );
  }

  Widget _buildDetailsStep({Key? key}) {
    return Form(
      key: _formKey,
      child: Column(
        key: key,
        children: [
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: kTextDark,
            ),
            decoration: _inputDecoration(
              hint: 'Full Name',
              icon: Icons.person_outline_rounded,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Please enter your full name';
              }
              if (v.trim().length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickCountry,
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: kGreenLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _country.flag,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _country.dialCode,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: kGreen,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: kGreen,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: kTextDark,
                      letterSpacing: 1.2,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Mobile Number',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFFBDBDBD),
                        letterSpacing: 0,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      errorStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (v.length < 5) return 'Please enter a valid number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _agreedToTerms,
                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                  activeColor: kGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: const BorderSide(color: kTextMuted, width: 1.5),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'I agree to the ',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: kTextMuted,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kGreen,
                          decoration: TextDecoration.underline,
                        ),
                        // recognizer: TapGestureRecognizer()..onTap = () => _launchURL('...'),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kGreen,
                          decoration: TextDecoration.underline,
                        ),
                        // recognizer: TapGestureRecognizer()..onTap = () => _launchURL('...'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _requestOtp,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 20),
              label: _isLoading
                  ? const SizedBox.shrink()
                  : const Text(
                      'Request OTP',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.white,
                disabledBackgroundColor: kGreen.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, _otpBox),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Didn't receive OTP?  ",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: kTextMuted,
              ),
            ),
            GestureDetector(
              onTap: _canResend ? _resendOtp : null,
              child: _canResend
                  ? const Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kGreen,
                      ),
                    )
                  : Text(
                      'Resend in ${_resendSeconds}s',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kTextMuted,
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: GestureDetector(
            onTap: _changeNumber,
            child: const Text(
              'Change Number',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kGreen,
                decoration: TextDecoration.underline,
                decorationColor: kGreen,
              ),
            ),
          ),
        ),
        const SizedBox(height: 26),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _verifyAndCreate,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Icon(Icons.verified_user_rounded, size: 20),
            label: _isLoading
                ? const SizedBox.shrink()
                : const Text(
                    'Verify & Create',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              foregroundColor: Colors.white,
              disabledBackgroundColor: kGreen.withOpacity(0.6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 13,
                color: kTextMuted.withOpacity(0.7),
              ),
              const SizedBox(width: 5),
              const Text(
                'OTP valid for 10 min',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: kTextMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _otpBox(int i) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextField(
        controller: _otpControllers[i],
        focusNode: _otpFocusNodes[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: kTextDark,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: kSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kGreen, width: 2),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty) {
            if (i < 5) {
              _otpFocusNodes[i + 1].requestFocus();
            } else {
              _otpFocusNodes[i].unfocus();
              _verifyAndCreate();
            }
          } else if (i > 0) {
            _otpFocusNodes[i - 1].requestFocus();
          }
        },
      ),
    );
  }

  Widget _buildLoginLink() {
    if (_otpSent) return const SizedBox.shrink();

    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => LoginScreen(onSkip: widget.onSkip),
            ),
          );
        },
        style: TextButton.styleFrom(foregroundColor: kGreen),
        child: const Text.rich(
          TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: kTextMuted,
            ),
            children: [
              TextSpan(
                text: 'Login',
                style: TextStyle(fontWeight: FontWeight.w700, color: kGreen),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: Color(0xFFBDBDBD),
      ),
      prefixIcon: Icon(icon, color: kTextMuted, size: 20),
      filled: true,
      fillColor: kSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: kGreen, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      errorStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
    );
  }
}

class _PerkChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PerkChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _SignupScreenState.kGreen, size: 18),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: _SignupScreenState.kGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerkDivider extends StatelessWidget {
  const _PerkDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: _SignupScreenState.kGreen.withOpacity(0.16),
    );
  }
}
