import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:gateways_app/core/app_colors.dart';
import 'package:gateways_app/models/event_model.dart';
import 'package:gateways_app/widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _circuitController;
  late AnimationController _dataStreamController;
  late AnimationController _energyFieldController;
  late AnimationController _hexagonController;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _circuitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _dataStreamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _energyFieldController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _hexagonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _circuitController.dispose();
    _dataStreamController.dispose();
    _energyFieldController.dispose();
    _hexagonController.dispose();
    super.dispose();
  }

  final List<EventModel> _events = [
    EventModel(
      title: 'Cyber-Hack 2025',
      description: 'A 24-hour hackathon to build the future.',
      imagePath: '',
    ),
    EventModel(
      title: 'Robo-Wars',
      description: 'Build and battle your own robot.',
      imagePath: '',
    ),
    EventModel(
      title: 'Tech Conference',
      description: 'Talks from industry leaders.',
      imagePath: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              final animationProgress = _textController.value;
              final glowIntensity =
                  math.sin(animationProgress * 2 * math.pi) * 0.3 + 0.7;

              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color.lerp(
                        AppColors.neonCyan.withOpacity(0.2),
                        AppColors.accentColor.withOpacity(0.2),
                        animationProgress,
                      )!,
                      Color.lerp(
                        AppColors.accentColor.withOpacity(0.15),
                        AppColors.neonYellow.withOpacity(0.15),
                        animationProgress,
                      )!,
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(
                        AppColors.neonCyan,
                        AppColors.accentColor,
                        animationProgress,
                      )!.withOpacity(0.3 * glowIntensity),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Color.lerp(
                        AppColors.accentColor,
                        AppColors.neonYellow,
                        animationProgress,
                      )!.withOpacity(0.2 * glowIntensity),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                  border: Border.all(
                    color: Color.lerp(
                      AppColors.neonCyan,
                      AppColors.accentColor,
                      animationProgress,
                    )!.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  tooltip: 'Back',
                  onPressed: () async {
                    // Prefer popping the current route; if nothing to pop, navigate to welcome screen
                    final popped = await Navigator.maybePop(context);
                    if (!popped) {
                      Navigator.pushReplacementNamed(context, '/welcome');
                    }
                  },
                  icon: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(
                          AppColors.neonCyan,
                          AppColors.neonYellow,
                          animationProgress,
                        )!,
                        Color.lerp(
                          AppColors.accentColor,
                          AppColors.neonCyan,
                          animationProgress,
                        )!,
                      ],
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        title: AnimatedBuilder(
          animation: _textController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      AppColors.neonCyan,
                      AppColors.neonYellow,
                      math.sin(_textController.value * 2 * math.pi) * 0.5 + 0.5,
                    )!,
                    Color.lerp(
                      AppColors.accentColor,
                      AppColors.neonCyan,
                      math.cos(_textController.value * 2 * math.pi) * 0.5 + 0.5,
                    )!,
                    Color.lerp(
                      AppColors.neonYellow,
                      AppColors.accentColor,
                      math.sin(_textController.value * 3 * math.pi) * 0.5 + 0.5,
                    )!,
                  ],
                  stops: [
                    0.0,
                    math.sin(_textController.value * 2 * math.pi) * 0.3 + 0.5,
                    1.0,
                  ],
                ).createShader(bounds);
              },
              child: Text(
                'Events',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: AppColors.neonCyan.withOpacity(0.8),
                      offset: const Offset(0, 0),
                    ),
                    Shadow(
                      blurRadius: 18,
                      color: AppColors.accentColor.withOpacity(0.6),
                      offset: const Offset(2, 1),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Deep Space Base Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 2.0,
                colors: [
                  Color(0xFF0D0D2B),
                  Color(0xFF1A1A3A),
                  Color(0xFF0A0A20),
                  Color(0xFF050512),
                ],
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Animated Hexagon Network
          // Spacer to avoid content under the transparent AppBar
          SizedBox(
            height: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
          ),
          AnimatedBuilder(
            animation: _circuitController,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: AdvancedCircuitPainter(_circuitController.value),
                ),
              );
            },
          ),

          // Quantum Particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: QuantumParticlePainter(_particleController.value),
                ),
              );
            },
          ),

          // Dynamic Neural Network
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      math.sin(_backgroundController.value * 2 * math.pi) * 0.4,
                      math.cos(_backgroundController.value * 1.5 * math.pi) *
                          0.3,
                    ),
                    radius: 2.0,
                    colors: [
                      AppColors.neonCyan.withOpacity(0.08),
                      AppColors.accentColor.withOpacity(0.04),
                      Colors.transparent,
                      AppColors.neonYellow.withOpacity(0.02),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.4, 0.7, 1.0],
                  ),
                ),
              );
            },
          ),

          // Holographic Interface Overlay
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: HolographicInterfacePainter(
                    _backgroundController.value,
                  ),
                ),
              );
            },
          ),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add spacing for the app bar without affecting scroll
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 0, bottom: 20),
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: index == 0 ? 0 : 8,
                          bottom: index == _events.length - 1 ? 0 : 8,
                        ),
                        child: EventCard(event: _events[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Hexagon Network
class HexagonNetworkPainter extends CustomPainter {
  final double animationValue;

  HexagonNetworkPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const hexSize = 60.0;
    final rows = (size.height / (hexSize * 0.75)).ceil() + 2;
    final cols = (size.width / (hexSize * math.sqrt(3))).ceil() + 2;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final offset = (row % 2) * hexSize * math.sqrt(3) / 2;
        final x = col * hexSize * math.sqrt(3) + offset;
        final y = row * hexSize * 0.75;

        final hexProgress = (animationValue + (row + col) * 0.1) % 1.0;
        final opacity = math.sin(hexProgress * math.pi) * 0.5 + 0.1;

        final colorLerp =
            (math.sin(animationValue * 2 * math.pi + row * 0.5) + 1) / 2;
        final hexColor = Color.lerp(
          AppColors.neonCyan,
          AppColors.accentColor,
          colorLerp,
        )!;

        paint.color = hexColor.withOpacity(opacity.abs());

        _drawHexagon(canvas, Offset(x, y), hexSize * 0.8, paint);

        // Draw connections
        if (opacity > 0.3) {
          paint.strokeWidth = 0.5;
          paint.color = hexColor.withOpacity(opacity * 0.4);

          if (col < cols - 1) {
            canvas.drawLine(
              Offset(x + hexSize * math.sqrt(3) * 0.5, y),
              Offset(x + hexSize * math.sqrt(3), y),
              paint,
            );
          }
        }
        paint.strokeWidth = 1.0;
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final x = center.dx + size * math.cos(angle);
      final y = center.dy + size * math.sin(angle);

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
  bool shouldRepaint(HexagonNetworkPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Custom Painter for Energy Field Waves
class EnergyFieldPainter extends CustomPainter {
  final double animationValue;

  EnergyFieldPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < 5; i++) {
      final waveProgress = (animationValue + i * 0.2) % 1.0;
      final amplitude = 50.0 + i * 20.0;
      final frequency = 0.02 + i * 0.005;
      final opacity = math.sin(waveProgress * math.pi) * 0.6;

      final colorIndex = i % 3;
      Color waveColor;
      switch (colorIndex) {
        case 0:
          waveColor = AppColors.neonCyan;
          break;
        case 1:
          waveColor = AppColors.accentColor;
          break;
        default:
          waveColor = AppColors.neonYellow;
      }

      paint.color = waveColor.withOpacity(opacity.abs());

      final path = Path();
      bool firstPoint = true;

      for (double x = 0; x <= size.width; x += 5) {
        final y =
            size.height * 0.5 +
            amplitude * math.sin(x * frequency + animationValue * 4 * math.pi) +
            20 *
                math.sin(x * frequency * 3 + animationValue * 6 * math.pi) *
                math.sin(waveProgress * 2 * math.pi);

        if (firstPoint) {
          path.moveTo(x, y);
          firstPoint = false;
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);

      // Add glow effect
      paint.strokeWidth = 6.0;
      paint.color = waveColor.withOpacity(opacity.abs() * 0.3);
      canvas.drawPath(path, paint);
      paint.strokeWidth = 2.0;
    }
  }

  @override
  bool shouldRepaint(EnergyFieldPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Custom Painter for Data Stream Lines
class DataStreamPainter extends CustomPainter {
  final double animationValue;

  DataStreamPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    // Vertical data streams
    for (int i = 0; i < 12; i++) {
      final streamX =
          size.width * (i / 12) +
          math.sin(animationValue * 2 * math.pi + i) * 30;
      final streamSpeed = 1.0 + i * 0.1;

      for (int j = 0; j < 8; j++) {
        final segmentProgress = (animationValue * streamSpeed + j * 0.3) % 1.0;
        final segmentY =
            segmentProgress * size.height * 1.5 - size.height * 0.25;

        if (segmentY >= 0 && segmentY <= size.height) {
          final opacity = math.sin(segmentProgress * math.pi) * 0.8;
          final segmentSize =
              2.0 + math.sin(segmentProgress * math.pi * 4) * 1.5;

          final colorLerp = (j % 3) / 3.0;
          Color segmentColor;
          if (colorLerp < 0.33) {
            segmentColor = AppColors.neonCyan;
          } else if (colorLerp < 0.66) {
            segmentColor = AppColors.neonYellow;
          } else {
            segmentColor = AppColors.accentColor;
          }

          paint.color = segmentColor.withOpacity(opacity.abs());

          // Draw data segment as elongated rectangle
          final rect = RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(streamX, segmentY),
              width: segmentSize,
              height: segmentSize * 4,
            ),
            const Radius.circular(1),
          );

          canvas.drawRRect(rect, paint);

          // Add trail effect
          paint.color = segmentColor.withOpacity(opacity.abs() * 0.3);
          final trailRect = RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(streamX, segmentY + 8),
              width: segmentSize * 0.5,
              height: segmentSize * 8,
            ),
            const Radius.circular(1),
          );
          canvas.drawRRect(trailRect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(DataStreamPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Custom Painter for Advanced Circuit Network
class AdvancedCircuitPainter extends CustomPainter {
  final double animationValue;

  AdvancedCircuitPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Neural network connections
    for (int layer = 0; layer < 4; layer++) {
      final layerX = size.width * (layer / 4) + size.width * 0.1;
      final nodeCount = 6 - layer;

      for (int node = 0; node < nodeCount; node++) {
        final nodeY = size.height * ((node + 1) / (nodeCount + 1));
        final nodeProgress = (animationValue + layer * 0.2 + node * 0.1) % 1.0;
        final nodeOpacity = math.sin(nodeProgress * math.pi * 2) * 0.5 + 0.5;

        // Draw node
        paint.style = PaintingStyle.fill;
        paint.color = AppColors.neonCyan.withOpacity(nodeOpacity.abs());
        canvas.drawCircle(Offset(layerX, nodeY), 3, paint);

        // Draw connections to next layer
        if (layer < 3) {
          paint.style = PaintingStyle.stroke;
          final nextLayerX = size.width * ((layer + 1) / 4) + size.width * 0.1;
          final nextNodeCount = 6 - (layer + 1);

          for (int nextNode = 0; nextNode < nextNodeCount; nextNode++) {
            final nextNodeY =
                size.height * ((nextNode + 1) / (nextNodeCount + 1));
            final connectionProgress =
                (animationValue * 2 + layer + node + nextNode * 0.1) % 1.0;
            final connectionOpacity =
                math.sin(connectionProgress * math.pi) * 0.4;

            final connectionColor = Color.lerp(
              AppColors.neonCyan,
              AppColors.accentColor,
              connectionProgress,
            )!;

            paint.color = connectionColor.withOpacity(connectionOpacity.abs());
            paint.strokeWidth = 1.0 + connectionOpacity.abs();

            canvas.drawLine(
              Offset(layerX, nodeY),
              Offset(nextLayerX, nextNodeY),
              paint,
            );
          }
        }
      }
    }

    // Add circuit pathways
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;

    for (int i = 0; i < 6; i++) {
      final pathProgress = (animationValue * 0.8 + i * 0.15) % 1.0;
      final pathOpacity = math.sin(pathProgress * math.pi) * 0.7;

      paint.color = AppColors.neonYellow.withOpacity(pathOpacity.abs());

      final path = Path();
      final startX = size.width * 0.1;
      final startY = size.height * (0.2 + i * 0.12);
      final endX = size.width * 0.9;
      final endY = startY + math.sin(pathProgress * math.pi * 4) * 40;

      path.moveTo(startX, startY);
      path.quadraticBezierTo(
        size.width * 0.3 + math.sin(pathProgress * math.pi * 6) * 50,
        startY + math.cos(pathProgress * math.pi * 8) * 30,
        size.width * 0.6,
        startY + math.sin(pathProgress * math.pi * 3) * 20,
      );
      path.quadraticBezierTo(size.width * 0.8, endY, endX, endY);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(AdvancedCircuitPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Custom Painter for Quantum Particles
class QuantumParticlePainter extends CustomPainter {
  final double animationValue;

  QuantumParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    // Quantum particle systems
    for (int system = 0; system < 3; system++) {
      final systemCenterX = size.width * (0.2 + system * 0.3);
      final systemCenterY = size.height * (0.3 + system * 0.2);
      final systemRadius = 80.0 + system * 20.0;

      for (int particle = 0; particle < 12; particle++) {
        final particleAngle =
            (particle / 12) * 2 * math.pi +
            animationValue * (2 + system * 0.5) * math.pi;
        final particleRadius =
            systemRadius +
            math.sin(animationValue * 4 * math.pi + particle) * 20;

        final particleX =
            systemCenterX + particleRadius * math.cos(particleAngle);
        final particleY =
            systemCenterY + particleRadius * math.sin(particleAngle);

        if (particleX >= 0 &&
            particleX <= size.width &&
            particleY >= 0 &&
            particleY <= size.height) {
          final particleOpacity =
              math.sin(animationValue * 3 * math.pi + particle * 0.5) * 0.8 +
              0.2;

          final particleSize =
              2.0 + math.sin(animationValue * 6 * math.pi + particle) * 1.5;

          final particleColor = system == 0
              ? AppColors.neonCyan
              : system == 1
              ? AppColors.accentColor
              : AppColors.neonYellow;

          paint.color = particleColor.withOpacity(particleOpacity.abs());

          canvas.drawCircle(
            Offset(particleX, particleY),
            particleSize.abs(),
            paint,
          );

          // Add quantum trail
          paint.color = particleColor.withOpacity(particleOpacity.abs() * 0.3);
          canvas.drawCircle(
            Offset(particleX, particleY),
            particleSize.abs() * 3,
            paint,
          );

          // Connect to nearby particles
          for (
            int otherParticle = particle + 1;
            otherParticle < 12;
            otherParticle++
          ) {
            final otherAngle =
                (otherParticle / 12) * 2 * math.pi +
                animationValue * (2 + system * 0.5) * math.pi;
            final otherRadius =
                systemRadius +
                math.sin(animationValue * 4 * math.pi + otherParticle) * 20;

            final otherX = systemCenterX + otherRadius * math.cos(otherAngle);
            final otherY = systemCenterY + otherRadius * math.sin(otherAngle);

            final distance = math.sqrt(
              math.pow(particleX - otherX, 2) + math.pow(particleY - otherY, 2),
            );

            if (distance < 60) {
              paint
                ..style = PaintingStyle.stroke
                ..strokeWidth = 0.5
                ..color = particleColor.withOpacity(
                  (particleOpacity.abs() * (60 - distance) / 60) * 0.5,
                );

              canvas.drawLine(
                Offset(particleX, particleY),
                Offset(otherX, otherY),
                paint,
              );

              paint.style = PaintingStyle.fill;
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(QuantumParticlePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Custom Painter for Holographic Interface
class HolographicInterfacePainter extends CustomPainter {
  final double animationValue;

  HolographicInterfacePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Animated data readouts
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final readoutProgress = (animationValue + i * 0.25) % 1.0;
      final readoutOpacity =
          math.sin(readoutProgress * math.pi * 2) * 0.5 + 0.5;

      paint.color = AppColors.neonYellow.withOpacity(
        readoutOpacity.abs() * 0.8,
      );

      final readoutX = size.width * 0.05 + i * size.width * 0.2;
      final readoutY = size.height * 0.95;

      canvas.drawRect(Rect.fromLTWH(readoutX, readoutY - 4, 40, 8), paint);
    }
  }

  @override
  bool shouldRepaint(HolographicInterfacePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
