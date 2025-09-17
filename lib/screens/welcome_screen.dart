import 'dart:async';
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
    for (int i = 0; i < 50; i++) {
      particles.add(
        Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 3 + 1,
          speed: _random.nextDouble() * 0.5 + 0.1,
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
      final opacity = currentY > 1.0 ? (1.2 - currentY) * 5 : 1.0;

      if (opacity > 0) {
        paint.color = particle.color.withOpacity(opacity * 0.6);

        // Add subtle glow effect
        paint.maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          particle.size * 0.5,
        );

        canvas.drawCircle(
          Offset(
            particle.x * size.width +
                sin(animationValue * 2 * pi + particle.x * 10) * 10,
            currentY * size.height,
          ),
          particle.size,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Smooth glow effect for text
class GlowText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Color glowColor;

  const GlowText({
    super.key,
    required this.text,
    required this.style,
    required this.glowColor,
  });

  @override
  State<GlowText> createState() => _GlowTextState();
}

class _GlowTextState extends State<GlowText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Text(
          widget.text,
          style: widget.style.copyWith(
            shadows: [
              Shadow(
                color: widget.glowColor.withOpacity(_glowAnimation.value * 0.8),
                blurRadius: 15,
              ),
              Shadow(
                color: widget.glowColor.withOpacity(_glowAnimation.value * 0.4),
                blurRadius: 30,
              ),
              Shadow(color: widget.glowColor, blurRadius: 0),
            ],
          ),
        );
      },
    );
  }
}

