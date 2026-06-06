import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════════
//  LOGO CONFIGURATION
// ════════════════════════════════════════════════════════════
const bool kUseImageLogo = true;
const String kLogoAssetPath = 'assets/images/cartkaro_logo.png';

/// Set true  → your PNG has a white/light background
/// Set false → your PNG is already transparent (use as-is)
const bool kLogoHasWhiteBg = false;

// ── BRAND COLOURS ────────────────────────────────────────────
const Color kRed = Color.fromARGB(255, 232, 6, 10);
const Color kRedLight = Color.fromARGB(255, 254, 243, 243);
const Color kBg = Color(0xFFFFF4EA);
const Color kSurface = Color(0xFFF6F6F6);
const Color kTextDark = Color(0xFF1A1A1A);
const Color kMuted = Color(0xFF757575);

// ════════════════════════════════════════════════════════════
//  COUNTRY MODEL & LIST
// ════════════════════════════════════════════════════════════
class Country {
  final String name, flag, dialCode;
  const Country({
    required this.name,
    required this.flag,
    required this.dialCode,
  });
}

const List<Country> kCountries = [
  Country(name: 'India', flag: '🇮🇳', dialCode: '+91'),
  Country(name: 'United States', flag: '🇺🇸', dialCode: '+1'),
  Country(name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44'),
  // ... (keeping the list slightly truncated here for brevity,
  // you can paste your full 70+ country list back here if you prefer)
  Country(name: 'Canada', flag: '🇨🇦', dialCode: '+1'),
  Country(name: 'Australia', flag: '🇦🇺', dialCode: '+61'),
];

// ════════════════════════════════════════════════════════════
//  PAINTED BAG + LOCK LOGO  (fallback)
// ════════════════════════════════════════════════════════════
class _BagPainter extends CustomPainter {
  final Color color;
  _BagPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final w = size.width, h = size.height;
    final hw = w * 0.44, hh = h * 0.30, hl = (w - w * 0.44) / 2;
    final arch = Path()
      ..addRRect(RRect.fromLTRBR(hl, 0, hl + hw, hh, Radius.circular(hw / 2)))
      ..addRRect(
        RRect.fromLTRBR(
          hl + hw * 0.27,
          hh * 0.14,
          hl + hw * 0.73,
          hh * 0.64,
          Radius.circular(hw * 0.23),
        ),
      );
    arch.fillType = PathFillType.evenOdd;
    canvas.drawPath(arch, p);
    final sH = h * 0.148, gap = h * 0.030, top = h * 0.315;
    final notch = w * 0.10, r = sH / 2;
    canvas.drawRRect(
      RRect.fromLTRBR(0, top, w, top + sH, Radius.circular(r)),
      p,
    );
    final s2 = top + sH + gap;
    canvas.drawRRect(
      RRect.fromLTRBR(notch, s2, w, s2 + sH, Radius.circular(r)),
      p,
    );
    final s3 = s2 + sH + gap;
    canvas.drawRRect(
      RRect.fromLTRBR(0, s3, w - notch, s3 + sH, Radius.circular(r)),
      p,
    );
  }

  @override
  bool shouldRepaint(_BagPainter o) => o.color != color;
}

// ════════════════════════════════════════════════════════════
//  LOGO WIDGET
// ════════════════════════════════════════════════════════════
class _Logo extends StatelessWidget {
  final double size;
  final Color color;
  final bool onWhiteBox;

  const _Logo({this.size = 36, this.color = kRed, this.onWhiteBox = false});

  @override
  Widget build(BuildContext context) {
    if (kUseImageLogo) {
      if (kLogoHasWhiteBg) {
        return Image.asset(
          kLogoAssetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          color: onWhiteBox ? null : Colors.white,
          colorBlendMode: onWhiteBox ? null : BlendMode.multiply,
          errorBuilder: _fallback,
        );
      } else {
        return Image.asset(
          kLogoAssetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
          color: onWhiteBox ? null : color,
          colorBlendMode: onWhiteBox ? null : BlendMode.srcIn,
          errorBuilder: _fallback,
        );
      }
    }
    return _fallbackWidget();
  }

  Widget _fallback(BuildContext ctx, Object err, StackTrace? st) =>
      _fallbackWidget();

  Widget _fallbackWidget() => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _BagPainter(onWhiteBox ? kRed : color)),
  );
}

// ════════════════════════════════════════════════════════════
//  RIPPLE PAINTER
// ════════════════════════════════════════════════════════════
class _RipplePainter extends CustomPainter {
  final double t;
  _RipplePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = Offset(size.width / 2, size.height / 2);
    final maxR = size.width * 0.95;

