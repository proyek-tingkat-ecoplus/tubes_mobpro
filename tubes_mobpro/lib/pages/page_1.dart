import 'package:flutter/material.dart';
import 'package:tubes_mobpro/pages/Home.dart';

class Page_1 extends StatelessWidget {
  const Page_1({super.key});

  static const routeName = '/page_1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is Page 1'),
            const SizedBox(height: 20), // Espace entre le texte et le bouton
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Home.routeName);
              },
              child: const Text('Click Me'),
            ),
          ],
        ),
      ),
    );
  }
}
