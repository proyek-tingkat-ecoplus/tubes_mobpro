import 'package:flutter/material.dart';
import 'package:tubes_webpro/route/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(Routes(showOnboarding: showOnboarding));
}