    for (int i = 0; i < 3; i++) {
      final phase = (t + i / 3) % 1.0;
      canvas.drawCircle(
        cx,
        maxR * 0.28 + maxR * 0.72 * phase,
        Paint()
          ..color = Colors.white.withOpacity((1 - phase) * 0.60)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }
  }

  @override
  bool shouldRepaint(_RipplePainter o) => o.t != t;
}

// ════════════════════════════════════════════════════════════
//  ANIMATED SKIP BUTTON
// ════════════════════════════════════════════════════════════
class _SkipButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SkipButton({required this.onTap});

  @override
  State<_SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<_SkipButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    reverseDuration: const Duration(milliseconds: 300),
  );

  late final Animation<double> _scale = Tween<double>(
    begin: 1.0,
    end: 0.92,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  late final Animation<Color?> _bg = ColorTween(
    begin: Colors.white,
    end: kRedLight,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  late final Animation<Color?> _border = ColorTween(
    begin: Colors.white,
    end: kRed,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  late final Animation<Color?> _textColor = ColorTween(
    begin: kRed,
    end: kRed,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  void _onTapDown(_) => _ac.forward();

  void _onTapUp(_) {
    _ac.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _ac.reverse();

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _ac,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _bg.value,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: _border.value ?? Colors.white,
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Skip',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textColor.value,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: _textColor.value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  HERO SECTION
// ════════════════════════════════════════════════════════════
class _HeroSection extends StatefulWidget {
  final VoidCallback onSkip;
  const _HeroSection({required this.onSkip});

  @override
  State<_HeroSection> createState() => _HeroState();
}

class _HeroState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: const BoxDecoration(
        color: kRed,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) =>
                  CustomPaint(painter: _RipplePainter(_ctrl.value)),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: const _Pill(
              dot: Color(0xFF22C55E),
              label: 'Order on the way!',
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: _SkipButton(onTap: widget.onSkip),
          ),
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: _Logo(size: 64, onWhiteBox: true),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 36,
            right: 22,
            child: const _Pill(dot: kRed, label: 'Delivery on time'),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final Color dot;
  final String label;
  const _Pill({required this.dot, required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.09),
          blurRadius: 12,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: kTextDark,
          ),
        ),
      ],
    ),
  );
}

// ════════════════════════════════════════════════════════════
//  COUNTRY PICKER BOTTOM SHEET
// ════════════════════════════════════════════════════════════
class CountryPickerSheet extends StatefulWidget {
  final Country selected;
  const CountryPickerSheet({super.key, required this.selected});

  @override
  State<CountryPickerSheet> createState() => _CPState();
}

class _CPState extends State<CountryPickerSheet> {
  final _sc = TextEditingController();
  List<Country> _list = kCountries;

