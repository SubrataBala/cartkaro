import 'dart:async';
import 'dart:math' as math;
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
const bool kLogoHasWhiteBg = false;

// ── BRAND COLOURS ────────────────────────────────────────────
const Color kRed      = Color.fromARGB(255, 232, 6, 10);
const Color kRedDark  = Color.fromARGB(255, 150, 4, 8);
const Color kRedLight = Color.fromARGB(255, 254, 235, 235);
const Color kBg       = Color(0xFFFAFAFA);
const Color kSurface  = Color(0xFFF2F2F2);
const Color kTextDark = Color(0xFF111111);
const Color kMuted    = Color(0xFF888888);

// ════════════════════════════════════════════════════════════
//  COUNTRY MODEL & LIST
// ════════════════════════════════════════════════════════════
class Country {
  final String name, flag, dialCode;
  const Country({required this.name, required this.flag, required this.dialCode});
}

const List<Country> kCountries = [
  Country(name: 'India',         flag: '🇮🇳', dialCode: '+91'),
  Country(name: 'United States', flag: '🇺🇸', dialCode: '+1'),
  Country(name: 'United Kingdom',flag: '🇬🇧', dialCode: '+44'),
  Country(name: 'Canada',        flag: '🇨🇦', dialCode: '+1'),
  Country(name: 'Australia',     flag: '🇦🇺', dialCode: '+61'),
  // ← paste your full country list here
];

// ════════════════════════════════════════════════════════════
//  FALLBACK PAINTER
// ════════════════════════════════════════════════════════════
class _BagPainter extends CustomPainter {
  final Color color;
  _BagPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p  = Paint()..color = color..style = PaintingStyle.fill;
    final w  = size.width;
    final h  = size.height;
    final hw = w * 0.44;
    final hh = h * 0.30;
    final hl = (w - hw) / 2;
    final arch = Path()
      ..addRRect(RRect.fromLTRBR(hl, 0, hl + hw, hh, Radius.circular(hw / 2)))
      ..addRRect(RRect.fromLTRBR(hl + hw * 0.27, hh * 0.14, hl + hw * 0.73, hh * 0.64, Radius.circular(hw * 0.23)));
    arch.fillType = PathFillType.evenOdd;
    canvas.drawPath(arch, p);

    final sH  = h * 0.148;
    final gap = h * 0.030;
    final top = h * 0.315;
    final notch = w * 0.10;
    final r     = sH / 2;
    canvas.drawRRect(RRect.fromLTRBR(0, top, w, top + sH, Radius.circular(r)), p);
    final s2 = top + sH + gap;
    canvas.drawRRect(RRect.fromLTRBR(notch, s2, w, s2 + sH, Radius.circular(r)), p);
    final s3 = s2 + sH + gap;
    canvas.drawRRect(RRect.fromLTRBR(0, s3, w - notch, s3 + sH, Radius.circular(r)), p);
  }

  @override
  bool shouldRepaint(_BagPainter o) => o.color != color;
}

// ════════════════════════════════════════════════════════════
//  BRAND LOGO WIDGET
// ════════════════════════════════════════════════════════════
class BrandLogo extends StatelessWidget {
  final double size;
  final Color  color;
  final bool   onWhiteBox;
  const BrandLogo({super.key, this.size = 36, this.color = kRed, this.onWhiteBox = false});

  @override
  Widget build(BuildContext context) {
    if (kUseImageLogo) {
      if (kLogoHasWhiteBg) {
        return Image.asset(kLogoAssetPath, width: size, height: size, fit: BoxFit.contain,
            color: onWhiteBox ? null : Colors.white,
            colorBlendMode: onWhiteBox ? null : BlendMode.multiply,
            errorBuilder: _fallback);
      } else {
        return Image.asset(kLogoAssetPath, width: size, height: size, fit: BoxFit.contain,
            color: onWhiteBox ? null : color,
            colorBlendMode: onWhiteBox ? null : BlendMode.srcIn,
            errorBuilder: _fallback);
      }
    }
    return _fallbackWidget();
  }