// Animated gradient background
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                -0.7 + sin(_controller.value * 2 * pi) * 0.3,
                -0.8 + cos(_controller.value * 2 * pi) * 0.2,
              ),
              radius: 1.2 + sin(_controller.value * pi) * 0.3,
              colors: [
                const Color(0xFF00F0FF).withOpacity(0.15),
                const Color(0xFFFF0080).withOpacity(0.08),
                const Color(0xFF9D00FF).withOpacity(0.05),
                const Color(0xFF0A0A0F),
                const Color(0xFF000000),
              ],
              stops: const [0, 0.2, 0.4, 0.8, 1],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _countdownController;
  late Timer _timer;
  Duration _timeUntilEvent = Duration.zero;

  // Enhanced Cyberpunk 2077 color palette for event management
  static const Color cyberCyan = Color(0xFF00F0FF);
  static const Color cyberPink = Color(0xFFFF0080);
  static const Color cyberYellow = Color(0xFFFFFF00);
  static const Color cyberPurple = Color(0xFF9D00FF);
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color surfaceColor = Color(0xFF16213E);
  static const Color neonGreen = Color(0xFF00FF88);

  @override
  void initState() {
    super.initState();
    _countdownController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
    });
  }

  @override
  void dispose() {
    _countdownController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final eventDate = DateTime(2025, 9, 25);
    setState(() {
      _timeUntilEvent = eventDate.difference(now);
      if (_timeUntilEvent.isNegative) {
        _timeUntilEvent = Duration.zero;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: FloatingParticles(
        child: AnimatedGradientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Enhanced header with event management focus
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      cyberCyan.withOpacity(0.3),
                                      cyberPurple.withOpacity(0.2),
                                      cyberPink.withOpacity(0.1),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: cyberCyan.withOpacity(0.6),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cyberCyan.withOpacity(0.4),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/icons/Gateways logo.png',
                                    fit: BoxFit.contain,
                                    color: Colors.white,
                                    colorBlendMode: BlendMode.srcIn,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.event_available,
                                        color: cyberCyan,
                                        size: 24,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GlowText(
                                text: 'GATEWAYS',
                                glowColor: cyberCyan,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: neonGreen.withOpacity(0.6),
                                width: 1,
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  neonGreen.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.rocket_launch,
                                  color: neonGreen,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'EVENT REGISTRATION PORTAL',
                                  style: TextStyle(
                                    color: neonGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Discover • Register • Participate',
                            style: TextStyle(
                              color: cyberYellow.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Large Event Countdown Section
                    if (_timeUntilEvent > Duration.zero)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              cardBackground.withOpacity(0.9),
                              surfaceColor.withOpacity(0.7),
                              darkBackground.withOpacity(0.8),
                            ],
                          ),
                          border: Border.all(
                            color: cyberCyan.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cyberPurple.withOpacity(0.1),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'EVENT COUNTDOWN',
                              style: TextStyle(
                                color: cyberCyan,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildLargeCountdownItem(),
                          ],
                        ),
                      ),

                    const SizedBox(height: 30),

                    // Quick Stats Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            cyberPurple.withOpacity(0.1),
                            cyberCyan.withOpacity(0.05),
                          ],
                        ),
                        border: Border.all(
                          color: cyberPurple.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('11', 'Events', cyberCyan),
                          _buildStatItem('24/7', 'Support', neonGreen),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Main Navigation Grid
                    Text(
                      'EXPLORE CATEGORIES',
                      style: TextStyle(
                        color: cyberYellow,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),

                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.95,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        EventCategoryCard(
                          title: 'EVENTS',
                          subtitle: 'Coding & IT',
                          icon: Icons.computer,
                          accent: cyberCyan,
                          eventCount: 11,
                          onTap: () => Navigator.pushNamed(context, '/events'),
                        ),
                        EventCategoryCard(
                          title: 'BROCHURE',
                          subtitle: 'Meet the Team',
                          icon: Icons.sports_esports,
                          accent: cyberPink,
                          onTap: () async {
                            final url = Uri.parse(
                              'https://heyzine.com/flip-book/746bdd4368.html',
                            );
                            try {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                                webViewConfiguration:
                                    const WebViewConfiguration(
                                      enableJavaScript: true,
                                    ),
                              );
                            } catch (e) {
                              // Fallback: show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Could not open brochure link: $e',
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                        ),
                        EventCategoryCard(
                          title: 'ABOUT',
                          subtitle: 'Mission & Vision',
                          icon: Icons.palette,
                          accent: cyberYellow,
                          onTap: () => Navigator.pushNamed(context, '/about'),
                        ),
                        EventCategoryCard(
                          title: 'CHRIST INFO',
                          subtitle: 'University Details',
                          icon: Icons.info,
                          accent: cyberPurple,
                          onTap: () async {
                            final url = Uri.parse(
                              'https://christuniversity.in/',
                            );
                            try {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                                webViewConfiguration:
                                    const WebViewConfiguration(
                                      enableJavaScript: true,
                                    ),
                              );
                            } catch (e) {
                              // Fallback: show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Could not open CHRIST University website: $e',
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeCountdownItem() {
    return AnimatedBuilder(
      animation: _countdownController,
      builder: (context, child) {
        final days = _timeUntilEvent.inDays;
        final hours = _timeUntilEvent.inHours % 24;
        final minutes = _timeUntilEvent.inMinutes % 60;
        final seconds = _timeUntilEvent.inSeconds % 60;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildCountdownUnit(days, 'DAYS')),
                const SizedBox(width: 8),
                Expanded(child: _buildCountdownUnit(hours, 'HOURS')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _buildCountdownUnit(minutes, 'MINS')),
                const SizedBox(width: 8),
                Expanded(child: _buildCountdownUnit(seconds, 'SECS')),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildCountdownUnit(int value, String label) {
    return AnimatedBuilder(
      animation: _countdownController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                surfaceColor.withOpacity(0.8),
                cardBackground.withOpacity(0.6),
              ],
            ),
            border: Border.all(color: cyberCyan.withOpacity(0.4), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [cyberYellow, cyberPink, cyberCyan],
                    stops: [0.0, 0.5, 1.0],
                  ).createShader(bounds);
                },
                child: Text(
                  value.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: cyberCyan.withOpacity(0.7),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Animated divider component
class AnimatedDivider extends StatefulWidget {
  @override
  State<AnimatedDivider> createState() => _AnimatedDividerState();
}

class _AnimatedDividerState extends State<AnimatedDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                _WelcomeScreenState.cyberCyan.withOpacity(0.8),
                _WelcomeScreenState.cyberPink.withOpacity(0.8),
                _WelcomeScreenState.cyberYellow.withOpacity(0.8),
                _WelcomeScreenState.cyberPurple.withOpacity(0.8),
                Colors.transparent,
              ],
              stops: [
                0,
                0.2 + sin(_controller.value * 2 * pi) * 0.1,
                0.4 + cos(_controller.value * 2 * pi) * 0.1,
                0.6 + sin(_controller.value * 3 * pi) * 0.1,
                0.8 + cos(_controller.value * 3 * pi) * 0.1,
                1,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _WelcomeScreenState.cyberCyan.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Modern and innovative cyber card design
class ModernCyberCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;
  final int index;

  const ModernCyberCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.accent,
    required this.index,
  });

  @override
  State<ModernCyberCard> createState() => _ModernCyberCardState();
}

class _ModernCyberCardState extends State<ModernCyberCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _elevationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    // Staggered animation start
    Future.delayed(Duration(milliseconds: widget.index * 200), () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
        _rotationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  String _getCardDescription(String title) {
    switch (title) {
      case 'EVENTS':
        return 'Browse and register for\nupcoming tech events';
      case 'BROCHURE':
        return 'Connect with our team\nmembers and organizers';
      case 'ABOUT':
        return 'Learn about our mission\nand core values';
      case 'CONFIG':
        return 'Customize your app\npreferences and settings';
      default:
        return 'Explore this section\nfor more information';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _hoverController,
        _pulseController,
        _rotationController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _isHovered = true);
                _hoverController.forward();
              },
              onExit: (_) {
                setState(() => _isHovered = false);
                _hoverController.reverse();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _WelcomeScreenState.cardBackground.withOpacity(0.9),
                      _WelcomeScreenState.surfaceColor.withOpacity(0.7),
                      _WelcomeScreenState.darkBackground.withOpacity(0.95),
                    ],
                  ),
                  border: Border.all(
                    color: widget.accent.withOpacity(_isHovered ? 0.9 : 0.4),
                    width: _isHovered ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accent.withOpacity(
                        0.25 * _pulseAnimation.value,
                      ),
                      blurRadius: 25 + (_elevationAnimation.value * 15),
                      spreadRadius: _isHovered ? 5 : 2,
                      offset: Offset(0, 4 + (_elevationAnimation.value * 10)),
                    ),
                    if (_isHovered)
                      BoxShadow(
                        color: widget.accent.withOpacity(0.15),
                        blurRadius: 50,
                        spreadRadius: 10,
                      ),
                    // Inner glow effect
                    BoxShadow(
                      color: widget.accent.withOpacity(
                        0.1 * _pulseAnimation.value,
                      ),
                      blurRadius: 10,
                      spreadRadius: -2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Animated background pattern
                      Positioned.fill(
                        child: CustomPaint(
                          painter: CircuitPatternPainter(
                            widget.accent,
                            _rotationAnimation.value,
                            _pulseAnimation.value,
                          ),
                        ),
                      ),

                      // Main content - Better centered design
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Enhanced icon container with better positioning
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      widget.accent.withOpacity(0.3),
                                      widget.accent.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                  border: Border.all(
                                    color: widget.accent.withOpacity(0.6),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.accent.withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Transform.rotate(
                                  angle: _isHovered
                                      ? _rotationAnimation.value * 2 * pi
                                      : 0,
                                  child: Icon(
                                    widget.icon,
                                    color: widget.accent,
                                    size: 28,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Enhanced title with better spacing
                              Text(
                                widget.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  fontFamily: 'monospace',
                                  shadows: [
                                    Shadow(
                                      color: widget.accent.withOpacity(0.6),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Enhanced subtitle
                              Text(
                                widget.subtitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: widget.accent.withOpacity(0.8),
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                  letterSpacing: 0.5,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Description text based on card type
                              Text(
                                _getCardDescription(widget.title),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 8,
                                  fontFamily: 'monospace',
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 10),

                              // Interactive arrow with animation
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                transform: Matrix4.translationValues(
                                  _isHovered ? 4 : 0,
                                  0,
                                  0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            widget.accent.withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: widget.accent,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Enhanced hover overlay with multiple effects
                      if (_isHovered)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  widget.accent.withOpacity(0.15),
                                  Colors.transparent,
                                  widget.accent.withOpacity(0.08),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Animated border effect
                      if (_isHovered)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: widget.accent.withOpacity(0.6),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Event Category Card for the redesigned welcome screen
class EventCategoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color accent;
  final int? eventCount;

  const EventCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.accent,
    this.eventCount,
  });

  @override
  State<EventCategoryCard> createState() => _EventCategoryCardState();
}

class _EventCategoryCardState extends State<EventCategoryCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: MouseRegion(
              onEnter: (_) {
                setState(() => _isHovered = true);
                _hoverController.forward();
              },
              onExit: (_) {
                setState(() => _isHovered = false);
                _hoverController.reverse();
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.accent.withOpacity(0.15),
                      widget.accent.withOpacity(0.05),
                      _WelcomeScreenState.darkBackground.withOpacity(0.9),
                    ],
                  ),
                  border: Border.all(
                    color: widget.accent.withOpacity(_isHovered ? 0.8 : 0.4),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accent.withOpacity(
                        0.2 * _glowAnimation.value,
                      ),
                      blurRadius: 20,
                      spreadRadius: _isHovered ? 3 : 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon and count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: widget.title == 'BROCHURE'
                              ? Image.asset(
                                  'assets/icons/brochure.png',
                                  width: 24,
                                  height: 24,
                                  color: widget.accent,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.description,
                                      color: widget.accent,
                                      size: 24,
                                    );
                                  },
                                )
                              : widget.title == 'ABOUT'
                              ? Image.asset(
                                  'assets/icons/about.png',
                                  width: 24,
                                  height: 24,
                                  color: widget.accent,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.info,
                                      color: widget.accent,
                                      size: 24,
                                    );
                                  },
                                )
                              : widget.title == 'CHRIST INFO'
                              ? Image.asset(
                                  'assets/icons/info.png',
                                  width: 24,
                                  height: 24,
                                  color: widget.accent,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.info_outline,
                                      color: widget.accent,
                                      size: 24,
                                    );
                                  },
                                )
                              : Icon(
                                  widget.icon,
                                  color: widget.accent,
                                  size: 24,
                                ),
                        ),
                        if (widget.eventCount != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _WelcomeScreenState.neonGreen.withOpacity(
                                0.2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${widget.eventCount}',
                              style: TextStyle(
                                color: _WelcomeScreenState.neonGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Subtitle
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: widget.accent.withOpacity(0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Action indicator
                    Row(
                      children: [
                        Text(
                          'Explore Events',
                          style: TextStyle(
                            color: widget.accent.withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          color: widget.accent.withOpacity(0.6),
                          size: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Circuit pattern painter for card backgrounds
class CircuitPatternPainter extends CustomPainter {
  final Color color;
  final double progress;
  final double pulse;

  CircuitPatternPainter(this.color, this.progress, this.pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1 * pulse)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 3;

    // Draw animated concentric circles
    for (int i = 1; i <= 3; i++) {
      final currentRadius = radius * i / 3 * (0.8 + 0.4 * pulse);
      paint.color = color.withOpacity(0.05 * pulse * (4 - i));
      canvas.drawCircle(center, currentRadius, paint);
    }

    // Draw connecting lines
    final lineCount = 8;
    for (int i = 0; i < lineCount; i++) {
      final angle = (i / lineCount) * 2 * pi + progress * 2 * pi;
      final startRadius = radius * 0.3;
      final endRadius = radius * 0.8;

      final start = Offset(
        center.dx + cos(angle) * startRadius,
        center.dy + sin(angle) * startRadius,
      );
      final end = Offset(
        center.dx + cos(angle) * endRadius,
        center.dy + sin(angle) * endRadius,
      );

      paint.color = color.withOpacity(0.08 * pulse);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
