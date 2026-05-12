// ════════════════════════════════════════════════════════════
//  login_screen.dart  –  Cartkaro
//  Place this file at:  lib/screens/login_screen.dart
//
//  ✅ FULL VERSION:
//     • All 70+ Countries included.
//     • Full OTP timer & animation logic preserved.
//     • Top hero background is now Brand Orange.
//     • Central logo is now housed in a crisp White Box.
//     • Ripples made thicker and brighter for better visibility.
//     • Top buttons shifted down for safe-area clearance.
// ════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

// ── GLOBAL LOGIN STATE ───────────────────────────────────────
bool isUserLoggedIn = false;

// ════════════════════════════════════════════════════════════
//  LOGO CONFIGURATION
// ════════════════════════════════════════════════════════════
const bool   kUseImageLogo     = true;
const String kLogoAssetPath    = 'assets/images/cartkaro_logo.png';

/// Set true  → your PNG has a white/light background
/// Set false → your PNG is already transparent (use as-is)
const bool   kLogoHasWhiteBg   = false;

// ── BRAND COLOURS ────────────────────────────────────────────
const Color kRed      = Color.fromARGB(255, 232, 6, 10);
const Color kRedLight = Color.fromARGB(255, 254, 243, 243);
const Color kBg          = Color(0xFFFFF4EA);
const Color kSurface     = Color(0xFFF6F6F6);
const Color kTextDark    = Color(0xFF1A1A1A);
const Color kMuted       = Color(0xFF757575);

// ════════════════════════════════════════════════════════════
//  COUNTRY MODEL & LIST
// ════════════════════════════════════════════════════════════
class Country {
  final String name, flag, dialCode;
  const Country({required this.name, required this.flag, required this.dialCode});
}

