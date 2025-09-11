import 'dart:math';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/cyberpunk_theme.dart';

/// Main splash screen widget that handles initialization and navigation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Shows the splash screen for a fixed duration, then navigates.
  Future<void> _initializeApp() async {
    // Show splash screen for a minimum duration for animations to play.
    await Future.delayed(const Duration(seconds: 4));

    if (mounted) {
      // Always navigate to the welcome screen.
      // pushReplacementNamed prevents the user from going back to the splash screen.
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const AnimatedSplashUI();
  }
}

// --- NO CHANGES BELOW THIS LINE ---
// The AnimatedSplashUI and other helper classes remain the same as they
// are purely for visual presentation.

/// Animated UI component for the Cyberpunk-themed splash screen
class AnimatedSplashUI extends StatefulWidget {
  const AnimatedSplashUI({super.key});

  @override
  State<AnimatedSplashUI> createState() => _AnimatedSplashUIState();
}

class _AnimatedSplashUIState extends State<AnimatedSplashUI>
    with TickerProviderStateMixin {
  late AnimationController _neonSweepController;
  late AnimationController _glowPulseController;
  late AnimationController _logoPulseController;
  late AnimationController _glitchController;
  late AnimationController _particleController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _loadingMessages = [
    'CONNECTING TO MAINFRAME...',
    'DECRYPTING CORE DATA...',
    'CALIBRATING NEURAL INTERFACE...',
    'INITIALIZING UI...',
    'SYSTEM READY.',
  ];
  int _currentMessageIndex = 0;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _neonSweepController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
      lowerBound: 0.9,
      upperBound: 1.06,
    )..repeat(reverse: true);

    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.7,
      upperBound: 1.0,
    )..repeat(reverse: true);

    // Timer to cycle through loading messages
    _messageTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_currentMessageIndex < _loadingMessages.length - 1) {
        setState(() {
          _currentMessageIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _neonSweepController.dispose();
    _glowPulseController.dispose();
    _logoPulseController.dispose();
    _glitchController.dispose();
    _particleController.dispose();
    _fadeController.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Base gradient
          Container(
            decoration: BoxDecoration(gradient: CyberpunkTheme.primaryGradient),
          ),

          // --- Enhanced cyberpunk game-like background ---
          // Distant star glimmer (subtle)
          AnimatedBuilder(
            animation: _glowPulseController,
            builder: (context, child) => Positioned.fill(
              child: CustomPaint(
                painter: _StarfieldPainter(_glowPulseController.value),
              ),
            ),
          ),

          // City silhouette (parallax)
          AnimatedBuilder(
            animation: _neonSweepController,
            builder: (context, child) => Positioned.fill(
              child: CustomPaint(
                painter: _CityParallaxPainter(_neonSweepController.value),
              ),
            ),
          ),

          // Neon signs and billboards (flicker)
          AnimatedBuilder(
            animation: Listenable.merge([
              _neonSweepController,
              _glowPulseController,
            ]),
            builder: (context, child) => Positioned.fill(
              child: CustomPaint(
                painter: _NeonSignPainter(
                  _neonSweepController.value,
                  _glowPulseController.value,
                ),
              ),
            ),
          ),

          // Fog / volumetric layers
          AnimatedBuilder(
            animation: _glowPulseController,
            builder: (context, child) => Positioned.fill(
              child: CustomPaint(
                painter: _FogPainter(_glowPulseController.value),
              ),
            ),
          ),

          // Hover cars (silhouette streaks)
          AnimatedBuilder(
            animation: _neonSweepController,
            builder: (context, child) => Positioned.fill(
              child: CustomPaint(
                painter: _HoverCarPainter(_neonSweepController.value),
              ),
            ),
          ),

          // Perspective grid floor
          AnimatedBuilder(
            animation: _neonSweepController,
            builder: (context, child) => Positioned.fill(
              child: CustomPaint(
                painter: _GridFloorPainter(_neonSweepController.value),
              ),
            ),
          ),

          // Rain overlay (subtle direction and speed)
          AnimatedBuilder(
            animation: _neonSweepController,
            builder: (context, child) => Positioned.fill(
              child: CustomPaint(
                painter: _RainPainter(_neonSweepController.value),
              ),
            ),
          ),

          // Chromatic aberration / color fringe for game-like lens
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ChromaticAberrationPainter()),
            ),
          ),

          // Soft neon wash to tint the scene
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      CyberpunkTheme.neonPink.withOpacity(0.06),
                      CyberpunkTheme.neonCyan.withOpacity(0.06),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  backgroundBlendMode: BlendMode.overlay,
                ),
              ),
            ),
          ),

          // Scanline overlay for retro CRT effect
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ScanlinePainter(opacity: 0.06)),
            ),
          ),

          // Foreground content with fade transition
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(child: _buildContent()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          _buildLogo(),
          const SizedBox(height: 24),
          _buildGlitchyTitle('GATEWAYS 2025'),
          const SizedBox(height: 8),
          Text(
            'Powered by COMPUTER SCIENCE',
            style: CyberpunkTheme.subtitleStyle,
          ),
          const Spacer(flex: 4),
          _buildLoadingIndicator(),
          const SizedBox(height: 48),
          Text('Version 1.0.0', style: CyberpunkTheme.versionStyle),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 120,
      height: 120,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _neonSweepController,
          _logoPulseController,
          _glitchController,
          _particleController,
        ]),
        builder: (context, child) {
          // Subtle horizontal oscillation for logo
          final t = _neonSweepController.value;
          final offsetX = sin(t * 2 * pi) * 2.5;
          final scale = _logoPulseController.value;
          final g = _glitchController.value; // 0..1
          final glitchPeak = (sin(g * 20 * pi));
          final glitchOffset = glitchPeak * (g > 0.6 ? 6.0 : 1.5);
          return Transform.translate(
            offset: Offset(offsetX, 0),
            child: Transform.scale(
              scale: scale,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // animated rings behind the logo
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CustomPaint(
                      painter: _LogoRingsPainter(_particleController.value),
                    ),
                  ),
                  // subtle particle burst overlay
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CustomPaint(
                      painter: _ParticleBurstPainter(_particleController.value),
                    ),
                  ),
                  // color-split tinted layers for glitch fringe
                  // left tint (magenta-ish)
                  Transform.translate(
                    offset: Offset(
                      -glitchOffset * 0.8 + sin(t * 2 * pi) * 1.2,
                      0,
                    ),
                    child: Opacity(
                      opacity: 0.9,
                      child: ClipPath(
                        clipper: _HexagonClipper(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          color: CyberpunkTheme.neonYellow.withOpacity(0.0),
                          child: ClipPath(
                            clipper: _HexagonClipper(),
                            child: Container(
                              color: CyberpunkTheme.background,
                              child: Icon(
                                Icons.event_note,
                                size: 60,
                                color: CyberpunkTheme.neonPink.withOpacity(
                                  0.95,
                                ),
                                shadows: [],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // right tint (cyan-ish)
                  Transform.translate(
                    offset: Offset(
                      glitchOffset * 0.9 + sin(t * 2 * pi + 1.3) * 0.8,
                      0,
                    ),
                    child: Opacity(
                      opacity: 0.7,
                      child: ClipPath(
                        clipper: _HexagonClipper(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          color: CyberpunkTheme.neonYellow.withOpacity(0.0),
                          child: ClipPath(
                            clipper: _HexagonClipper(),
                            child: Container(
                              color: CyberpunkTheme.background,
                              child: Icon(
                                Icons.event_note,
                                size: 60,
                                color: CyberpunkTheme.neonCyan.withOpacity(0.9),
                                shadows: [],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // main logo layer
                  ClipPath(
                    clipper: _HexagonClipper(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: CyberpunkTheme.neonYellow.withOpacity(0.8),
                      child: ClipPath(
                        clipper: _HexagonClipper(),
                        child: Container(
                          color: CyberpunkTheme.background,
                          child: Icon(
                            Icons.event_note,
                            size: 60,
                            color: CyberpunkTheme.neonCyan,
                            shadows: [
                              Shadow(
                                color: CyberpunkTheme.neonCyan.withOpacity(0.8),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // horizontal slice displacement when glitch peaks
                  if (g > 0.55)
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 40 + sin(g * 8.0) * 6.0,
                      height: 18,
                      child: Transform.translate(
                        offset: Offset(glitchOffset * 2.5, 0),
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.topCenter,
                            heightFactor: 0.15,
                            child: ClipPath(
                              clipper: _HexagonClipper(),
                              child: Container(
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.event_note,
                                  size: 60,
                                  color: CyberpunkTheme.neonCyan.withOpacity(
                                    0.95,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlitchyTitle(String text) {
    return AnimatedBuilder(
      animation: Listenable.merge([_neonSweepController, _glitchController]),
      builder: (context, child) {
        final t = _neonSweepController.value;
        final g = _glitchController.value;
        final sweepOffset = sin(t * 2 * pi) * 4.0;
        final glitchOffset = (sin(g * 20 * pi) * 6.0) * (g > 0.6 ? 1.0 : 0.2);
        final colorSweep = Color.lerp(
          CyberpunkTheme.neonPink,
          CyberpunkTheme.neonCyan,
          (sin(t * 2 * pi) + 1) / 2,
        )!;

        // layered color split with small jitter to simulate a digital glitch
        return Stack(
          children: [
            Transform.translate(
              offset: Offset(sweepOffset + glitchOffset * 0.6, 0),
              child: Text(
                text,
                style: CyberpunkTheme.headlineStyle.copyWith(
                  color: colorSweep.withOpacity(0.7),
                  shadows: [],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-sweepOffset - glitchOffset * 0.9, 0),
              child: Text(
                text,
                style: CyberpunkTheme.headlineStyle.copyWith(
                  color: colorSweep.withOpacity(0.45),
                  shadows: [],
                ),
              ),
            ),
            // main layer with micro jitter when glitch peaks
            Transform.translate(
              offset: Offset((glitchOffset * 0.4) * (g > 0.8 ? 1 : 0), 0),
              child: Text(text, style: CyberpunkTheme.headlineStyle),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 250,
          child: Text(
            _loadingMessages[_currentMessageIndex],
            textAlign: TextAlign.center,
            style: CyberpunkTheme.loadingStyle,
          ),
        ),
        const SizedBox(height: 16),
        // Animated loading bar
        AnimatedBuilder(
          animation:
              _fadeController, // Using fade controller for a one-shot animation
          builder: (context, child) => Container(
            height: 2,
            width: 150,
            color: CyberpunkTheme.neonYellow.withOpacity(0.3),
            alignment: Alignment.centerLeft,
            child: Container(
              height: 2,
              width: 150 * _fadeController.value,
              decoration: BoxDecoration(
                color: CyberpunkTheme.neonYellow,
                boxShadow: [
                  BoxShadow(
                    color: CyberpunkTheme.neonYellow,
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom clipper for an angular, hexagonal shape.
class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.25, 0);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width * 0.25, size.height);
    path.lineTo(0, size.height * 0.5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// (Grid/scanline painter removed; replaced with animated neon sweep and glow)

// ------------------ Background Painters ------------------

/// Subtle starfield that twinkles based on a pulse value (0.0 - 1.0).
class _StarfieldPainter extends CustomPainter {
  final double pulse; // 0..1
  _StarfieldPainter(this.pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    // Deterministic pseudo-random placement using math functions so frames
    // don't jump between rebuilds.
    const int rows = 12;
    const int cols = 18;
    final rngFactor = pulse * 2 * pi;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final nx = (c + 0.5) / cols;
        final ny = (r + 0.5) / rows;
        // position jitter using sin/cos ensures deterministic variation
        final jitterX = (sin((r * 13 + c * 7) * 0.37 + rngFactor) * 0.35);
        final jitterY = (cos((r * 11 + c * 5) * 0.33 + rngFactor) * 0.35);

        final dx = (nx + jitterX * 0.02) * size.width;
        final dy = (ny + jitterY * 0.02) * size.height * 0.6; // upper area

        final seed = (r * 31 + c * 17);
        final baseSize = 0.6 + (seed % 5) * 0.2;
        final twinkle = 0.6 + 0.4 * (0.5 + 0.5 * sin(rngFactor + seed));

        paint.color = Colors.white.withOpacity(0.02 * baseSize * twinkle);
        canvas.drawCircle(Offset(dx, dy), baseSize, paint);

        // occasional brighter spark
        if ((seed + pulse * 10).floor() % 13 == 0) {
          paint.color = CyberpunkTheme.neonCyan.withOpacity(0.06 * twinkle);
          canvas.drawCircle(
            Offset(dx + baseSize * 1.4, dy - baseSize * 0.6),
            baseSize * 0.6,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) =>
      oldDelegate.pulse != pulse;
}

/// Parallax city silhouettes: several layers moving at different speeds.
class _CityParallaxPainter extends CustomPainter {
  final double phase; // 0..1
  _CityParallaxPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final horizon = size.height * 0.46;

    // Night glow behind skyline
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.5),
        colors: [CyberpunkTheme.neonPink.withOpacity(0.12), Colors.transparent],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, horizon * 2));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, horizon), glowPaint);

    // Draw three parallax layers, far -> near
    for (int layer = 0; layer < 3; layer++) {
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = Color.lerp(
          CyberpunkTheme.background.withOpacity(0.65),
          CyberpunkTheme.neonCyan.withOpacity(0.15),
          layer / 3,
        )!;

      final path = Path();
      final speed = (0.04 + layer * 0.06);
      final offsetX = (phase * size.width * speed * (layer + 1));

      path.moveTo(-size.width + offsetX % size.width, horizon + layer * 8);

      // skyline silhouette using deterministic waves
      final buildings = 14 + layer * 6;
      final bw = size.width / buildings;
      for (int i = 0; i <= buildings; i++) {
        final x = (-size.width + offsetX % size.width) + i * bw;
        final noise =
            (sin((i * 0.9 + layer * 1.3) * 1.5 + phase * 2 * pi) + 1) / 2;
        final h = (30 + noise * (120 + layer * 40)) + layer * 6;
        path.lineTo(x, horizon - h);
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(path, paint);
    }

    // Neon windows: simple grid of tiny rectangles on mid-layer buildings
    final windowPaint = Paint()
      ..color = CyberpunkTheme.neonYellow.withOpacity(0.06);
    for (int i = 0; i < 24; i++) {
      final x = (i / 24) * size.width + (sin(phase * 2 * pi + i) * 6);
      final y = horizon - 40.0 - (i % 6) * 8.0;
      canvas.drawRect(Rect.fromLTWH(x, y, 3, 3), windowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CityParallaxPainter oldDelegate) =>
      oldDelegate.phase != phase;
}

/// Perspective grid floor that recedes to a vanishing point.
class _GridFloorPainter extends CustomPainter {
  final double phase;
  _GridFloorPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = CyberpunkTheme.neonCyan.withOpacity(0.12);

    final horizonY = size.height * 0.52;
    final vanishing = Offset(
      size.width / 2 + sin(phase * 2 * pi) * 30,
      horizonY - 20,
    );

    // radial perspective lines
    final cols = 14;
    for (int i = 0; i <= cols; i++) {
      final x = (i / cols) * size.width;
      canvas.drawLine(Offset(x, size.height), vanishing, paint);
    }

    // horizontal grid lines (curved illusion by lerping between bottom and horizon)
    final rows = 16;
    for (int r = 1; r <= rows; r++) {
      final t = r / rows;
      // compute base Y for this horizontal grid line
      final baseYFallback = (size.height * (1 - t) + horizonY * t);
      final linePaint = paint
        ..color = paint.color.withOpacity(0.06 + (1 - t) * 0.18);
      // draw polyline from left to right by sampling points closer to vanishing point
      final samples = 36;
      final path = Path();
      for (int s = 0; s <= samples; s++) {
        final sx = s / samples;
        // interpolate between left/right bottom and vanishing
        final left = Offset(0, size.height);
        final right = Offset(size.width, size.height);
        final px = ui.lerpDouble(left.dx, right.dx, sx)!;
        final baseY = ui.lerpDouble(size.height, horizonY, t) ?? baseYFallback;
        // slight wave animation
        final wave = sin((sx + phase) * 6.0 + r) * (6.0 * (1 - t));
        final py = baseY - wave;
        if (s == 0)
          path.moveTo(px, py);
        else
          path.lineTo(px, py);
      }
      canvas.drawPath(path, linePaint);
    }

    // faint neon highlight near vanishing point
    final highlight = Paint()
      ..color = CyberpunkTheme.neonPink.withOpacity(0.05);
    canvas.drawCircle(vanishing, 28.0, highlight);
  }

  @override
  bool shouldRepaint(covariant _GridFloorPainter oldDelegate) =>
      oldDelegate.phase != phase;
}

/// Thin scanlines overlay for CRT retro look.
class _ScanlinePainter extends CustomPainter {
  final double opacity;
  _ScanlinePainter({this.opacity = 0.04});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(opacity);
    final spacing = 3.0;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1.0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

/// Neon sign flicker and billboard painter.
class _NeonSignPainter extends CustomPainter {
  final double phase; // 0..1
  final double pulse; // 0..1
  _NeonSignPainter(this.phase, this.pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final signs = 6;
    for (int i = 0; i < signs; i++) {
      final x = (i / signs) * size.width + sin(phase * 2 * pi + i) * 12;
      final y = size.height * 0.32 + (i % 2) * 12.0;
      final w = 60.0 + (i % 3) * 12.0;
      final h = 16.0 + ((i + 1) % 2) * 6.0;

      final flicker = 0.6 + 0.4 * (0.5 + 0.5 * sin(phase * 6.0 + i * 2.0));
      paint.color = Color.lerp(
        CyberpunkTheme.neonPink,
        CyberpunkTheme.neonCyan,
        (i % 2) / 1.0,
      )!.withOpacity(0.18 * flicker * pulse);
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        Radius.circular(4),
      );
      canvas.drawRRect(r, paint);

      // small glow
      final glow = Paint()..color = paint.color.withOpacity(0.6);
      canvas.drawRRect(r.inflate(6), glow);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonSignPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.pulse != pulse;
}

/// Fog / volumetric layers for depth.
class _FogPainter extends CustomPainter {
  final double pulse;
  _FogPainter(this.pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final g = ui.Gradient.linear(
      Offset(0, size.height * 0.2),
      Offset(0, size.height),
      [Colors.white.withOpacity(0.02 * pulse), Colors.transparent],
      [0.0, 1.0],
    );
    final paint = Paint()
      ..shader = g
      ..blendMode = BlendMode.screen;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.2, size.width, size.height * 0.8),
      paint,
    );

    // moving fog streaks
    final streakPaint = Paint()..color = Colors.white.withOpacity(0.03 * pulse);
    for (int i = 0; i < 8; i++) {
      final offset = (pulse + i * 0.15) % 1.0;
      final px = size.width * offset;
      final py = size.height * (0.3 + (i % 3) * 0.08);
      final rect = Rect.fromLTWH(px - 120, py, 240, 40);
      canvas.drawRect(rect, streakPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FogPainter oldDelegate) =>
      oldDelegate.pulse != pulse;
}

/// Hover car streaks across the skyline.
class _HoverCarPainter extends CustomPainter {
  final double phase;
  _HoverCarPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 5; i++) {
      final t = (phase + i * 0.18) % 1.0;
      final x = size.width * (t);
      final y = size.height * (0.38 + (i % 2) * 0.06);
      final w = 40.0 + (i % 3) * 12.0;
      final h = 6.0;
      final c = Color.lerp(
        CyberpunkTheme.neonCyan,
        CyberpunkTheme.neonPink,
        (sin(phase * 2 * pi + i) + 1) / 2,
      )!;
      paint.color = c.withOpacity(0.65);
      // streak
      final rect = Rect.fromLTWH(x - w * 0.5, y, w, h);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(3)),
        paint,
      );
      // glow
      final glow = Paint()..color = paint.color.withOpacity(0.4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.inflate(6), Radius.circular(6)),
        glow,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HoverCarPainter oldDelegate) =>
      oldDelegate.phase != phase;
}

/// Subtle rain overlay with direction based on phase.
class _RainPainter extends CustomPainter {
  final double phase;
  _RainPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.03);
    final speed = 800.0;
    for (int i = 0; i < 120; i++) {
      final x = ((i * 37) % size.width) + (phase * size.width * 0.6);
      final y = ((i * 97) % size.height) + (phase * speed) % size.height;
      final len = 8.0 + (i % 5) * 2.0;
      final dx = x + sin(i) * 4.0;
      final dy = y + cos(phase * 2 * pi) * 6.0;
      canvas.drawLine(Offset(dx, dy), Offset(dx + 2.0, dy + len), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter oldDelegate) =>
      oldDelegate.phase != phase;
}

/// Chromatic aberration effect using simple colored offsets.
class _ChromaticAberrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()..color = Colors.red.withOpacity(0.02);
    final green = Paint()..color = Colors.green.withOpacity(0.02);
    final blue = Paint()..color = Colors.blue.withOpacity(0.02);
    // Slight offset rectangles at edges
    canvas.drawRect(Rect.fromLTWH(2, 0, size.width - 4, size.height), red);
    canvas.drawRect(Rect.fromLTWH(-2, 0, size.width - 4, size.height), blue);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), green);
  }

  @override
  bool shouldRepaint(covariant _ChromaticAberrationPainter oldDelegate) =>
      false;
}

/// Animated rings behind the logo to give it a pulsating, energetic feel.
class _LogoRingsPainter extends CustomPainter {
  final double phase; // 0..1
  _LogoRingsPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final base = min(size.width, size.height) / 2;
    for (int i = 0; i < 3; i++) {
      final t = (phase + i * 0.12) % 1.0;
      final radius = base * (0.6 + i * 0.18 + 0.15 * sin(t * 2 * pi));
      final alpha = 0.12 * (1 - i * 0.25) * (0.7 + 0.3 * sin(t * 2 * pi));
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 + i.toDouble()
        ..color = Color.lerp(
          CyberpunkTheme.neonCyan,
          CyberpunkTheme.neonPink,
          i / 3,
        )!.withOpacity(alpha);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LogoRingsPainter oldDelegate) =>
      oldDelegate.phase != phase;
}

/// Subtle particle burst pulses that occasionally sparkle around the logo area.
class _ParticleBurstPainter extends CustomPainter {
  final double phase;
  _ParticleBurstPainter(this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 18; i++) {
      final a = (i / 18) * 2 * pi + phase * 2 * pi;
      final r =
          (min(size.width, size.height) * 0.28) *
          (0.6 + 0.4 * sin(phase * 2 * pi + i));
      final px = center.dx + cos(a) * r + sin(i * 7 + phase) * 4.0;
      final py = center.dy + sin(a) * r + cos(i * 5 + phase) * 3.0;
      final s = 0.8 + (i % 3) * 0.6;
      paint.color = CyberpunkTheme.neonYellow.withOpacity(
        0.06 + (sin(phase * 2 * pi + i) + 1) * 0.02,
      );
      canvas.drawCircle(Offset(px, py), s, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleBurstPainter oldDelegate) =>
      oldDelegate.phase != phase;
}