  Widget _fallback(BuildContext ctx, Object err, StackTrace? st) => _fallbackWidget();
  Widget _fallbackWidget() => SizedBox(
        width: size, height: size,
        child: CustomPaint(painter: _BagPainter(onWhiteBox ? kRed : color)));
}

// ════════════════════════════════════════════════════════════
//  WAVE BACKGROUND PAINTER — diagonal animated gradient sweep
// ════════════════════════════════════════════════════════════
class _WavePainter extends CustomPainter {
  final double t;
  _WavePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Main gradient fill
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [kRed, kRedDark],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Animated floating blobs
    final blobPaint = Paint()..color = Colors.white.withOpacity(0.06);
    for (int i = 0; i < 3; i++) {
      final angle  = t * 2 * math.pi + i * (2 * math.pi / 3);
      final bx     = w * 0.5 + math.cos(angle) * w * 0.25;
      final by     = h * 0.5 + math.sin(angle) * h * 0.18;
      canvas.drawCircle(Offset(bx, by), w * 0.35, blobPaint);
    }

    // Bottom curved cutoff
    final curve = Path()
      ..moveTo(0, h * 0.80)
      ..quadraticBezierTo(w * 0.25, h * 0.88, w * 0.5, h * 0.84)
      ..quadraticBezierTo(w * 0.75, h * 0.80, w, h * 0.87)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(curve, Paint()..color = Colors.white.withOpacity(0.07));
  }

  @override
  bool shouldRepaint(_WavePainter o) => o.t != t;
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
        () => _list = kCountries.where((c) =>
              c.name.toLowerCase().contains(q.toLowerCase()) ||
              c.dialCode.contains(q)).toList());

  @override
  void dispose() { _sc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 4),
          width: 40, height: 4,
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
          child: Row(children: [
            const Text('Select Country', style: TextStyle(fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w700, color: kTextDark)),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: kSurface, shape: BoxShape.circle),
                child: const Icon(Icons.close_rounded, color: kMuted, size: 18),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Container(
            decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(14)),
            child: TextField(
              controller: _sc,
              onChanged: _search,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: kTextDark),
              decoration: const InputDecoration(
                hintText: 'Search country or dial code',
                hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: kMuted),
                prefixIcon: Icon(Icons.search_rounded, color: kMuted, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            itemCount: _list.length,
            itemBuilder: (ctx, i) {
              final c   = _list[i];
              final sel = c.dialCode == widget.selected.dialCode && c.name == widget.selected.name;
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.pop(context, c),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: sel ? kRedLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: sel ? Border.all(color: kRed.withOpacity(0.35)) : null,
                  ),
                  child: Row(children: [
                    Container(width: 36, height: 36, alignment: Alignment.center,
                      decoration: const BoxDecoration(color: kSurface, shape: BoxShape.circle),
                      child: Text(c.flag, style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(c.name, style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w500, color: sel ? kRed : kTextDark))),
                    Text(c.dialCode, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: sel ? kRed : kMuted)),
                    if (sel) ...[const SizedBox(width: 8), const Icon(Icons.check_circle_rounded, color: kRed, size: 18)],
                  ]),
                ),
              );
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  LOGIN SCREEN — fully redesigned UI, logic UNCHANGED
// ════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  final VoidCallback? onSkip;
  const LoginScreen({super.key, this.onSkip});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> with TickerProviderStateMixin {
  // ── Controllers (UNCHANGED) ──────────────────────────────
  final _phoneCtrl = TextEditingController();
  final List<TextEditingController> _otpCtrl = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFN = List.generate(6, (_) => FocusNode());
  Country _country = kCountries.first;
  bool _loading = false;
  bool _otpSent = false;
  bool _canResend = false;
  int  _resendSec = 30;
  Timer?  _timer;
  String? _verificationId;
  int?    _resendToken;
  ConfirmationResult? _webConfirmationResult;
  RecaptchaVerifier?  _webRecaptchaVerifier;

  // ── Animation controllers ────────────────────────────────
  late final AnimationController _bgCtrl = AnimationController(
    vsync: this, duration: const Duration(seconds: 6))..repeat();

  late final AnimationController _cardCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 700));

  late final AnimationController _switchCtrl = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 400));

  late final Animation<double> _cardFade = CurvedAnimation(
    parent: _cardCtrl, curve: Curves.easeOut);

  late final Animation<Offset> _cardSlide = Tween<Offset>(
    begin: const Offset(0, 0.08), end: Offset.zero).animate(
    CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut));

  late final Animation<double> _switchFade = CurvedAnimation(
    parent: _switchCtrl, curve: Curves.easeInOut);

  // ── Phone field focus for styling ────────────────────────
  final FocusNode _phoneFN = FocusNode();

  @override
  void initState() {
    super.initState();
    _cardCtrl.forward();
    _phoneFN.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _cardCtrl.dispose();
    _switchCtrl.dispose();
    _phoneCtrl.dispose();
    _phoneFN.dispose();
    _timer?.cancel();
    _webRecaptchaVerifier?.clear();
    for (final c in _otpCtrl) c.dispose();
    for (final f in _otpFN)   f.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════
  //  ALL LOGIC BELOW IS IDENTICAL TO ORIGINAL — ZERO CHANGES
  // ════════════════════════════════════════════════════════
  void _skipToHome() => widget.onSkip?.call();

  Future<void> _pickCountry() async {
    final r = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      builder: (_) => CountryPickerSheet(selected: _country),
    );
    if (r != null) setState(() => _country = r);
  }

  Future<void> _sendOtp({int? forceResendingToken}) async {
    final ph = _phoneCtrl.text.trim();
    if (ph.isEmpty || ph.length < 5) { _snack('Please enter a valid mobile number', err: true); return; }
    setState(() => _loading = true);
    final phoneNumber = '${_country.dialCode}$ph';
    await FirebaseAuth.instance.setLanguageCode('en');
    if (kIsWeb) { await _sendWebOtp(phoneNumber, ph); return; }
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        forceResendingToken: forceResendingToken,
        verificationCompleted: (credential) async => await _signInWithCredential(credential),
        verificationFailed: (e) {
          if (!mounted) return;
          setState(() => _loading = false);
          _snack(_firebaseAuthErrorMessage(e), err: true);
        },
        codeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() {
            _loading = false; _otpSent = true;
            _verificationId = verificationId; _resendToken = resendToken;
          });
          _switchCtrl.forward(from: 0);
          _startTimer();
          Future.delayed(const Duration(milliseconds: 200), () { if (mounted) _otpFN[0].requestFocus(); });
          _snack('OTP sent to ${_country.dialCode} $ph');
        },
        codeAutoRetrievalTimeout: (verificationId) { _verificationId = verificationId; },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _snack(_firebaseAuthErrorMessage(e), err: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _snack('Could not start phone verification. Please try again.', err: true);
    }
  }

  Future<void> _sendWebOtp(String phoneNumber, String displayPhone) async {
    try {
      await FirebaseAuth.instance.setLanguageCode('en');
      _webRecaptchaVerifier?.clear();
      _webRecaptchaVerifier = RecaptchaVerifier(
        auth: FirebaseAuthPlatform.instanceFor(app: FirebaseAuth.instance.app, pluginConstants: const {}),
        theme: RecaptchaVerifierTheme.light,
        onExpired: () { if (mounted) _snack('reCAPTCHA expired. Please request OTP again.', err: true); },
        onError: (error) { if (mounted) _snack('reCAPTCHA failed: $error', err: true); },
      );
      final confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber, _webRecaptchaVerifier);
      if (!mounted) return;
      setState(() { _loading = false; _otpSent = true; _webConfirmationResult = confirmationResult; _verificationId = null; });
      _switchCtrl.forward(from: 0);
      _startTimer();
      Future.delayed(const Duration(milliseconds: 200), () { if (mounted) _otpFN[0].requestFocus(); });
      _snack('OTP sent to ${_country.dialCode} $displayPhone');
    } on FirebaseAuthException catch (e) {
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
    if (otp.length < 6) { _snack('Please enter the complete 6-digit OTP', err: true); return; }
    if (kIsWeb) {
      final confirmationResult = _webConfirmationResult;
      if (confirmationResult == null) { _snack('Please request OTP again.', err: true); return; }
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
    if (_verificationId == null) { _snack('Please request OTP again.', err: true); return; }
    setState(() => _loading = true);
    final credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: otp);
    await _signInWithCredential(credential);
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
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
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc    = await userDocRef.get();
      if (!userDoc.exists) {
        await userDocRef.set({'uid': user.uid, 'phone': user.phoneNumber, 'name': 'User', 'createdAt': FieldValue.serverTimestamp()});
      }
    }
    _snack('Login successful! Welcome back');
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _startTimer() {
    setState(() { _canResend = false; _resendSec = 30; });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_resendSec <= 1) { t.cancel(); setState(() => _canResend = true); }
      else { setState(() => _resendSec--); }
    });
  }

  Future<void> _resend() async {
    if (!_canResend) return;
    for (final c in _otpCtrl) c.clear();
    _otpFN[0].requestFocus();
    await _sendOtp(forceResendingToken: _resendToken);
  }

  void _changeNum() {
    _timer?.cancel();
    for (final c in _otpCtrl) c.clear();
    setState(() { _otpSent = false; _canResend = false; _resendSec = 30; _verificationId = null; _resendToken = null; });
    _switchCtrl.reverse();
  }

  String _firebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':       return 'Please enter a valid phone number.';
      case 'invalid-verification-code':  return 'The OTP is incorrect. Please check and try again.';
      case 'session-expired':            return 'OTP expired. Please request a new one.';
      case 'too-many-requests':          return 'Too many attempts. Please wait and try again later.';
      case 'network-request-failed':     return 'Network error. Please check your internet connection.';
      case 'app-not-authorized':
      case 'missing-client-identifier':  return 'Firebase phone auth is not configured for this app yet.';
      default: return e.message ?? 'Firebase authentication failed.';
    }
  }

  void _snack(String msg, {bool err = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13)),
      backgroundColor: err ? Colors.redAccent : kRed,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ════════════════════════════════════════════════════════
  //  BUILD — COMPLETELY NEW VISUAL LAYOUT
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final mq     = MediaQuery.of(context);
    final bottom = mq.padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      resizeToAvoidBottomInset: true,
      body: AnimatedBuilder(
        animation: Listenable.merge([_bgCtrl, _cardCtrl]),
        builder: (context, _) {
          return Stack(
            children: [
              // ── 1. Animated gradient top section ──────────────
              Positioned(
                top: 0, left: 0, right: 0,
                height: mq.size.height * 0.46,
                child: CustomPaint(painter: _WavePainter(_bgCtrl.value)),
              ),

              // ── 2. Skip button top-right ───────────────────────
              Positioned(
                top: mq.padding.top + 14,
                right: 20,
                child: _SkipBtn(onTap: _skipToHome),
              ),

              // ── 3. Logo + tagline in hero ──────────────────────
              Positioned(
                top: mq.padding.top + 10,
                left: 0, right: 0,
                child: Column(children: [
                  const SizedBox(height: 20),
                  // Logo box
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 12)),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: BrandLogo(size: 56, onWhiteBox: true),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'CartKaro',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Text(
                      '⚡ Fast • Reliable • On Time',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.5,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ]),
              ),

              // ── 4. Floating card ───────────────────────────────
              Positioned(
                top: mq.size.height * 0.37,
                left: 0, right: 0, bottom: 0,
                child: FadeTransition(
                  opacity: _cardFade,
                  child: SlideTransition(
                    position: _cardSlide,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(color: Color(0x1A000000), blurRadius: 40, offset: Offset(0, -8)),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(24, 28, 24, bottom + 32),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 380),
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
                              ? _OtpPanel(key: const ValueKey('otp'), state: this)
                              : _PhonePanel(key: const ValueKey('phone'), state: this),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  PHONE PANEL
// ════════════════════════════════════════════════════════════
class _PhonePanel extends StatelessWidget {
  final _LoginState state;
  const _PhonePanel({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: kRedLight, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.phone_iphone_rounded, color: kRed, size: 22),
          ),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Sign In', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: kTextDark, height: 1.1)),
            Text('Enter your mobile number', style: TextStyle(fontFamily: 'Poppins', fontSize: 12.5, color: kMuted)),
          ]),
        ]),

        const SizedBox(height: 28),

        // Label
        const Text('Mobile Number', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: kTextDark)),
        const SizedBox(height: 8),

        // Phone input
        _PhoneInputRow(state: state),

        const SizedBox(height: 10),
        Row(children: [
          Icon(Icons.info_outline_rounded, size: 12, color: kMuted.withOpacity(0.7)),
          const SizedBox(width: 6),
          const Text('6-digit OTP will be sent via SMS', style: TextStyle(fontFamily: 'Poppins', fontSize: 11.5, color: kMuted)),
        ]),

        const SizedBox(height: 26),

        // CTA
        _CTA(
          label: 'Get OTP',
          icon: Icons.arrow_forward_rounded,
          loading: state._loading,
          onTap: state._sendOtp,
        ),

        const SizedBox(height: 28),

        // Trust row
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: const [
          _TrustBadge(icon: Icons.security_rounded,  label: 'Secure'),
          _TrustBadge(icon: Icons.verified_rounded,   label: '100k+ Users'),
          _TrustBadge(icon: Icons.bolt_rounded,       label: 'On Time'),
        ]),

        const SizedBox(height: 16),
        Center(
          child: Text(
            'By continuing, you agree to our Terms & Privacy Policy',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: kMuted),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  PHONE INPUT ROW (country + number)
// ════════════════════════════════════════════════════════════
class _PhoneInputRow extends StatefulWidget {
  final _LoginState state;
  const _PhoneInputRow({required this.state});

  @override
  State<_PhoneInputRow> createState() => _PhoneInputRowState();
}

class _PhoneInputRowState extends State<_PhoneInputRow> {
  final FocusNode _fn = FocusNode();

  @override
  void initState() {
    super.initState();
    _fn.addListener(() => setState(() {}));
  }

  @override
  void dispose() { _fn.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final focused = _fn.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: focused ? kRed : Colors.transparent, width: 1.8),
        boxShadow: focused
            ? [BoxShadow(color: kRed.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 4))]
            : [],
      ),
      child: Row(children: [
        // Country chip
        GestureDetector(
          onTap: widget.state._pickCountry,
          child: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
            decoration: BoxDecoration(
              color: kRedLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(widget.state._country.flag, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(widget.state._country.dialCode,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: kRed)),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more_rounded, color: kRed, size: 18),
            ]),
          ),
        ),

        Container(width: 1, height: 28, color: Colors.black.withOpacity(0.07)),

        Expanded(
          child: TextField(
            controller: widget.state._phoneCtrl,
            focusNode: _fn,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: kTextDark, letterSpacing: 1.5),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 15,
            onSubmitted: (_) => widget.state._sendOtp(),
            decoration: const InputDecoration(
              hintText: 'Mobile number',
              hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFFBBBBBB), letterSpacing: 0, fontWeight: FontWeight.w400),
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  OTP PANEL
// ════════════════════════════════════════════════════════════
class _OtpPanel extends StatelessWidget {
  final _LoginState state;
  const _OtpPanel({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Header
      Row(children: [
        GestureDetector(
          onTap: state._changeNum,
          child: Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.arrow_back_rounded, color: kTextDark, size: 20),
          ),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('Verify OTP', style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w800, color: kTextDark, height: 1.1)),
          Text('Check your SMS inbox', style: TextStyle(fontFamily: 'Poppins', fontSize: 12.5, color: kMuted)),
        ]),
      ]),

      const SizedBox(height: 8),

      // Phone reminder
      Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: kRedLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kRed.withOpacity(0.2)),
        ),
        child: Row(children: [
          const Icon(Icons.phone_iphone_rounded, color: kRed, size: 16),
          const SizedBox(width: 8),
          Text(
            'OTP sent to ${state._country.dialCode} ${state._phoneCtrl.text.trim()}',
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500, color: kRed),
          ),
        ]),
      ),

      const SizedBox(height: 24),

      const Text('Enter OTP', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: kTextDark)),
      const SizedBox(height: 12),

      // OTP boxes
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (i) => _OtpBox(index: i, state: state)),
      ),

      const SizedBox(height: 20),

      // Resend row
      Center(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Text("Didn't get it?  ", style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: kMuted)),
          GestureDetector(
            onTap: state._canResend ? state._resend : null,
            child: state._canResend
                ? const Text('Resend OTP', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: kRed))
                : Text('Resend in ${state._resendSec}s', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: kMuted)),
          ),
        ]),
      ),

      const SizedBox(height: 26),

      _CTA(
        label: 'Verify & Continue',
        icon: Icons.verified_user_rounded,
        loading: state._loading,
        onTap: state._verifyOtp,
      ),

      const SizedBox(height: 16),
      Center(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock_outline_rounded, size: 12, color: kMuted.withOpacity(0.7)),
          const SizedBox(width: 5),
          const Text('End-to-end encrypted · valid for 10 min',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: kMuted)),
        ]),
      ),
    ]);
  }
}

