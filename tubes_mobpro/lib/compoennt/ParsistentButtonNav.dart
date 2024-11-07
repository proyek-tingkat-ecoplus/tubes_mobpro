import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart'; // Untuk CupertinoIcons
import 'package:tubes_webpro/pages/dashboard.dart'; // Pastikan import sudah benar

class PersistentButtonNav extends StatefulWidget {
  const PersistentButtonNav({super.key});

  static const routeName = '/persistentButtonNav';

  @override
  _PersistentButtonNavState createState() => _PersistentButtonNavState();
}

class _PersistentButtonNavState extends State<PersistentButtonNav> {
  late PersistentTabController _controller;

  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    // Menyediakan dua layar, sesuai dengan dua item di nav bar
    return [
      const Dashboard(), // Layar pertama
      Container(), // Layar kedua (dummy atau halaman settings)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        scrollController: _scrollController1,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            "/first": (context) => const Dashboard(),
            "/second": (context) => const Dashboard(),
          },
        ),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        scrollController: _scrollController2,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: "/",
          routes: {
            "/first": (context) => const Dashboard(),
            "/second": (context) => const Dashboard(),
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      //popBehaviorOnSelectedNavBarItemPress: PopActionScreensType.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.grey.shade900,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style1, // Pilih gaya nav bar yang sesuai
    );
  }
}
