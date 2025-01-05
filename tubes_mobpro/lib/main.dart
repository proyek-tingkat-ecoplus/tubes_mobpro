import 'package:flutter/material.dart';
import 'package:tubes_webpro/route/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;
  WidgetsFlutterBinding.ensureInitialized();
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      print('Location service is enabled.');
    } else {
      print('Location service is disabled.');
    }
  } catch (e) {
    print('Error initializing Geolocator: $e');
  }
  runApp(Routes(showOnboarding: showOnboarding));
} 


