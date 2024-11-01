import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tubes_webpro/pages/login.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      print("Navigating to login screen");
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop, // This defines the transition effect
          duration: const Duration(milliseconds: 1000),
          reverseDuration: const Duration(milliseconds: 1000),
          child: const Login(), // The destination widget
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 66, 22, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const Icon(Icons.eco, size: 100, color: Colors.white)
                    .animate()
                    .rotate(duration: 2.seconds) // ini buat muter logo
                    .scaleXY(begin: 0.8, end: 1.5, curve: Curves.easeInCirc, duration: 1.5.seconds), // ini buat animasi logo

            const SizedBox(height: 20),

            // Text with a combination of fade, scale, and color animations
            const Text(
              "EchoPluse",
              style: TextStyle(
                color: Color.fromRGBO(38, 66, 22, 100),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(duration: 1.5.seconds)
            .scaleXY(begin: 0.5, end: 1.0, curve: Curves.easeInOut, duration: 1.seconds)
            .then() // Color transition effect
            .tint(color: Colors.white, duration: 1.seconds)
          ],
        ),
      ),
    );
  }
}
