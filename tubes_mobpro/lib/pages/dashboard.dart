import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/Home.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  static const routeName = '/dashboard';
  @override
  State<dashboard> createState() => _dashboardState();
}


class _dashboardState extends State<dashboard> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();


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
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
             Home(
              
             ),
              // Halaman Email
              Center(
                child: Text(
                  'File',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              // Halaman Profile
              Center(
                child: Text(
                  'Forum',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Center(
                child: Text(
                  'Setelan',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
           child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, style: BorderStyle.solid, width: 5),
                borderRadius: BorderRadius.circular(100)
              ),
                child: ClipRRect(
                 borderRadius: BorderRadius.circular(100),
                  child: BottomNavigationBar(
                    unselectedIconTheme: IconThemeData(
                      color: Colors.green,
                    ),
                  items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, size: 30),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.folder),
                    label: ''
                  ),
                   BottomNavigationBarItem(
                    icon: Icon(Icons.forum),
                    label: ''
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: ''
                  ),
                  
                ],
                backgroundColor: Colors.transparent,
                currentIndex: _selectedIndex,
                selectedItemColor: Color.fromRGBO(38, 66, 22, 10),
                onTap: _onItemTapped,
                showSelectedLabels: false,
                showUnselectedLabels: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
