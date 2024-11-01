import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/Forum.dart';
import 'package:tubes_webpro/pages/Home.dart';
import 'package:tubes_webpro/pages/PemetaaanMap.dart';
import 'package:tubes_webpro/pages/portfile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, this.selectedIndex = 0});
  final int selectedIndex; // Change to final
  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int _selectedIndex; // Declare without initialization
  late PageController _pageController; // Declare without initialization

  final List<Color> _backgroundColors = [
    Colors.white, // Home color
    Colors.white, // File color
    Colors.white, // Forum color
    const Color.fromRGBO(38, 66, 22, 10), // ProfilePage color
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Access the selectedIndex from the widget
    _pageController = PageController(initialPage: _selectedIndex); // Initialize PageController
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the PageController
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Update PageView to reflect the selected index
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: _backgroundColors[_selectedIndex], // Dynamic background color
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              Home(),
              PemetaaanMap(),
              ForumPage(),
              ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 1,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 30),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder, size: 30),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.forum, size: 30),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings, size: 30),
                  label: '',
                ),
              ],
              backgroundColor: Colors.white,
              currentIndex: _selectedIndex,
              selectedItemColor: const Color.fromRGBO(38, 66, 22, 10),
              unselectedItemColor: Colors.black,
              onTap: _onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }
}