import 'package:flutter/material.dart';
import 'package:gateways_app/screens/splash_screen.dart';
import 'package:gateways_app/screens/welcome_screen.dart';
import 'package:gateways_app/screens/events_screen.dart';
import 'package:gateways_app/screens/about_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set the initial screen to be the splash screen
      initialRoute: '/',
      // You can also define routes for easier navigation
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/events': (context) => const EventsScreen(),
        '/about': (context) => const AboutScreen(),
      },
    );
  }
}
