import 'package:flutter/material.dart';
import 'package:tubes_webpro/compoennt/SplashScreen.dart';
import 'package:tubes_webpro/compoennt/onBoarding.dart';
import 'package:tubes_webpro/pages/Home.dart';
import 'package:tubes_webpro/pages/PersonalDetailPages.dart';
import 'package:tubes_webpro/pages/login.dart';
import 'package:tubes_webpro/pages/page_1.dart';
import 'package:tubes_webpro/pages/portfile.dart';
import 'package:tubes_webpro/pages/register.dart';
import 'package:tubes_webpro/pages/dashboard.dart';

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
        Register.routeName: (context) => const Register(),
        Dashboard.routeName: (context) =>  const Dashboard(),
      
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

