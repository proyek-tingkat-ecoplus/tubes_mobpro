import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tubes_webpro/compoennt/SplashScreen.dart';
import 'package:tubes_webpro/pages/dashboard.dart';
import 'package:tubes_webpro/pages/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onIntroEnd() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Splashscreen(Pages: Login(),)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 3;
            });
          },
          children: [
            buildOnboardingPage(
              title: 'Selamat Datang',
              subtitle: 'Temukan solusi inovatif untuk membantu Anda dalam mengelola energi terbarukan secara efisien.',
            ),
            buildOnboardingPage(
              title: 'Pemetaan Terintegrasi',
              subtitle: 'Visualisasikan data dan analisis dengan mudah untuk pengelolaan energi yang lebih baik.',
            ),
            buildOnboardingPage(
              title: 'Forum Kolaboratif',
              subtitle: 'Diskusi dan kolaborasi dengan para ahli untuk menemukan solusi energi yang berkelanjutan.',
            ),
            buildOnboardingPage(
  title: 'Siap Memulai?',
  subtitle: 'Bergabunglah dengan kami dan mulai perjalanan Anda dalam mengelola energi terbarukan dengan lebih baik. Bersama, kita wujudkan solusi berkelanjutan untuk masa depan.',
),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onIntroEnd,
                    child: const Text('Lewati', style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10))),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _onIntroEnd,
                    child: const Text('Mulai', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _onIntroEnd,
                    child: const Text('Lewati', style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10))),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: Color.fromRGBO(38, 66, 22, 10),
                      ),
                      onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text('Berikutnya', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildOnboardingPage({
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: const Color.fromRGBO(38, 66, 22, 10),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