  void _search(String q) => setState(
    () => _list = kCountries
        .where(
          (c) =>
              c.name.toLowerCase().contains(q.toLowerCase()) ||
              c.dialCode.contains(q),
        )
        .toList(),
  );

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Text(
                  'Select Country',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: kTextDark,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close_rounded,
                    color: kMuted,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _sc,
                onChanged: _search,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: kTextDark,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search country or dial code',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: kMuted,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: kMuted,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _list.length,
              itemBuilder: (ctx, i) {
                final c = _list[i];
                final sel =
                    c.dialCode == widget.selected.dialCode &&
                    c.name == widget.selected.name;
                return InkWell(
                  onTap: () => Navigator.pop(context, c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? kRedLight : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(c.flag, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            c.name,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: sel ? kRed : kTextDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: sel ? kRedLight : kSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: sel
                                ? Border.all(color: kRed.withOpacity(0.4))
                                : null,
                          ),
                          child: Text(
                            c.dialCode,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: sel ? kRed : kMuted,
                            ),
                          ),
                        ),
                        if (sel) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: kRed,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  LOGIN SCREEN
// ════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  final VoidCallback? onSkip;
  const LoginScreen({super.key, this.onSkip});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneCtrl = TextEditingController();
  final List<TextEditingController> _otpCtrl = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFN = List.generate(6, (_) => FocusNode());

  Country _country = kCountries.first;
  bool _loading = false;
  bool _otpSent = false;
  bool _canResend = false;
  int _resendSec = 30;
  Timer? _timer;
  String? _verificationId;
  int? _resendToken;
  ConfirmationResult? _webConfirmationResult;
  RecaptchaVerifier? _webRecaptchaVerifier;

  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _ac,
    curve: Curves.easeOut,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.06),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));

  @override
  void dispose() {
    _ac.dispose();
    _phoneCtrl.dispose();
    _timer?.cancel();
    _webRecaptchaVerifier?.clear();
    for (final c in _otpCtrl) {
      c.dispose();
    }
    for (final f in _otpFN) {
      f.dispose();
    }
    super.dispose();
  }

  void _skipToHome() {
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

  Future<void> _sendOtp({int? forceResendingToken}) async {
    final ph = _phoneCtrl.text.trim();
    if (ph.isEmpty || ph.length < 5) {
      _snack('Please enter a valid mobile number', err: true);
      return;
    }
    setState(() => _loading = true);

    final phoneNumber = '${_country.dialCode}$ph';
    if (kIsWeb) {
      await _sendWebOtp(phoneNumber, ph);
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      forceResendingToken: forceResendingToken,
      verificationCompleted: (credential) async {
        await _signInWithCredential(credential);
      },
      verificationFailed: (e) {
        // Add this line to see the detailed error in your debug console
        print(
          '🔥 Firebase verification failed! Code: ${e.code}, Message: ${e.message}',
        );
        if (!mounted) return;
        setState(() => _loading = false);
        _snack(_firebaseAuthErrorMessage(e), err: true);
      },
      codeSent: (verificationId, resendToken) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _otpSent = true;
          _verificationId = verificationId;
          _resendToken = resendToken;
        });
        _startTimer();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) _otpFN[0].requestFocus();
        });
        _snack('OTP sent to ${_country.dialCode} $ph');
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _sendWebOtp(String phoneNumber, String displayPhone) async {
    try {
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
            _snack('reCAPTCHA expired. Please request OTP again.', err: true);
          }
        },
        onError: (error) {
          if (mounted) {
            _snack('reCAPTCHA failed: $error', err: true);
          }
        },
      );

      final confirmationResult = await FirebaseAuth.instance
          .signInWithPhoneNumber(phoneNumber, _webRecaptchaVerifier);

      if (!mounted) return;
      setState(() {
        _loading = false;
        _otpSent = true;
        _webConfirmationResult = confirmationResult;
        _verificationId = null;
      });
      _startTimer();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _otpFN[0].requestFocus();
      });
      _snack('OTP sent to ${_country.dialCode} $displayPhone');
    } on FirebaseAuthException catch (e) {
      print(
        '🔥 Firebase web verification failed! Code: ${e.code}, Message: ${e.message}',
      );
      if (!mounted) return;
      setState(() => _loading = false);
      _snack(_firebaseAuthErrorMessage(e), err: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _snack('Could not start phone verification: $e', err: true);
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpCtrl.map((c) => c.text).join();
    if (otp.length < 6) {
      _snack('Please enter the complete 6-digit OTP', err: true);
      return;
    }
    if (kIsWeb) {
      final confirmationResult = _webConfirmationResult;
      if (confirmationResult == null) {
        _snack('Please request OTP again.', err: true);
        return;
      }
      setState(() => _loading = true);
      try {
        final userCredential = await confirmationResult.confirm(otp);
        await _handleSignedInUser(userCredential);
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        setState(() => _loading = false);
        _snack(_firebaseAuthErrorMessage(e), err: true);
      } catch (e) {
        if (!mounted) return;
        setState(() => _loading = false);
        _snack('An unexpected error occurred: $e', err: true);
      }
      return;
    }
    if (_verificationId == null) {
      _snack('Please request OTP again.', err: true);
      return;
    }
    setState(() => _loading = true);

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
      setState(() => _loading = false);
      _snack(_firebaseAuthErrorMessage(e), err: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _snack('An unexpected error occurred: $e', err: true);
    }
  }

  Future<void> _handleSignedInUser(UserCredential userCredential) async {
    if (!mounted) return;
    setState(() => _loading = false);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPhone', _phoneCtrl.text.trim());
    if (userCredential.user != null) {
      final user = userCredential.user!;
      await prefs.setString('firebaseUid', user.uid);

      // Check if user document exists in Firestore, if not, create it.
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        // This user logged in but didn't have a Firestore document.
        // We create one with basic information.
        await userDocRef.set({
          'uid': user.uid,
          'phone':
              user.phoneNumber, // Use the phone number from the auth credential
          'name': 'User', // A default name they can change later
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    _snack('Login successful! Welcome back');
    if (!mounted) return;
    // The AuthGate will handle navigation. We just need to pop the auth flow.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _resendSec = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_resendSec <= 1) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _resendSec--);
      }
    });
  }

  Future<void> _resend() async {
    if (!_canResend) return;
    for (final c in _otpCtrl) {
      c.clear();
    }
    _otpFN[0].requestFocus();
    await _sendOtp(forceResendingToken: _resendToken);
  }

  void _changeNum() {
    _timer?.cancel();
    for (final c in _otpCtrl) {
      c.clear();
    }
    setState(() {
      _otpSent = false;
      _canResend = false;
      _resendSec = 30;
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

  void _snack(String msg, {bool err = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
        ),
        backgroundColor: err ? Colors.redAccent : kRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          _HeroSection(onSkip: _skipToHome),

          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          _Logo(size: 34, color: kRed, onWhiteBox: false),
                          SizedBox(width: 10),
                          Text(
                            'Cartkaro',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: kRed,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        _otpSent ? 'Enter OTP 🔐' : 'Welcome back! 👋',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: kTextDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _otpSent
                            ? 'We sent a 6-digit code to\n${_country.dialCode} ${_phoneCtrl.text.trim()}'
                            : 'Log in to continue fast deliveries',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: kMuted,
                        ),
                      ),

                      const SizedBox(height: 26),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.04, 0),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: _otpSent
                            ? _otpStep(key: const ValueKey('otp'))
                            : _mobileStep(key: const ValueKey('mob')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileStep({Key? key}) => Column(
    key: key,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
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
                  color: kRedLight,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_country.flag, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      _country.dialCode,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kRed,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: kRed,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
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
                maxLength: 15,
                onSubmitted: (_) => _sendOtp(),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 13,
            color: kMuted.withOpacity(0.7),
          ),
          const SizedBox(width: 6),
          const Text(
            'You will receive a 6-digit OTP via SMS',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: kMuted,
            ),
          ),
        ],
      ),
      const SizedBox(height: 26),
      _btn('Send OTP', Icons.send_rounded, _sendOtp),
      const SizedBox(height: 18),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 18.0, // Horizontal space between chips
        runSpacing: 10.0, // Vertical space if they wrap
        children: const [
          _Chip(icon: Icons.security_rounded, label: 'Secure OTP'),
          _Chip(icon: Icons.verified_rounded, label: '100k+ users'),
          _Chip(icon: Icons.bolt_rounded, label: 'Delivery on time'),
        ],
      ),
    ],
  );

  Widget _otpStep({Key? key}) => Column(
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
              color: kMuted,
            ),
          ),
          GestureDetector(
            onTap: _canResend ? _resend : null,
            child: _canResend
                ? const Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kRed,
                    ),
                  )
                : Text(
                    'Resend in ${_resendSec}s',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kMuted,
                    ),
                  ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Center(
        child: GestureDetector(
          onTap: _changeNum,
          child: const Text(
            'Change Number',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kRed,
              decoration: TextDecoration.underline,
              decorationColor: kRed,
            ),
          ),
        ),
      ),
      const SizedBox(height: 26),
      _btn('Verify & Login', Icons.verified_user_rounded, _verifyOtp),
      const SizedBox(height: 14),
      Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 13,
              color: kMuted.withOpacity(0.7),
            ),
            const SizedBox(width: 5),
            const Text(
              'End-to-end encrypted · OTP valid for 10 min',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: kMuted,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _otpBox(int i) => SizedBox(
    width: 46,
    height: 56,
    child: TextField(
      controller: _otpCtrl[i],
      focusNode: _otpFN[i],
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
          borderSide: const BorderSide(color: kRed, width: 2),
        ),
      ),
      onChanged: (v) {
        if (v.isNotEmpty) {
          if (i < 5) {
            _otpFN[i + 1].requestFocus();
          } else {
            _otpFN[i].unfocus();
            _verifyOtp();
          }
        } else if (i > 0) {
          _otpFN[i - 1].requestFocus();
        }
      },
    ),
  );

  Widget _btn(String label, IconData icon, VoidCallback onTap) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton.icon(
      onPressed: _loading ? null : onTap,
      icon: _loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Icon(icon, size: 20),
      label: _loading
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
        backgroundColor: kRed,
        foregroundColor: Colors.white,
        disabledBackgroundColor: kRed.withOpacity(0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════
//  TRUST CHIP
// ════════════════════════════════════════════════════════════
class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: kRed),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: kRed,
        ),
      ),
    ],
  );
}
