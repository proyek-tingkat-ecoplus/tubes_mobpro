import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, Login.routeName);
            },
            child: const Text('Go to Page 1'),
          ),
        ),
      ),
    );
  }
}