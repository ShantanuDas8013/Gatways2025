import 'package:flutter/material.dart';
import 'package:gateways_app/core/app_colors.dart';
import 'package:gateways_app/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

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
            // Placeholder for an image
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accentColor),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  color: AppColors.neonCyan.withOpacity(0.5),
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.neonYellow,
              ),
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
                onPressed: () {},
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
