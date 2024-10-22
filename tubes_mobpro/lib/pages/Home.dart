import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/login.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Latar belakang putih
        elevation: 0, // Menghilangkan bayangan AppBar
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
        title: Row(
          children: [
            Icon(
              Icons.eco, // Ikon pohon (atau Anda bisa mengganti dengan custom icon)
              color: Colors.green, // Warna hijau sesuai tema lingkungan
              size: 32,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Pagi, Asep.', // Teks sambutan
                  style: TextStyle(
                    color: Colors.black, // Warna teks hitam
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Selamat Datang di Ecopulse!',
                  style: TextStyle(
                    color: Colors.black54, // Warna teks abu-abu
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            IconButton(
            icon: const Icon(Icons.notifications_active_sharp, color: Color.fromRGBO(0, 48, 48, 10),),
            tooltip: 'Notifikasi',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/profile.jpg'), // URL gambar profil
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Center(
         
          ),
        ),
      );
  }
}