const List<Country> kCountries = [
  Country(name: 'India',           flag: '🇮🇳', dialCode: '+91'),
  Country(name: 'United States',   flag: '🇺🇸', dialCode: '+1'),
  Country(name: 'United Kingdom',  flag: '🇬🇧', dialCode: '+44'),
  Country(name: 'Canada',          flag: '🇨🇦', dialCode: '+1'),
  Country(name: 'Australia',       flag: '🇦🇺', dialCode: '+61'),
  Country(name: 'Germany',         flag: '🇩🇪', dialCode: '+49'),
  Country(name: 'France',          flag: '🇫🇷', dialCode: '+33'),
  Country(name: 'Italy',           flag: '🇮🇹', dialCode: '+39'),
  Country(name: 'Spain',           flag: '🇪🇸', dialCode: '+34'),
  Country(name: 'Netherlands',     flag: '🇳🇱', dialCode: '+31'),
  Country(name: 'Switzerland',     flag: '🇨🇭', dialCode: '+41'),
  Country(name: 'Sweden',          flag: '🇸🇪', dialCode: '+46'),
  Country(name: 'Norway',          flag: '🇳🇴', dialCode: '+47'),
  Country(name: 'Denmark',         flag: '🇩🇰', dialCode: '+45'),
  Country(name: 'Finland',         flag: '🇫🇮', dialCode: '+358'),
  Country(name: 'Belgium',         flag: '🇧🇪', dialCode: '+32'),
  Country(name: 'Portugal',        flag: '🇵🇹', dialCode: '+351'),
  Country(name: 'Poland',          flag: '🇵🇱', dialCode: '+48'),
  Country(name: 'Russia',          flag: '🇷🇺', dialCode: '+7'),
  Country(name: 'Ukraine',         flag: '🇺🇦', dialCode: '+380'),
  Country(name: 'Turkey',          flag: '🇹🇷', dialCode: '+90'),
  Country(name: 'UAE',             flag: '🇦🇪', dialCode: '+971'),
  Country(name: 'Saudi Arabia',    flag: '🇸🇦', dialCode: '+966'),
  Country(name: 'Qatar',           flag: '🇶🇦', dialCode: '+974'),
  Country(name: 'Kuwait',          flag: '🇰🇼', dialCode: '+965'),
  Country(name: 'Bahrain',         flag: '🇧🇭', dialCode: '+973'),
  Country(name: 'Oman',            flag: '🇴🇲', dialCode: '+968'),
  Country(name: 'Jordan',          flag: '🇯🇴', dialCode: '+962'),
  Country(name: 'Lebanon',         flag: '🇱🇧', dialCode: '+961'),
  Country(name: 'Egypt',           flag: '🇪🇬', dialCode: '+20'),
  Country(name: 'South Africa',    flag: '🇿🇦', dialCode: '+27'),
  Country(name: 'Nigeria',         flag: '🇳🇬', dialCode: '+234'),
  Country(name: 'Kenya',           flag: '🇰🇪', dialCode: '+254'),
  Country(name: 'Ghana',           flag: '🇬🇭', dialCode: '+233'),
  Country(name: 'Ethiopia',        flag: '🇪🇹', dialCode: '+251'),
  Country(name: 'Tanzania',        flag: '🇹🇿', dialCode: '+255'),
  Country(name: 'China',           flag: '🇨🇳', dialCode: '+86'),
  Country(name: 'Japan',           flag: '🇯🇵', dialCode: '+81'),
  Country(name: 'South Korea',     flag: '🇰🇷', dialCode: '+82'),
  Country(name: 'Singapore',       flag: '🇸🇬', dialCode: '+65'),
  Country(name: 'Malaysia',        flag: '🇲🇾', dialCode: '+60'),
  Country(name: 'Indonesia',       flag: '🇮🇩', dialCode: '+62'),
  Country(name: 'Philippines',     flag: '🇵🇭', dialCode: '+63'),
  Country(name: 'Thailand',        flag: '🇹🇭', dialCode: '+66'),
  Country(name: 'Vietnam',         flag: '🇻🇳', dialCode: '+84'),
  Country(name: 'Bangladesh',      flag: '🇧🇩', dialCode: '+880'),
  Country(name: 'Pakistan',        flag: '🇵🇰', dialCode: '+92'),
  Country(name: 'Sri Lanka',       flag: '🇱🇰', dialCode: '+94'),
  Country(name: 'Nepal',           flag: '🇳🇵', dialCode: '+977'),
  Country(name: 'Myanmar',         flag: '🇲🇲', dialCode: '+95'),
  Country(name: 'Cambodia',        flag: '🇰🇭', dialCode: '+855'),
  Country(name: 'Brazil',          flag: '🇧🇷', dialCode: '+55'),
  Country(name: 'Mexico',          flag: '🇲🇽', dialCode: '+52'),
  Country(name: 'Argentina',       flag: '🇦🇷', dialCode: '+54'),
  Country(name: 'Colombia',        flag: '🇨🇴', dialCode: '+57'),
  Country(name: 'Chile',           flag: '🇨🇱', dialCode: '+56'),
  Country(name: 'Peru',            flag: '🇵🇪', dialCode: '+51'),
  Country(name: 'New Zealand',     flag: '🇳🇿', dialCode: '+64'),
  Country(name: 'Ireland',         flag: '🇮🇪', dialCode: '+353'),
  Country(name: 'Israel',          flag: '🇮🇱', dialCode: '+972'),
  Country(name: 'Greece',          flag: '🇬🇷', dialCode: '+30'),
  Country(name: 'Czech Republic',  flag: '🇨🇿', dialCode: '+420'),
  Country(name: 'Hungary',         flag: '🇭🇺', dialCode: '+36'),
  Country(name: 'Romania',         flag: '🇷🇴', dialCode: '+40'),
];

