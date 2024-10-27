import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/Home.dart';
import 'package:tubes_webpro/pages/portfile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  final List<Color> _backgroundColors = [
    Colors.white, // Home color
    Colors.lightBlueAccent, // File color
    Colors.lightGreenAccent, // Forum color
    Color.fromRGBO(38, 66, 22, 10),  // ProfilePage color
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: _backgroundColors[_selectedIndex], // Dynamic background color
        body: SafeArea(
          child: NoSwipePageView( // Use NoSwipePageView
            controller: _pageController,
            children: [
              Home(),
              Center(
                child: Text(
                  'File',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Center(
                child: Text(
                  'Forum',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
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
              selectedItemColor: Color.fromRGBO(38, 66, 22, 10),
              unselectedItemColor: Colors.black,
              onTap: _onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
        // Uncomment if needed
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.add),
        //   backgroundColor: Color.fromRGBO(38, 66, 22, 10),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class NoSwipePageView extends StatelessWidget {
  final PageController controller;
  final List<Widget> children;

  const NoSwipePageView({
    Key? key,
    required this.controller,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      physics: NeverScrollableScrollPhysics(), // Disables swiping
      itemBuilder: (context, index) {
        return children[index];
      },
      itemCount: children.length,
    );
  }
}