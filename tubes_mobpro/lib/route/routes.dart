import 'package:flutter/material.dart';
import 'package:tubes_webpro/compoennt/SplashScreen.dart';
import 'package:tubes_webpro/pages/Home.dart';
import 'package:tubes_webpro/pages/login.dart';
import 'package:tubes_webpro/pages/page_1.dart';
import 'package:tubes_webpro/pages/portfile.dart';
import 'package:tubes_webpro/pages/register.dart';
import 'package:tubes_webpro/pages/dashboard.dart';
import 'package:tubes_webpro/pages/profile_details.dart';

class Routes extends StatelessWidget {
  const Routes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Splashscreen(),
        Home.routeName: (context) => const Home(),
        Page_1.routeName: (context) => const Page_1(),
        Login.routeName: (context) => const Login(),
        Register.routeName: (context) => const Register(),
        Dashboard.routeName: (context) => const Dashboard(),
        ProfilePage.routeName: (context) => const ProfilePage(),
        PersonalDetails.routeName: (context) => PersonalDetails(),
      },
    );
  }
}