// ════════════════════════════════════════════════════════════
//  OTP BOX
// ════════════════════════════════════════════════════════════
class _OtpBox extends StatelessWidget {
  final int index;
  final _LoginState state;
  const _OtpBox({required this.index, required this.state});

  @override
  Widget build(BuildContext context) {
    final i = index;
    return AnimatedBuilder(
      animation: Listenable.merge([state._otpFN[i], state._otpCtrl[i]]),
      builder: (_, __) {
        final focused = state._otpFN[i].hasFocus;
        final filled  = state._otpCtrl[i].text.isNotEmpty;
        return SizedBox(
          width: 46, height: 58,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: filled ? kRedLight : kSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: focused ? kRed : (filled ? kRed.withOpacity(0.3) : Colors.transparent), width: 1.8),
              boxShadow: focused
                  ? [BoxShadow(color: kRed.withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 4))]
                  : [],
            ),
            child: TextField(
              controller: state._otpCtrl[i],
              focusNode: state._otpFN[i],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: filled ? kRed : kTextDark,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(counterText: '', border: InputBorder.none, contentPadding: EdgeInsets.zero),
              onChanged: (v) {
                if (v.isNotEmpty) {
                  if (i < 5) state._otpFN[i + 1].requestFocus();
                  else { state._otpFN[i].unfocus(); state._verifyOtp(); }
                } else if (i > 0) {
                  state._otpFN[i - 1].requestFocus();
                }
              },
            ),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════
//  CTA GRADIENT BUTTON with shine sweep
// ════════════════════════════════════════════════════════════
class _CTA extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool loading;
  final VoidCallback onTap;
  const _CTA({required this.label, required this.icon, required this.loading, required this.onTap});

  @override
  State<_CTA> createState() => _CTAState();
}

class _CTAState extends State<_CTA> with SingleTickerProviderStateMixin {
  late final AnimationController _shine = AnimationController(
    vsync: this, duration: const Duration(milliseconds: 2000))..repeat();
  bool _pressed = false;

