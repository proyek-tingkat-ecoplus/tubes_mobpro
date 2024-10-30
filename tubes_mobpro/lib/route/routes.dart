import 'package:flutter/material.dart';
import 'package:tubes_webpro/compoennt/SplashScreen.dart';
import 'package:tubes_webpro/pages/Home.dart';
import 'package:tubes_webpro/pages/PersonalDetailPages.dart';
import 'package:tubes_webpro/pages/login.dart';
import 'package:tubes_webpro/pages/page_1.dart';
import 'package:tubes_webpro/pages/portfile.dart';
import 'package:tubes_webpro/pages/register.dart';
import 'package:tubes_webpro/pages/dashboard.dart';

class Routes extends StatelessWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context) => const Splashscreen(),
        Home.routeName: (context) => const Home(),
        Page_1.routeName: (context) => const Page_1(),
        Login.routeName: (context) => const Login(),
        Register.routeName: (context) => const Register(),
        Dashboard.routeName: (context) =>  Dashboard(),
      
        Personaldetailpages.routeName: (context) => const Personaldetailpages(),
          ProfilePage.routeName: (context) => const ProfilePage(),
      },
           onGenerateRoute: (RouteSettings settings) {
        // Handle dynamic routes or undefined routes here if needed
        return MaterialPageRoute(builder: (context) => const Splashscreen()); // Default route
      },
      // Optional: Handle unknown routes
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => const Splashscreen()); // Default route
      },
    );
  }
}