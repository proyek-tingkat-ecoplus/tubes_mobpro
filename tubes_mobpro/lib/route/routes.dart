import 'package:flutter/material.dart';
import 'package:tubes_mobpro/compoennt/SplashScreen.dart';
import 'package:tubes_mobpro/compoennt/onBoarding.dart';
import 'package:tubes_mobpro/pages/Home.dart';
import 'package:tubes_mobpro/pages/PersonalDetailPages.dart';
import 'package:tubes_mobpro/pages/login.dart';
import 'package:tubes_mobpro/pages/page_1.dart';
import 'package:tubes_mobpro/pages/portfile.dart';
import 'package:tubes_mobpro/pages/register.dart';
import 'package:tubes_mobpro/pages/dashboard.dart';

class Routes extends StatelessWidget {
  const Routes({super.key, required this.showOnboarding});
  final bool showOnboarding;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context) => showOnboarding ? const Splashscreen(Pages: OnboardingScreen() ,) : const Splashscreen(Pages: Login(),) ,
        Home.routeName: (context) =>  Home(),
        Page_1.routeName: (context) => const Page_1(),
        Login.routeName: (context) => const Login(),
        Register.routeName: (context) =>  Register(),
        Dashboard.routeName: (context) =>  Dashboard(),
      
        Personaldetailpages.routeName: (context) => const Personaldetailpages(),
          ProfilePage.routeName: (context) => const ProfilePage(),
      },
          onGenerateRoute: (RouteSettings settings) {
        // Handle dynamic routes or undefined routes here if needed
        return MaterialPageRoute(builder: (context) => const Splashscreen(Pages: Login(),)); // Default route
      },
      // Optional: Handle unknown routes
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => const Splashscreen(Pages: Login(),)); // Default route
      },
    );
  }
}