  @override
  void dispose() { _shine.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp:   (_) { setState(() => _pressed = false); if (!widget.loading) widget.onTap(); },
      onTapCancel: ()  => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: _shine,
          builder: (_, __) => Container(
            height: 58,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kRed, kRedDark],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: kRed.withOpacity(0.40), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(alignment: Alignment.center, children: [
                // Shine
                if (!widget.loading)
                  Positioned(
                    left: -80 + (_shine.value * 380),
                    top: 0, bottom: 0,
                    child: Transform.rotate(
                      angle: 0.5,
                      child: Container(
                        width: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.20),
                            Colors.white.withOpacity(0),
                          ]),
                        ),
                      ),
                    ),
                  ),
                widget.loading
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(widget.icon, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(widget.label,
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.3)),
                      ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  SKIP BUTTON (top-right, minimal)
// ════════════════════════════════════════════════════════════
class _SkipBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _SkipBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white.withOpacity(0.35)),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Text('Skip', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward_ios_rounded, size: 11, color: Colors.white),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  TRUST BADGE
// ════════════════════════════════════════════════════════════
class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String   label;
  const _TrustBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
    Container(
      width: 44, height: 44,
      decoration: BoxDecoration(color: kRedLight, shape: BoxShape.circle),
      child: Icon(icon, color: kRed, size: 20),
    ),
    const SizedBox(height: 6),
    Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: kMuted)),
  ]);
}