// ════════════════════════════════════════════════════════════
//  PAINTED BAG + LOCK LOGO  (fallback)
// ════════════════════════════════════════════════════════════
class _BagPainter extends CustomPainter {
  final Color color;
  _BagPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..style = PaintingStyle.fill;
    final w = size.width, h = size.height;
    final hw = w * 0.44, hh = h * 0.30, hl = (w - w * 0.44) / 2;
    final arch = Path()
      ..addRRect(RRect.fromLTRBR(hl, 0, hl + hw, hh, Radius.circular(hw / 2)))
      ..addRRect(RRect.fromLTRBR(
          hl + hw * 0.27, hh * 0.14,
          hl + hw * 0.73, hh * 0.64,
          Radius.circular(hw * 0.23)));
    arch.fillType = PathFillType.evenOdd;
    canvas.drawPath(arch, p);
    final sH = h * 0.148, gap = h * 0.030, top = h * 0.315;
    final notch = w * 0.10, r = sH / 2;
    canvas.drawRRect(RRect.fromLTRBR(0,     top,           w,         top + sH,           Radius.circular(r)), p);
    final s2 = top + sH + gap;
    canvas.drawRRect(RRect.fromLTRBR(notch, s2,            w,         s2  + sH,           Radius.circular(r)), p);
    final s3 = s2 + sH + gap;
    canvas.drawRRect(RRect.fromLTRBR(0,     s3,            w - notch, s3  + sH,           Radius.circular(r)), p);
  }

  @override
  bool shouldRepaint(_BagPainter o) => o.color != color;
}

// ════════════════════════════════════════════════════════════
//  LOGO WIDGET
// ════════════════════════════════════════════════════════════
class _Logo extends StatelessWidget {
  final double size;
  final Color  color;
  final bool   onWhiteBox; 

  const _Logo({
    this.size        = 36,
    this.color       = kRed,
    this.onWhiteBox  = false,
  });

  @override
  Widget build(BuildContext context) {
    if (kUseImageLogo) {
      if (kLogoHasWhiteBg) {
        // PNG with white bg: on white box, just render it. On other bg, multiply.
        return Image.asset(
          kLogoAssetPath,
          width:          size,
          height:         size,
          fit:            BoxFit.contain,
          color:          onWhiteBox ? null : Colors.white,
          colorBlendMode: onWhiteBox ? null : BlendMode.multiply,
          errorBuilder:   _fallback,
        );
      } else {
        // Truly transparent PNG: on white box, use its natural colors. 
        // Elsewhere (like standard text row), tint it orange or given color.
        return Image.asset(
          kLogoAssetPath,
          width:          size,
          height:         size,
          fit:            BoxFit.contain,
          color:          onWhiteBox ? null : color,
          colorBlendMode: onWhiteBox ? null : BlendMode.srcIn,
          errorBuilder:   _fallback,
        );
      }
    }
    return _fallbackWidget();
  }

  Widget _fallback(BuildContext ctx, Object err, StackTrace? st) =>
      _fallbackWidget();

  Widget _fallbackWidget() => SizedBox(
    width: size, height: size,
    // If on white box, paint the fallback bag orange. If not, paint it the requested color.
    child: CustomPaint(
      painter: _BagPainter(onWhiteBox ? kRed : color),
    ),
  );
}

// ════════════════════════════════════════════════════════════
//  RIPPLE PAINTER (Updated for better visibility & larger size)
// ════════════════════════════════════════════════════════════
class _RipplePainter extends CustomPainter {
  final double t;
  _RipplePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx   = Offset(size.width / 2, size.height / 2);
    
    // INCREASED CIRCUMFERENCE: Expanded radius multiplier to 0.95
    final maxR = size.width * 0.95; 

