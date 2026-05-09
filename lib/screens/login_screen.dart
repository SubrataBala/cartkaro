// lib/screens/login_screen.dart
// Cartkaro – Quick Commerce App
// OTP-based Login Screen

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _mobileController = TextEditingController();

  // OTP controllers – one per digit box
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _otpSent = false;          // toggles between Step 1 and Step 2
  bool _canResend = false;
  int _resendSeconds = 30;
  Timer? _resendTimer;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Brand Colors ──────────────────────────────────────────────
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
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _mobileController.dispose();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  // ── Step 1: Request OTP ───────────────────────────────────────
  void _requestOtp() async {
    final mobile = _mobileController.text.trim();
    if (mobile.length != 10) {
      _showSnack('Please enter a valid 10-digit mobile number',
          isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Replace with real OTP send API call (e.g. Firebase, MSG91, Twilio)
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _otpSent = true;
    });

    _startResendTimer();
    // Auto-focus first OTP box
    Future.delayed(const Duration(milliseconds: 200),
        () => _otpFocusNodes[0].requestFocus());

    _showSnack('OTP sent to +91 $mobile');
  }

  // ── Step 2: Verify OTP ────────────────────────────────────────
  void _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      _showSnack('Please enter the complete 6-digit OTP', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Replace with real OTP verification API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (mounted) {
      _showSnack('Login successful! Welcome back 🎉');
      // TODO: Navigate to home screen
      Navigator.pop(context);
    }
  }

  // ── Resend Timer ──────────────────────────────────────────────
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

  void _resendOtp() async {
    if (!_canResend) return;
    // Clear OTP boxes
    for (final c in _otpControllers) c.clear();
    _otpFocusNodes[0].requestFocus();
    _startResendTimer();

    // TODO: Re-send OTP via API
    await Future.delayed(const Duration(milliseconds: 500));
    _showSnack('OTP resent to +91 ${_mobileController.text.trim()}');
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

  // ── Go back to Step 1 ─────────────────────────────────────────
  void _changeNumber() {
    _resendTimer?.cancel();
    for (final c in _otpControllers) c.clear();
    setState(() {
      _otpSent = false;
      _canResend = false;
      _resendSeconds = 30;
    });
  }

  // ─────────────────────────────────────────────────────────────
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

                  // Back Button
                  GestureDetector(
                    onTap: _otpSent ? _changeNumber : () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: kSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: kTextDark),
                    ),
                  ),

                  const SizedBox(height: 36),

                  _buildHeader(),
                  const SizedBox(height: 40),

                  // Show either Step 1 or Step 2
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
                        : _buildMobileStep(key: const ValueKey('mobile')),
                  ),

                  const SizedBox(height: 32),
                  _buildDivider(),
                  const SizedBox(height: 28),
                  _buildSignupLink(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.shopping_cart_rounded,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Cartkaro',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: kGreen,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          _otpSent ? 'Enter OTP 🔐' : 'Welcome back! 👋',
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
              ? 'We sent a 6-digit code to\n+91 ${_mobileController.text.trim()}'
              : 'Log in to continue fast deliveries',
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

  // ── Step 1: Mobile Number ─────────────────────────────────────
  Widget _buildMobileStep({Key? key}) {
    return Column(
      key: key,
      children: [
        // Mobile field
        Container(
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              // Country code pill
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: kGreenLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '🇮🇳  +91',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kGreen,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
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
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: (_) => _requestOtp(),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Helper text
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 13, color: kTextMuted.withOpacity(0.7)),
              const SizedBox(width: 6),
              const Text(
                'You will receive a 6-digit OTP via SMS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: kTextMuted,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),
        _buildPrimaryButton(
          label: 'Send OTP',
          icon: Icons.send_rounded,
          onTap: _requestOtp,
        ),
      ],
    );
  }

  // ── Step 2: OTP Entry ─────────────────────────────────────────
  Widget _buildOtpStep({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // OTP boxes row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (i) => _buildOtpBox(i)),
        ),

        const SizedBox(height: 24),

        // Resend row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Didn't receive OTP? ",
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

        // Change number
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
              ),
            ),
          ),
        ),

        const SizedBox(height: 28),

        _buildPrimaryButton(
          label: 'Verify & Login',
          icon: Icons.verified_user_rounded,
          onTap: _verifyOtp,
        ),
      ],
    );
  }

  // ── Single OTP Box ────────────────────────────────────────────
  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 48,
      height: 58,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
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
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: kGreen, width: 2),
          ),
        ),
        onChanged: (val) {
          if (val.isNotEmpty) {
            // Move to next box
            if (index < 5) {
              _otpFocusNodes[index + 1].requestFocus();
            } else {
              _otpFocusNodes[index].unfocus();
              // Auto-verify when last digit entered
              _verifyOtp();
            }
          } else {
            // Move back on delete
            if (index > 0) _otpFocusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  // ── Primary Button ────────────────────────────────────────────
  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onTap,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
            : Icon(icon, size: 20),
        label: _isLoading
            ? const SizedBox.shrink()
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF4CAF50).withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // ── Divider ───────────────────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'New to Cartkaro?',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: kTextMuted,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
      ],
    );
  }

  // ── Signup Link ───────────────────────────────────────────────
  Widget _buildSignupLink() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SignupScreen()));
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: kGreen,
          side: const BorderSide(color: kGreen, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text(
          'Create an Account',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}