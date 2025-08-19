import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: const Center(
        child: Text(
          'This is the Welcome Screen!',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
