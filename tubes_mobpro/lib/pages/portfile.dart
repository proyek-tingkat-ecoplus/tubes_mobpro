import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/dashboard.dart';
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
                Text(
                  'Profil',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Color.fromRGBO(38, 66, 22, 10), width: 5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Image.network(
                      'https://i.pinimg.com/originals/b5/bf/99/b5bf993ab5c801b56c52d02387788947.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Asep Supriadi',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Badge(
                  label: Text("Staff sdm"),
                  backgroundColor: Color.fromRGBO(206, 231, 195, 10),
                  textColor: Colors.black,
                  padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                ),
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: 480,
                    height: 445,
                    color: Color.fromRGBO(38, 66, 22, 10), // Updated color
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
                            child: Text(
                              "General",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Page_1()),
                                );
                            },
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
                                    Icons.person,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Info personal',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: () {
                              // Add your onPressed code here
                            },
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
                                    Icons.help_outline,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Bantuan',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets .all(0),
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: () {
                              // Add your onPressed code here
                            },
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
                                    Icons.logout,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Keluar',
                                    style: TextStyle(color: Colors.red, fontSize: 20),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 5, bottom: 5),
                            child: Text(
                              "Aksi Akun",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: () {
                              // Add your onPressed code here
                            },
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
                                    Icons.message,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'kata santdi',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: () {
                              // Add your onPressed code here
                            },
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
                                    Icons.check_circle,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'persetujuan',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              alignment: Alignment.centerLeft,
                            ),
                            onPressed: () {
                              // Add your onPressed code here
                            },
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
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Tutup akun',
                                    style: TextStyle(color: Colors.red, fontSize: 20),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}