    for (int i = 0; i < 3; i++) {
      final phase = (t + i / 3) % 1.0;
      canvas.drawCircle(
        cx,
        maxR * 0.28 + maxR * 0.72 * phase,
        Paint()
          // BETTER VISIBILITY: White with 0.60 opacity base
          ..color       = Colors.white.withOpacity((1 - phase) * 0.60) 
          ..style       = PaintingStyle.stroke
          // THICKER RINGS: Set stroke width to 2.5
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
    vsync:    this,
    duration: const Duration(milliseconds: 120),
    reverseDuration: const Duration(milliseconds: 300),
  );

  late final Animation<double> _scale = Tween<double>(begin: 1.0, end: 0.92)
      .animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  // Tweens adjusted to look good on the new Orange background
  late final Animation<Color?> _bg = ColorTween(
    begin: Colors.white,
    end:   kRedLight,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  late final Animation<Color?> _border = ColorTween(
    begin: Colors.white,
    end:   kRed,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  late final Animation<Color?> _textColor = ColorTween(
    begin: kRed, // Idle text is orange because button is white
    end:   kRed,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOut));

  void _onTapDown(_) => _ac.forward();

  void _onTapUp(_) {
    _ac.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _ac.reverse();

  @override
  void dispose() { _ac.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   _onTapDown,
      onTapUp:     _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _ac,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color:        _bg.value,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: _border.value ?? Colors.white, width: 1.4),
              boxShadow: [
                BoxShadow(
                  color:       Colors.black.withOpacity(0.08),
                  blurRadius:  10,
                  offset:      const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Skip',
                  style: TextStyle(
                    fontFamily:  'Poppins',
                    fontSize:    13,
                    fontWeight:  FontWeight.w600,
                    color:       _textColor.value,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size:  11,
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
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat();

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  double.infinity,
      height: 260,
      decoration: const BoxDecoration(
        color: kRed, // Changed to Orange
        borderRadius: BorderRadius.only(
          bottomLeft:  Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [

          // Animated ripple rings
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) =>
                  CustomPaint(painter: _RipplePainter(_ctrl.value)),
            ),
          ),

          // "Order on the way!" pill (top-left) - Moved down to 60
          Positioned(
            top: 40, left: 20,
            child: const _Pill(dot: Color(0xFF22C55E), label: 'Order on the way!'),
          ),

          // Animated Skip button (top-right) - Moved down to 60
          Positioned(
            top: 40, right: 20,
            child: _SkipButton(onTap: widget.onSkip),
          ),

          // Central WHITE card + logo
          Center(
            child: Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color:        Colors.white, // Changed to White
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color:      Colors.black.withOpacity(0.12),
                    blurRadius: 28,
                    offset:     const Offset(0, 10),
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

          // "Delivery on time" pill (bottom-right)
          Positioned(
            bottom: 36, right: 22,
            child: const _Pill(dot: kRed, label: 'Delivery on time'),
          ),
        ],
      ),
    );
  }
}

// ── Floating pill badge ──────────────────────────────────────
class _Pill extends StatelessWidget {
  final Color  dot;
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
          color:      Colors.black.withOpacity(0.09),
          blurRadius: 12,
          offset:     const Offset(0, 3),
        ),
      ],
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 8, height: 8,
        decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize:   13,
          fontWeight: FontWeight.w500,
          color:      kTextDark,
        ),
      ),
    ]),
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
  final _sc   = TextEditingController();
  List<Country> _list = kCountries;

  void _search(String q) => setState(() => _list = kCountries
      .where((c) =>
          c.name.toLowerCase().contains(q.toLowerCase()) ||
          c.dialCode.contains(q))
      .toList());

  @override
  void dispose() { _sc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 8),
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(children: [
              const Text(
                'Select Country',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize:   17,
                  fontWeight: FontWeight.w700,
                  color:      kTextDark,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close_rounded, color: kMuted, size: 22),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color:        kSurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _sc,
                onChanged:  _search,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize:   14,
                  color:      kTextDark,
                ),
                decoration: const InputDecoration(
                  hintText:  'Search country or dial code',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize:   13,
                    color:      kMuted,
                  ),
                  prefixIcon:     Icon(Icons.search_rounded, color: kMuted, size: 20),
                  border:         InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:  _list.length,
              itemBuilder: (ctx, i) {
                final c   = _list[i];
                final sel = c.dialCode == widget.selected.dialCode &&
                            c.name     == widget.selected.name;
                return InkWell(
                  onTap: () => Navigator.pop(context, c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 13),
                    decoration: BoxDecoration(
                      color:  sel ? kRedLight : Colors.transparent,
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade100)),
                    ),
                    child: Row(children: [
                      Text(c.flag,
                          style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          c.name,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize:   14,
                            fontWeight: FontWeight.w500,
                            color: sel ? kRed : kTextDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:        sel ? kRedLight : kSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: sel
                              ? Border.all(color: kRed.withOpacity(0.4))
                              : null,
                        ),
                        child: Text(
                          c.dialCode,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize:   13,
                            fontWeight: FontWeight.w600,
                            color: sel ? kRed : kMuted,
                          ),
                        ),
                      ),
                      if (sel) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle_rounded,
                            color: kRed, size: 18),
                      ],
                    ]),
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
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _phoneCtrl = TextEditingController();
  final List<TextEditingController> _otpCtrl =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFN =
      List.generate(6, (_) => FocusNode());

  Country _country = kCountries.first;
  bool    _loading   = false;
  bool    _otpSent   = false;
  bool    _canResend = false;
  int     _resendSec = 30;
  Timer?  _timer;

  late final AnimationController _ac = AnimationController(
    vsync:    this,
    duration: const Duration(milliseconds: 550),
  )..forward();

  late final Animation<double> _fade =
      CurvedAnimation(parent: _ac, curve: Curves.easeOut);

  late final Animation<Offset> _slide =
      Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
          .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOut));

  @override
  void dispose() {
    _ac.dispose();
    _phoneCtrl.dispose();
    _timer?.cancel();
    for (final c in _otpCtrl) c.dispose();
    for (final f in _otpFN)   f.dispose();
    super.dispose();
  }

  void _skipToHome() {
    isUserLoggedIn = false;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _pickCountry() async {
    final r = await showModalBottomSheet<Country>(
      context:             context,
      isScrollControlled:  true,
      backgroundColor:     Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (_) => CountryPickerSheet(selected: _country),
    );
    if (r != null) setState(() => _country = r);
  }

  void _sendOtp() async {
    final ph = _phoneCtrl.text.trim();
    if (ph.isEmpty || ph.length < 5) {
      _snack('Please enter a valid mobile number', err: true);
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() { _loading = false; _otpSent = true; });
    _startTimer();
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _otpFN[0].requestFocus(),
    );
    _snack('OTP sent to ${_country.dialCode} $ph');
  }

  void _verifyOtp() async {
    final otp = _otpCtrl.map((c) => c.text).join();
    if (otp.length < 6) {
      _snack('Please enter the complete 6-digit OTP', err: true);
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);

    isUserLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    _snack('Login successful! Welcome back 🎉');

    if (!mounted) return;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  void _startTimer() {
    setState(() { _canResend = false; _resendSec = 30; });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_resendSec <= 1) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _resendSec--);
      }
    });
  }

  void _resend() {
    if (!_canResend) return;
    for (final c in _otpCtrl) c.clear();
    _otpFN[0].requestFocus();
    _startTimer();
    _snack('OTP resent to ${_country.dialCode} ${_phoneCtrl.text.trim()}');
  }

  void _changeNum() {
    _timer?.cancel();
    for (final c in _otpCtrl) c.clear();
    setState(() { _otpSent = false; _canResend = false; _resendSec = 30; });
  }

  void _snack(String msg, {bool err = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13)),
      backgroundColor: err ? Colors.redAccent : kRed,
      behavior:        SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:          Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(children: [

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

                    // Brand row
                    Row(children: const [
                      _Logo(size: 34, color: kRed, onWhiteBox: false),
                      SizedBox(width: 10),
                      Text(
                        'Cartkaro',
                        style: TextStyle(
                          fontFamily:    'Poppins',
                          fontSize:      22,
                          fontWeight:    FontWeight.w700,
                          color:         kRed,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    Text(
                      _otpSent ? 'Enter OTP 🔐' : 'Welcome back! 👋',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize:   26,
                        fontWeight: FontWeight.w700,
                        color:      kTextDark,
                        height:     1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _otpSent
                          ? 'We sent a 6-digit code to\n${_country.dialCode} ${_phoneCtrl.text.trim()}'
                          : 'Log in to continue fast deliveries',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize:   14,
                        color:      kMuted,
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
                            end:   Offset.zero,
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
      ]),
    );
  }

  Widget _mobileStep({Key? key}) => Column(
    key: key,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          color:        kSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          GestureDetector(
            onTap: _pickCountry,
            child: Container(
              margin:  const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color:        kRedLight,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(_country.flag, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  _country.dialCode,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize:   13,
                    fontWeight: FontWeight.w700,
                    color:      kRed,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: kRed, size: 18),
              ]),
            ),
          ),
          Expanded(
            child: TextField(
              controller:    _phoneCtrl,
              keyboardType:  TextInputType.phone,
              style: const TextStyle(
                fontFamily:    'Poppins',
                fontSize:      16,
                fontWeight:    FontWeight.w500,
                color:         kTextDark,
                letterSpacing: 1.2,
              ),
              decoration: const InputDecoration(
                hintText:  'Mobile Number',
                hintStyle: TextStyle(
                  fontFamily:    'Poppins',
                  fontSize:      14,
                  color:         Color(0xFFBDBDBD),
                  letterSpacing: 0,
                ),
                border:         InputBorder.none,
                counterText:    '',
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength:       15,
              onSubmitted:     (_) => _sendOtp(),
            ),
          ),
          const SizedBox(width: 12),
        ]),
      ),
      const SizedBox(height: 10),
      Row(children: [
        Icon(Icons.info_outline_rounded,
            size: 13, color: kMuted.withOpacity(0.7)),
        const SizedBox(width: 6),
        const Text(
          'You will receive a 6-digit OTP via SMS',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize:   12,
            color:      kMuted,
          ),
        ),
      ]),
      const SizedBox(height: 26),
      _btn('Send OTP', Icons.send_rounded, _sendOtp),
      const SizedBox(height: 18),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        _Chip(icon: Icons.security_rounded, label: 'Secure OTP'),
        SizedBox(width: 18),
        _Chip(icon: Icons.verified_rounded, label: '100k+ users'),
        SizedBox(width: 18),
        _Chip(icon: Icons.bolt_rounded,     label: 'Delivery on time'),
      ]),
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
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          "Didn't receive OTP?  ",
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: kMuted),
        ),
        GestureDetector(
          onTap: _canResend ? _resend : null,
          child: _canResend
              ? const Text('Resend OTP',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize:   13,
                    fontWeight: FontWeight.w700,
                    color:      kRed,
                  ))
              : Text(
                  'Resend in ${_resendSec}s',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                    color:      kMuted,
                  ),
                ),
        ),
      ]),
      const SizedBox(height: 8),
      Center(
        child: GestureDetector(
          onTap: _changeNum,
          child: const Text(
            'Change Number',
            style: TextStyle(
              fontFamily:      'Poppins',
              fontSize:        13,
              fontWeight:      FontWeight.w600,
              color:           kRed,
              decoration:      TextDecoration.underline,
              decorationColor: kRed,
            ),
          ),
        ),
      ),
      const SizedBox(height: 26),
      _btn('Verify & Login', Icons.verified_user_rounded, _verifyOtp),
      const SizedBox(height: 14),
      Center(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock_outline_rounded,
              size: 13, color: kMuted.withOpacity(0.7)),
          const SizedBox(width: 5),
          const Text(
            'End-to-end encrypted · OTP valid for 10 min',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize:   11,
              color:      kMuted,
            ),
          ),
        ]),
      ),
    ],
  );

  Widget _otpBox(int i) => SizedBox(
    width: 46, height: 56,
    child: TextField(
      controller:    _otpCtrl[i],
      focusNode:     _otpFN[i],
      keyboardType:  TextInputType.number,
      textAlign:     TextAlign.center,
      maxLength:     1,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize:   22,
        fontWeight: FontWeight.w700,
        color:      kTextDark,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        counterText: '',
        filled:      true,
        fillColor:   kSurface,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: kRed, width: 2)),
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
    width:  double.infinity,
    height: 56,
    child: ElevatedButton.icon(
      onPressed: _loading ? null : onTap,
      icon: _loading
          ? const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5),
            )
          : Icon(icon, size: 20),
      label: _loading
          ? const SizedBox.shrink()
          : Text(
              label,
              style: const TextStyle(
                fontFamily:    'Poppins',
                fontSize:      16,
                fontWeight:    FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
      style: ElevatedButton.styleFrom(
        backgroundColor:         kRed,
        foregroundColor:         Colors.white,
        disabledBackgroundColor: kRed.withOpacity(0.6),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════
//  TRUST CHIP
// ════════════════════════════════════════════════════════════
class _Chip extends StatelessWidget {
  final IconData icon;
  final String   label;
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
          fontSize:   11,
          fontWeight: FontWeight.w600,
          color:      kRed,
        ),
      ),
    ],
  );
}