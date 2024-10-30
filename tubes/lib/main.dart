import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(20),
          title: Center(
            child: Text(
              'Keluar dari akun?',
              style: TextStyle(
                color: Color.fromRGBO(38, 66, 22, 10),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            'Apakah Anda yakin untuk keluar akun?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add your logout functionality here
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'keluar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('tidak', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(20),
          title: Center(
            child: Text(
              'Hapus Akun?',
              style: TextStyle(
                color: Color.fromRGBO(38, 66, 22, 10),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            'Apakah Anda yakin untuk menghapus akun Anda?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add your delete account functionality here
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'ya, hapus akun Saya',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('tidak', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Profil"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(38, 66, 22, 10),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/originals/b5/bf/99/b5bf993ab5c801b56c52d02387788947.jpg'),
            ),
            SizedBox(height: 10),
            Text(
              'Asep Supriadi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color.fromRGBO(206, 231, 195, 10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Staff ESDM',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(38, 66, 22, 10),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Text(
                      'General',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ProfileOption(
                      icon: Icons.person,
                      color: Colors.black,
                      text: 'Info Personal',
                      onPressed: () {
                        // Add navigation to Info Personal page
                      },
                    ),
                    ProfileOption(
                      icon: Icons.help_outline,
                      color: Colors.black,
                      text: 'Bantuan',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BantuanPage()),
                        );
                      },
                    ),
                    ProfileOption(
                      icon: Icons.logout,
                      color: Colors.red,
                      text: 'Keluar',
                      onPressed: _showLogoutDialog,
                      textColor: Colors.red,
                      iconColor: Colors.red,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Aksi Akun',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ProfileOption(
                      icon: Icons.lock,
                      color: Colors.black,
                      text: 'Kata Sandi',
                      onPressed: () {
                        // Add password action
                      },
                    ),
                    ProfileOption(
                      icon: Icons.check_circle,
                      color: Colors.black,
                      text: 'Persetujuan',
                      onPressed: () {
                        // Add approval action
                      },
                    ),
                    ProfileOption(
                      icon: Icons.delete,
                      color: Colors.red,
                      text: 'Hapus Akun',
                      onPressed: _showDeleteAccountDialog,
                      textColor: Colors.red,
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(38, 66, 22, 10),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color iconColor;

  ProfileOption({
    required this.icon,
    required this.color,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 25,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 18),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: textColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class BantuanPage extends StatelessWidget {
  const BantuanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(38, 66, 22, 10),
        title: Text("Bantuan", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kenapa bumi itu bulat?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(38, 66, 22, 10),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. '
                'Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, '
                'mattis ligula consectetur, ultrices mauris.',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
