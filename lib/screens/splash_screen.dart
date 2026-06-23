import 'dart:async';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ── Import your brand colours and BrandLogo from login_screen.dart ──────────
// Make sure this import points to wherever you export those from.
// If login_screen.dart is in the same folder:
// import 'login_screen.dart';
// Or if you have a shared constants file, import that instead.

// ─── Paste these here if not importing from elsewhere ───────────────────────
const Color kRed     = Color.fromARGB(255, 232, 6, 10);
const Color kRedDark = Color.fromARGB(255, 150, 4, 8);

// ════════════════════════════════════════════════════════════
//  PARTICLE MODEL
// ════════════════════════════════════════════════════════════
class _Particle {
  late double x, y, radius, speed, angle, opacity;
  _Particle(math.Random rng) {
    _reset(rng, initial: true);
  }
  void _reset(math.Random rng, {bool initial = false}) {
    x       = rng.nextDouble();
    y       = initial ? rng.nextDouble() : 1.1;
    radius  = 1.5 + rng.nextDouble() * 3;
    speed   = 0.0008 + rng.nextDouble() * 0.0012;
    angle   = (rng.nextDouble() - 0.5) * 0.4;
    opacity = 0.08 + rng.nextDouble() * 0.22;
  }
  void tick(math.Random rng) {
    y -= speed;
    x += math.sin(angle) * 0.0015;
    if (y < -0.05) _reset(rng);
  }
}

// ════════════════════════════════════════════════════════════
//  PARTICLE + RING PAINTER
// ════════════════════════════════════════════════════════════
class _SplashPainter extends CustomPainter {
  final List<_Particle> particles;
  final double ringT;          // 0‥1 looping for pulsing rings
  final double logoRevealT;    // 0‥1 for the ring-burst around logo

