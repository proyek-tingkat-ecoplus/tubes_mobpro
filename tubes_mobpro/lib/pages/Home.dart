import 'dart:convert';
import 'dashboard.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tubes_mobpro/pages/Forum.dart';
import 'package:tubes_mobpro/pages/PemetaaanMap.dart';
import 'package:tubes_mobpro/pages/portfile.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  Home({super.key});

  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class _HomeState extends State<Home> {
  String _username = "Guest"; // Default username placeholder
  String _image = "https://i.imgur.com/pu4BpSa.png";
  @override
  void initState() {
    super.initState();
    _loadData(); // Load the username on initialization
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        _username = userMap['username'];
        _image = 'https://ecopulse.top/'+ userMap['photo'];
      });
    }
  }

  Future<void> _showNotification(String title, String body) async {
  final ByteData bytes = await rootBundle.load('assets/notification_bell.png');
  final Uint8List list = bytes.buffer.asUint8List();

  final BigPictureStyleInformation bigPictureStyle = await BigPictureStyleInformation(
    ByteArrayAndroidBitmap(list),
    largeIcon: ByteArrayAndroidBitmap(list),
    hideExpandedLargeIcon: true,
  );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'Default notifications channel',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyle,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(
              Icons.eco,
              color: Colors.green,
              size: 32,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Pagi, ${_username}.', // Dynamic username
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Selamat Datang di Ecopulse!',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_rounded),
            tooltip: 'Notifikasi',
            onPressed: () {
              _showNotification(
                  'Judul Notifikasi', 'Ini adalah isi notifikasi');
            },
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Dashboard(selectedIndex: 3),
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(_image),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image banner
              CarouselSlider(
                items: [
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage("https://i.imgur.com/ZbokiCB.jpeg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage("https://i.imgur.com/ZbokiCB.jpeg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage("https://i.imgur.com/ZbokiCB.jpeg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),
              const SizedBox(height: 16),

              // Menu grid
              const Text(
                'Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center, // Memastikan berada di tengah
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 250, // Atur lebar maksimum grid menu
                  ),
                  child: GridView.count(
                    crossAxisCount: 2, // Sesuaikan jumlah kolom dengan isi
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildMenuButton(
                        icon: Icons.chat_bubble_outline,
                        label: 'Forum\nManagement',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Dashboard(
                                  selectedIndex:
                                      2), // Ganti dengan halaman yang sesuai
                            ),
                          );
                        },
                      ),
                      _buildMenuButton(
                        icon: Icons.map_outlined,
                        label: 'Pemetaan\nInfrastruktur',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Dashboard(
                                  selectedIndex:
                                      4), // Ganti dengan halaman yang sesuai
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Calendar
              const Text(
                'Kalender',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TableCalendar(
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color.fromRGBO(38, 66, 22, 10),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String message) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed, // Navigasi akan diatur di sini
      style: OutlinedButton.styleFrom(
        side:
            const BorderSide(color: Color.fromRGBO(38, 66, 22, 10), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color.fromRGBO(38, 66, 22, 10)),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(38, 66, 22, 10),
            ),
          ),
        ],
      ),
    );
  }
}
