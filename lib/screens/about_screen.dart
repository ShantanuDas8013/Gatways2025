import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Floating particles animation
class FloatingParticles extends StatefulWidget {
  final Widget child;
  const FloatingParticles({super.key, required this.child});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Generate particles
    for (int i = 0; i < 30; i++) {
      particles.add(
        Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2 + 1,
          speed: _random.nextDouble() * 0.3 + 0.05,
          color: [
            const Color(0xFF00F0FF),
            const Color(0xFFFF0080),
            const Color(0xFFFFFF00),
            const Color(0xFF9D00FF),
          ][_random.nextInt(4)],
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: ParticlesPainter(particles, _controller.value),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class Particle {
  double x, y, size, speed;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlesPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final currentY = (particle.y + animationValue * particle.speed) % 1.2;
      final opacity = (1.0 - currentY).clamp(0.0, 1.0);

      paint.color = particle.color.withOpacity(opacity * 0.6);
      canvas.drawCircle(
        Offset(particle.x * size.width, currentY * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Cyberpunk colors
  static const Color cyberCyan = Color(0xFF00F0FF);
  static const Color cyberPink = Color(0xFFFF0080);
  static const Color cyberYellow = Color(0xFFFFFF00);
  static const Color cyberPurple = Color(0xFF9D00FF);
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color neonGreen = Color(0xFF00FF88);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingParticles(
      child: Scaffold(
        backgroundColor: darkBackground,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: cyberCyan,
              shadows: [
                Shadow(
                  color: cyberCyan.withOpacity(0.5),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'About Gateways',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: cyberCyan.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                darkBackground,
                cardBackground.withOpacity(0.3),
                darkBackground,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Integrated Hero Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cyberPurple.withOpacity(0.2),
                          cyberCyan.withOpacity(0.15),
                          cyberPink.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: cyberCyan.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cyberCyan.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Animated Logo Container
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      cyberCyan.withOpacity(0.2),
                                      cyberPurple.withOpacity(0.15),
                                      cyberPink.withOpacity(0.1),
                                      cyberYellow.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: cyberCyan.withOpacity(0.6),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cyberCyan.withOpacity(0.4),
                                      blurRadius: 25,
                                      spreadRadius: 3,
                                    ),
                                    BoxShadow(
                                      color: cyberPurple.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: cyberCyan.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      'assets/icons/Gateways logo.png',
                                      fit: BoxFit.contain,
                                      color: Colors.white,
                                      colorBlendMode: BlendMode.srcIn,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    cyberCyan,
                                                    cyberPurple,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Icon(
                                                Icons.celebration,
                                                size: 40,
                                                color: Colors.white,
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

                        const SizedBox(height: 25),

                        // Title with animated text
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Column(
                                  children: [
                                    Text(
                                      'Gateways 2025',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: cyberCyan.withOpacity(0.6),
                                            blurRadius: 20,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'National Technical Fest',
                                      style: TextStyle(
                                        color: cyberYellow,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        shadows: [
                                          Shadow(
                                            color: cyberYellow.withOpacity(0.5),
                                            blurRadius: 10,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            neonGreen.withOpacity(0.2),
                                            neonGreen.withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: neonGreen.withOpacity(0.4),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        '29+ Years of Innovation',
                                        style: TextStyle(
                                          color: neonGreen,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Flowing Content Sections
                  _buildFlowingSection(
                    title: 'Our Legacy',
                    content:
                        'Gateways is the national technical fest, held annually for over 29 years by the Department of Computer Science at CHRIST (Deemed to be University), Bangalore.',
                    icon: Icons.history,
                    gradientColors: [cyberCyan, cyberPurple],
                    delay: 300,
                    isFirst: true,
                  ),

                  _buildFlowingSection(
                    title: 'Innovation Hub',
                    content:
                        'Organized by students of the post-graduate MCA and MSc AI-ML programs, we aim to be at the forefront of innovation and collaboration, with new ideas and events presented each year.',
                    icon: Icons.lightbulb,
                    gradientColors: [cyberYellow, cyberPink],
                    delay: 500,
                    isFirst: false,
                  ),

                  _buildFlowingSection(
                    title: 'National Gathering',
                    content:
                        'We invite colleges from all over India, with enthusiastic participation from those who join us for this gathering of minds. An essential part of Gateways is its robust and dynamic theme, reflecting both current trends and the rich history of the discipline.',
                    icon: Icons.groups,
                    gradientColors: [neonGreen, cyberCyan],
                    delay: 700,
                    isFirst: false,
                  ),

                  const SizedBox(height: 40),

                  // Integrated Footer/Contact Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cyberPurple.withOpacity(0.15),
                          cyberPink.withOpacity(0.1),
                          cyberYellow.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: cyberYellow.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cyberYellow.withOpacity(0.1),
                          blurRadius: 25,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Contact Icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [cyberYellow, cyberPink],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: cyberYellow.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.connect_without_contact,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Join the Innovation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: cyberYellow.withOpacity(0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Ready to be part of India\'s premier technical fest? Join us for an unforgettable experience of innovation, learning, and collaboration.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 25),

                        // Contact Info
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: darkBackground.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: cyberCyan.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.email, color: cyberCyan, size: 24),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final Uri emailUri = Uri(
                                          scheme: 'mailto',
                                          path:
                                              'gateways@cs.christuniversity.in',
                                        );
                                        try {
                                          await launchUrl(emailUri);
                                        } catch (e) {
                                          // Fallback: show error message
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Could not open email app: $e',
                                                ),
                                                backgroundColor: Colors.red,
                                                duration: const Duration(
                                                  seconds: 3,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Text(
                                        'gateways@cs.christuniversity.in',
                                        style: TextStyle(
                                          color: cyberCyan,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 1,
                                width: 200,
                                color: cyberCyan.withOpacity(0.3),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Department of Computer Science\nCHRIST (Deemed to be University)\nBangalore, India',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowingSection({
    required String title,
    required String content,
    required IconData icon,
    required List<Color> gradientColors,
    required int delay,
    required bool isFirst,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(isFirst ? 0 : 30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 25),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradientColors[0].withOpacity(0.08),
                    gradientColors[1].withOpacity(0.04),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: gradientColors[0].withOpacity(0.25),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: gradientColors[0].withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: gradientColors[0].withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