  _SplashPainter({
    required this.particles,
    required this.ringT,
    required this.logoRevealT,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // ── Floating particles ──────────────────────────────────
    for (final p in particles) {
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.radius,
        Paint()..color = Colors.white.withOpacity(p.opacity),
      );
    }

    // ── Pulsing concentric rings (looping) ──────────────────
    for (int i = 0; i < 4; i++) {
      final phase  = (ringT + i * 0.25) % 1.0;
      final radius = 56.0 + 110 * phase;
      final alpha  = (1 - phase) * 0.18;
      canvas.drawCircle(
        Offset(cx, cy),
        radius,
        Paint()
          ..color       = Colors.white.withOpacity(alpha)
          ..style       = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }

    // ── Logo-reveal burst rings (plays once on entry) ───────
    if (logoRevealT > 0 && logoRevealT < 1) {
      for (int i = 0; i < 3; i++) {
        final phase  = ((logoRevealT * 1.4) - i * 0.15).clamp(0.0, 1.0);
        if (phase <= 0) continue;
        final radius = 50.0 * phase + 14;
        final alpha  = (1 - phase) * 0.5;
        canvas.drawCircle(
          Offset(cx, cy),
          radius,
          Paint()
            ..color       = Colors.white.withOpacity(alpha)
            ..style       = PaintingStyle.stroke
            ..strokeWidth = 2.5 - phase * 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SplashPainter o) => true;
}

// ════════════════════════════════════════════════════════════
//  SPLASH SCREEN
// ════════════════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  /// Route name pushed when the user is already logged in.
  final String homeRoute;

  /// Route name pushed when login is required.
  final String loginRoute;

  const SplashScreen({
    super.key,
    required this.homeRoute,
    required this.loginRoute,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // ── Animation controllers ────────────────────────────────
  late final AnimationController _ringCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  late final AnimationController _entryCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final AnimationController _particleCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  late final AnimationController _exitCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  // ── Entry animations ─────────────────────────────────────
  late final Animation<double> _logoScale = TweenSequence([
    TweenSequenceItem(
      tween: Tween(begin: 0.0, end: 1.12)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 60,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.12, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 40,
    ),
  ]).animate(_entryCtrl);

  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _entryCtrl,
    curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
  );

  late final Animation<double> _taglineFade = CurvedAnimation(
    parent: _entryCtrl,
    curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
  );

  late final Animation<Offset> _taglineSlide = Tween<Offset>(
    begin: const Offset(0, 0.5),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    ),
  );

  late final Animation<double> _dotsFade = CurvedAnimation(
    parent: _entryCtrl,
    curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
  );

  // ── Exit ────────────────────────────────────────────────
  late final Animation<double> _exitFade = Tween<double>(begin: 1.0, end: 0.0)
      .animate(CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn));

  // ── Particles ────────────────────────────────────────────
  final _rng       = math.Random();
  late final List<_Particle> _particles;

  // ── Logo shimmer ─────────────────────────────────────────
  late final AnimationController _shimmerCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(28, (_) => _Particle(_rng));

    // Particle ticker
    _particleCtrl.addListener(() {
      for (final p in _particles) {
        p.tick(_rng);
      }
    });

    // Start entry, then navigate
    _entryCtrl.forward().then((_) => _checkAuthAndNavigate());
  }

  Future<void> _checkAuthAndNavigate() async {
    // Give a minimum splash duration for branding impact
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    await _exitCtrl.forward();
    if (!mounted) return;

    if (user != null) {
      Navigator.of(context).pushReplacementNamed(widget.homeRoute);
    } else {
      Navigator.of(context).pushReplacementNamed(widget.loginRoute);
    }
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    _entryCtrl.dispose();
    _particleCtrl.dispose();
    _exitCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _exitFade,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _ringCtrl,
            _particleCtrl,
            _entryCtrl,
            _shimmerCtrl,
          ]),
          builder: (context, _) {
            return SizedBox.expand(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kRed, kRedDark],
                ),
              ),
              child: CustomPaint(
                painter: _SplashPainter(
                  particles:    _particles,
                  ringT:        _ringCtrl.value,
                  logoRevealT:  _entryCtrl.value,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 3),

                      // ── Logo card ─────────────────────────────
                      ScaleTransition(
                        scale: _logoScale,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: _LogoCard(shimmerT: _shimmerCtrl.value),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Brand name ────────────────────────────
                      FadeTransition(
                        opacity: _taglineFade,
                        child: SlideTransition(
                          position: _taglineSlide,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.85),
                                      ],
                                    ).createShader(bounds),
                                child: const Text(
                                  'CartKaro',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  'Delivered. Everyday.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      // ── Loading dots ──────────────────────────
                      FadeTransition(
                        opacity: _dotsFade,
                        child: _PulsingDots(),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
            );
          },
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  LOGO CARD  — white rounded card with shimmer sweep
// ════════════════════════════════════════════════════════════
class _LogoCard extends StatelessWidget {
  final double shimmerT;
  const _LogoCard({required this.shimmerT});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow ring behind card
        Container(
          width: 122,
          height: 122,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.18),
                blurRadius: 48,
                spreadRadius: 8,
              ),
            ],
          ),
        ),
        // Card
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 40,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.08),
                blurRadius: 0,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              children: [
                // Logo
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      'assets/images/cartkaro_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.shopping_cart_rounded,
                        color: kRed,
                        size: 54,
                      ),
                    ),
                  ),
                ),
                // Shimmer sweep
                Positioned(
                  left: -80 + (shimmerT * 240),
                  top: 0,
                  bottom: 0,
                  child: Transform.rotate(
                    angle: 0.4,
                    child: Container(
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.35),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  PULSING DOTS LOADER
// ════════════════════════════════════════════════════════════
class _PulsingDots extends StatefulWidget {
  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_ctrl.value - i * 0.18).clamp(0.0, 1.0);
            final scale = 0.6 + 0.4 * math.sin(phase * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5 + 0.5 * scale),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}