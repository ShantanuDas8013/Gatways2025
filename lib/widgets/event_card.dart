import 'package:flutter/material.dart';
import 'package:gateways_app/core/app_colors.dart';
import 'package:gateways_app/models/event_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.primaryColor.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.neonCyan, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display event image
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accentColor),
              ),
              child: event.imagePath.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        event.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                        alignment: const Alignment(
                          0.0,
                          -0.8,
                        ), // Shift image much further up to show the header/top part clearly
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.neonCyan.withOpacity(0.5),
                              size: 50,
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.image,
                        color: AppColors.neonCyan.withOpacity(0.5),
                        size: 50,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Image.asset(
                  _getEventIcon(event.title),
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  color: AppColors.neonCyan,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.psychology,
                      color: AppColors.neonCyan,
                      size: 28,
                    );
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonYellow,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: const TextStyle(fontSize: 16, color: AppColors.white),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  final registrationUrl = _getRegistrationUrl(event.title);
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
                      // Show error message if URL launch fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Could not open registration form: $e'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  } else {
                    // Show message if no registration URL is available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Registration not available for this event',
                        ),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonCyan,
                  foregroundColor: AppColors.primaryColor,
                  shadowColor: AppColors.neonCyan,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Register Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
