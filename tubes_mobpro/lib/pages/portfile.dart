import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/PersetujuanPages.dart';
import 'package:tubes_webpro/pages/PersonalDetailPages.dart';
import 'package:tubes_webpro/pages/dashboard.dart';
import 'package:tubes_webpro/pages/help.dart';
import 'package:tubes_webpro/pages/page_1.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              _buildHeader(),
              SizedBox(height: 20),
              _buildProfileImage(),
              SizedBox(height: 10),
              _buildProfileName(),
              SizedBox(height: 10),
              _buildBadge(),
              SizedBox(height: 20),
              _buildOptionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      'Profil',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Color.fromRGBO(38, 66, 22, 10), width: 5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          'https://i.pinimg.com/originals/b5/bf/99/b5bf993ab5c801b56c52d02387788947.jpg',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileName() {
    return Text(
      'Asep Supriadi',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildBadge() {
    return Badge(
      label: Text("Staff sdm"),
      backgroundColor: Color.fromRGBO(206, 231, 195, 10),
      textColor: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    );
  }

  Widget _buildOptionsList() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        width: 480,
        height: 444,
        color: Color.fromRGBO(38, 66, 22, 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              _buildSectionTitle("General"),
              _buildOptionButton(
                icon: Icons.person,
                title: 'Info personal',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Personaldetailpages()),
                  );
                },
              ),
              _buildOptionButton(
                icon: Icons.help_outline,
                title: 'Bantuan',
                onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()),
                  );
                },
              ),
              _buildOptionButton(
                icon: Icons.logout,
                title: 'Keluar',
                titleColor: Colors.red,
                iconColor: Colors.red,
                onPressed: () {
                  // Add your onPressed code here
                },
              ),
              _buildSectionTitle("Aksi Akun"),
              _buildOptionButton(
                icon: Icons.message,
                title: 'Kata Santdi',
                onPressed: () {
                  // Add your onPressed code here
                },
              ),
              _buildOptionButton(
                icon: Icons.check_circle,
                title: 'Persetujuan',
                  onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Persetujuanpages()),
                  );
                },
              ),
              _buildOptionButton(
                icon: Icons.delete,
                title: 'Tutup Akun',
                titleColor: Colors.red,
                iconColor: Colors.red,
                   onPressed: () {
                  // Add your onPressed code here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String title,
    Color titleColor = Colors.white,
    Color iconColor = Colors.black,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
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
              borderRadius: BorderRadius.circular(15),
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
              title,
              style: TextStyle(color: titleColor, fontSize: 20),
            ),
          ),
          Icon(
            Icons.arrow_forward,
            color: titleColor,
            size: 30,
          ),
        ],
      ),
    );
  }
}