import 'package:flutter/material.dart';
import 'package:gateways_app/core/app_colors.dart';
import 'package:gateways_app/models/event_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCard extends StatefulWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isHovered = false;

  // Helper method to get the registration URL for each event
  String _getRegistrationUrl(String title) {
    switch (title.toLowerCase()) {
      case 'ui/ux':
        return 'https://docs.google.com/forms/d/e/1FAIpQLSdqpWlO2C0FvdSCTclxFf-srvLcYmOgcRUmGOwmoglje6Dumw/viewform?usp=preview';
      case 'gaming':
        return 'https://docs.google.com/forms/d/e/1FAIpQLSfyB7QF3NiGntCbwS9NuwFkuOowpQD5ua8O7gLMm9P9DKBsQA/viewform?usp=preview';
      case 'capture the flag':
        return 'https://docs.google.com/forms/d/e/1FAIpQLSeIe8xuyiuHX91Pd47LeBKyhx-nnVLajbwGNMvZj9gYr67J3Q/viewform?usp=preview';
      case 'iot':
        return 'https://docs.google.com/forms/d/e/1FAIpQLScAQp5yBglJoSYRMyq08DGGBza0bnMDapW-cPYHvBkTFkpgvQ/viewform?usp=preview';
      case 'it manager':
        return 'https://docs.google.com/forms/d/e/1FAIpQLSdHhPyVRvWhZb1wVgK2R9WRrgGaeolejhpMUX2LTxFQA3neLw/viewform?usp=preview';
      case 'photography':
        return 'https://docs.google.com/forms/d/e/1FAIpQLSf42OTsZQLs6L7p3i8YH8UISFB3XdGGuE7gCPGBf_WJKMN-dw/viewform?usp=preview';
      case 'hackathon':
        return 'https://docs.google.com/forms/d/e/1FAIpQLSdGUjXDgPYveLpugqvyJG7hRVc1DIOCgBD3Bl849M0Y-UJsBA/viewform?usp=preview';
      case 'coding & debugging':
        return 'https://docs.google.com/forms/d/e/1FAIpQLSfbT2cFXqfEKed-ES53lBO6mt7X-Gi5cSVGdeG8QJuwrgryhQ/viewform?usp=preview';
      case 'treasure hunt':
        return 'https://docs.google.com/forms/d/e/1FAIpQLSeIlGT9TOXseXXNebd5BFLbX8GUQKYSws5qd1ELOe3-me-gMg/viewform?usp=preview';
      case 'it quiz':
        return 'https://docs.google.com/forms/d/e/1FAIpQLSeZLwu-k7LukkTX9dGRzbbWpUEkMWg6zdREblvR8zBkGWJLvA/viewform?usp=preview';
      case 'surprise event':
        return 'https://docs.google.com/forms/d/e/1FAIpQLScBXNpryCJt7v9zEzrErh_HVuWT17gxc7MLUR_ID7VUZG1TOg/viewform?usp=preview';
      default:
        return ''; // No registration URL available
    }
  }

  // Helper method to get the appropriate icon for each event
  String _getEventIcon(String title) {
    switch (title.toLowerCase()) {
      case 'it quiz':
        return 'assets/icons/brain.png';
      case 'it manager':
        return 'assets/icons/manager.png';
      case 'surprise event':
        return 'assets/icons/surprise.png';
      case 'treasure hunt':
        return 'assets/icons/treasure.png';
      case 'gaming':
        return 'assets/icons/gaming.png';
      case 'photography':
        return 'assets/icons/photography.png';
      case 'iot':
        return 'assets/icons/IOT.png';
      case 'capture the flag':
        return 'assets/icons/cybersecurity.png';
      case 'coding & debugging':
        return 'assets/icons/coding.png';
      case 'ui/ux':
        return 'assets/icons/ui.png';
      case 'hackathon':
        return 'assets/icons/hackathon.png';
      default:
        return 'assets/icons/brain.png'; // Default fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor.withOpacity(0.9),
              AppColors.primaryColor.withOpacity(0.7),
              Colors.black.withOpacity(0.8),
            ],
          ),
          border: Border.all(
            color: AppColors.neonCyan.withOpacity(0.7),
            width: _isHovered ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonCyan.withOpacity(0.2),
              blurRadius: _isHovered ? 15 : 8,
              spreadRadius: _isHovered ? 2 : 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background grid pattern
            Positioned.fill(
              child: CustomPaint(painter: GridPainter(opacity: 0.05)),
            ),
            // Corner accent elements
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.neonCyan.withOpacity(0.6),
                      AppColors.accentColor.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentColor.withOpacity(0.6),
                      AppColors.neonCyan.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event image with cyberpunk overlay
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.neonYellow.withOpacity(0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonYellow.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: widget.event.imagePath.isNotEmpty
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.matrix([
                                    1.2, 0, 0.2, 0, 0, // Red
                                    0, 1.1, 0.3, 0, 0, // Green
                                    0.1, 0.2, 1.3, 0, 0, // Blue
                                    0, 0, 0, 1, 0, // Alpha
                                  ]),
                                  child: Image.asset(
                                    widget.event.imagePath,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 180,
                                    alignment: const Alignment(0.0, -0.8),
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildErrorIcon();
                                    },
                                  ),
                                )
                              : _buildErrorIcon(),
                        ),
                        // Cyberpunk overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.neonCyan.withOpacity(0.1),
                                AppColors.primaryColor.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        // Scan lines effect
                        Positioned.fill(
                          child: CustomPaint(
                            painter: ScanLinesPainter(opacity: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title section with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.neonCyan.withOpacity(0.8),
                              AppColors.neonCyan.withOpacity(0.3),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonCyan.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          _getEventIcon(widget.event.title),
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                          color: AppColors.primaryColor,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.psychology,
                              color: AppColors.primaryColor,
                              size: 32,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  AppColors.neonYellow,
                                  AppColors.neonCyan,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                widget.event.title.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            Container(
                              height: 2,
                              width: 100,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.neonCyan.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description with cyberpunk styling
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.accentColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.event.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                        height: 1.4,
                        shadows: [
                          Shadow(
                            color: AppColors.neonCyan.withOpacity(0.3),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Register button with enhanced cyberpunk styling
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: _isHovered
                              ? [AppColors.neonCyan, AppColors.accentColor]
                              : [
                                  AppColors.neonCyan.withOpacity(0.8),
                                  AppColors.neonCyan.withOpacity(0.6),
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isHovered
                                ? AppColors.neonCyan.withOpacity(0.6)
                                : AppColors.neonCyan.withOpacity(0.3),
                            blurRadius: _isHovered ? 20 : 10,
                            spreadRadius: _isHovered ? 3 : 1,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _handleRegistration(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColors.primaryColor,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flash_on, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'REGISTER NOW',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.8),
            Colors.black.withOpacity(0.9),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: AppColors.neonCyan.withOpacity(0.5),
          size: 60,
        ),
      ),
    );
  }

  Future<void> _handleRegistration() async {
    final registrationUrl = _getRegistrationUrl(widget.event.title);
    if (registrationUrl.isNotEmpty) {
      try {
        final url = Uri.parse(registrationUrl);
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
          ),
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open registration form: $e'),
              backgroundColor: AppColors.accentColor,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration not available for this event'),
            backgroundColor: AppColors.neonYellow,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}

// Custom painter for grid pattern background
class GridPainter extends CustomPainter {
  final double opacity;

  GridPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonCyan.withOpacity(opacity)
      ..strokeWidth = 0.5;

    const gridSize = 20.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for scan lines effect
class ScanLinesPainter extends CustomPainter {
  final double opacity;

  ScanLinesPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.neonCyan.withOpacity(opacity)
      ..strokeWidth = 1.0;

    const lineSpacing = 4.0;

    // Draw horizontal scan lines
    for (double y = 0; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
