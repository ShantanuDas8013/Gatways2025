import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

/// Main splash screen widget for innovative event management app
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
    await Future.delayed(const Duration(seconds: 5));

    if (mounted) {
      // Always navigate to the welcome screen.
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const EventManagementSplashUI();
  }
}

/// Innovative Event Management Splash Screen with Cyberpunk Theme
class EventManagementSplashUI extends StatefulWidget {
  const EventManagementSplashUI({super.key});

  @override
  State<EventManagementSplashUI> createState() =>
      _EventManagementSplashUIState();
}

class _EventManagementSplashUIState extends State<EventManagementSplashUI>
    with TickerProviderStateMixin {
  // Cyberpunk color palette
  static const Color cyberCyan = Color(0xFF00F0FF);
  static const Color cyberPink = Color(0xFFFF0080);
  static const Color cyberYellow = Color(0xFFFFFF00);
  static const Color cyberPurple = Color(0xFF9D00FF);
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color neonGreen = Color(0xFF00FF88);

  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _glowController;
  late AnimationController _circuitController;

  // Animations
  late Animation<double> _logoScale;
  late Animation<double> _textOpacity;
  late Animation<double> _progressValue;
  late Animation<double> _glowPulse;

  // Loading states
  final List<String> _loadingMessages = [
    'INITIALIZING EVENT MATRIX...',
    'CONNECTING TO EVENT SERVERS...',
    'SYNCING REGISTRATION DATA...',
    'LOADING PARTICIPANT DATABASE...',
    'CALIBRATING EVENT ALGORITHMS...',
    'SYSTEM READY FOR EVENTS!',
  ];
  int _currentMessageIndex = 0;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLoadingSequence();
  }

  void _initializeAnimations() {
    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Particle system
    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Glow effects
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowPulse = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Circuit animation
    _circuitController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    // Start animations
    _logoController.forward();
    _textController.forward();
    _progressController.forward();
  }

  void _startLoadingSequence() {
    _messageTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (mounted && _currentMessageIndex < _loadingMessages.length - 1) {
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
    _logoController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _glowController.dispose();
    _circuitController.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: Stack(
        children: [
          // Animated background gradient
          _buildAnimatedBackground(),

          // Floating particles
          _buildParticleSystem(),

          // Circuit pattern overlay
          _buildCircuitPattern(),

          // Christ Logo at top
          _buildChristLogo(),

          // Main content
          _buildMainContent(),

          // Loading progress at bottom
          _buildLoadingProgress(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                sin(_particleController.value * 2 * pi) * 0.3,
                cos(_particleController.value * 2 * pi) * 0.2,
              ),
              radius: 1.5,
              colors: [
                cyberCyan.withOpacity(0.15),
                cyberPurple.withOpacity(0.1),
                cyberPink.withOpacity(0.05),
                darkBackground,
                Colors.black,
              ],
              stops: const [0.0, 0.3, 0.5, 0.8, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticleSystem() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: EventParticlesPainter(_particleController.value),
        );
      },
    );
  }

  Widget _buildCircuitPattern() {
    return AnimatedBuilder(
      animation: _circuitController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: CircuitPatternPainter(_circuitController.value),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated logo section (Gateways only)
          _buildGatewaysLogo(),

          const SizedBox(height: 60),

          // App title with glow effect
          _buildTitle(),

          const SizedBox(height: 20),

          // Subtitle
          _buildSubtitle(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildChristLogo() {
    return Positioned(
      top: 60,
      left: 50,
      right: 50,
      child: AnimatedBuilder(
        animation: Listenable.merge([_logoController, _glowController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _logoScale.value,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    neonGreen.withOpacity(0.3),
                    cyberYellow.withOpacity(0.2),
                    cyberCyan.withOpacity(0.15),
                    cyberPurple.withOpacity(0.1),
                  ],
                ),
                border: Border.all(color: neonGreen.withOpacity(0.8), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: neonGreen.withOpacity(_glowPulse.value * 0.8),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                  BoxShadow(
                    color: cyberYellow.withOpacity(_glowPulse.value * 0.6),
                    blurRadius: 50,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: cyberCyan.withOpacity(_glowPulse.value * 0.4),
                    blurRadius: 70,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: darkBackground.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                      color: neonGreen.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.asset(
                    'assets/icons/christ logo.png',
                    fit: BoxFit.contain,
                    height: 72,
                    color: neonGreen,
                    colorBlendMode: BlendMode.srcIn,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          gradient: LinearGradient(
                            colors: [neonGreen, cyberYellow, cyberCyan],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.church,
                          size: 40,
                          color: darkBackground,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGatewaysLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _glowController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  cyberCyan.withOpacity(0.3),
                  cyberPurple.withOpacity(0.2),
                  cyberPink.withOpacity(0.15),
                  cyberYellow.withOpacity(0.1),
                ],
              ),
              border: Border.all(color: cyberCyan.withOpacity(0.8), width: 3),
              boxShadow: [
                BoxShadow(
                  color: cyberCyan.withOpacity(_glowPulse.value * 0.8),
                  blurRadius: 40,
                  spreadRadius: 15,
                ),
                BoxShadow(
                  color: cyberPink.withOpacity(_glowPulse.value * 0.6),
                  blurRadius: 60,
                  spreadRadius: 8,
                ),
                BoxShadow(
                  color: cyberPurple.withOpacity(_glowPulse.value * 0.4),
                  blurRadius: 80,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: darkBackground.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: cyberCyan.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icons/Gateways logo.png',
                  fit: BoxFit.contain,
                  width: 120,
                  height: 120,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [cyberCyan, cyberPurple, cyberPink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.event_available,
                        size: 60,
                        color: darkBackground,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: Listenable.merge([_textController, _glowController]),
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacity.value,
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [cyberCyan, cyberPink, cyberYellow],
              ).createShader(bounds);
            },
            child: Text(
              'GATEWAYS',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.white,
                fontFamily: 'monospace',
                shadows: [
                  Shadow(
                    color: cyberCyan.withOpacity(_glowPulse.value),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubtitle() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textOpacity.value * 0.8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: neonGreen.withOpacity(0.6)),
              gradient: LinearGradient(
                colors: [neonGreen.withOpacity(0.1), Colors.transparent],
              ),
            ),
            child: Text(
              'EVENT REGISTRATION PORTAL',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: neonGreen,
                fontFamily: 'monospace',
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingMessage() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Container(
          height: 60,
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _loadingMessages[_currentMessageIndex],
              key: ValueKey(_currentMessageIndex),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: cyberYellow.withOpacity(0.8),
                fontFamily: 'monospace',
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingProgress() {
    return Positioned(
      bottom: 80,
      left: 40,
      right: 40,
      child: Column(
        children: [
          // Loading message
          _buildLoadingMessage(),

          const SizedBox(height: 20),

          // Progress bar
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: cardBackground,
                ),
                child: Stack(
                  children: [
                    // Background
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: cardBackground,
                      ),
                    ),
                    // Progress fill
                    FractionallySizedBox(
                      widthFactor: _progressValue.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [cyberCyan, cyberPink],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cyberCyan.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Progress percentage
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return Text(
                '${(_progressValue.value * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: cyberCyan.withOpacity(0.8),
                  fontFamily: 'monospace',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Custom painter for event-themed particles
class EventParticlesPainter extends CustomPainter {
  final double animationValue;

  EventParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Event icons as particles
    const colors = [
      Color(0xFF00F0FF), // cyberCyan
      Color(0xFFFF0080), // cyberPink
      Color(0xFFFFFF00), // cyberYellow
      Color(0xFF00FF88), // neonGreen
    ];

    for (int i = 0; i < 30; i++) {
      final progress = (animationValue + i * 0.1) % 1.0;
      final x = (sin(i * 2.0 + animationValue * 2) * 0.4 + 0.5) * size.width;
      final y = (progress * 1.2 - 0.1) * size.height;

      if (y >= 0 && y <= size.height) {
        final opacity = sin(progress * pi) * 0.6;
        final color = colors[i % colors.length];

        paint.color = color.withOpacity(opacity);
        paint.style = PaintingStyle.fill;

        // Draw event-related shapes
        if (i % 3 == 0) {
          // Calendar icon
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(x, y), width: 6, height: 6),
              const Radius.circular(1),
            ),
            paint,
          );
        } else if (i % 3 == 1) {
          // Star for events
          _drawStar(canvas, Offset(x, y), 3, paint);
        } else {
          // Simple circle
          canvas.drawCircle(Offset(x, y), 2, paint);
        }
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const points = 5;
    final angle = (2 * pi) / points;
    final path = Path();

    for (int i = 0; i < points * 2; i++) {
      final r = i % 2 == 0 ? radius : radius * 0.5;
      final x = center.dx + r * cos(i * angle - pi / 2);
      final y = center.dy + r * sin(i * angle - pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for circuit pattern
class CircuitPatternPainter extends CustomPainter {
  final double animationValue;

  CircuitPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const cyberCyan = Color(0xFF00F0FF);
    const cyberPink = Color(0xFFFF0080);

    // Draw network connections
    for (int i = 0; i < 8; i++) {
      final progress = (animationValue + i * 0.2) % 1.0;
      final opacity = sin(progress * pi) * 0.3;

      paint.color = (i % 2 == 0 ? cyberCyan : cyberPink).withOpacity(opacity);

      final startX = (i / 8) * size.width;
      final endX = ((i + 1) / 8) * size.width;
      final y = size.height * (0.2 + sin(animationValue * 2 + i) * 0.1);

      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y + sin(progress * pi * 2) * 20),
        paint,
      );
    }

    // Draw connection nodes
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 12; i++) {
      final x = (i / 12) * size.width;
      final y = size.height * (0.8 + sin(animationValue * 3 + i) * 0.05);
      final opacity = (sin(animationValue * 4 + i) * 0.5 + 0.5) * 0.4;

      paint.color = cyberCyan.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
