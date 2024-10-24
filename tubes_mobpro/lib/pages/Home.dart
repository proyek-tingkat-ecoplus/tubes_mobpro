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
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pencarian',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16),

              // Image banner (example)
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Banner Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Menu grid
              Text(
                'Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
              SizedBox(height: 16),

              // Pending Proposal
              Text(
                'Pending Proposal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pending Proposal',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      '20',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Calendar
              Text(
                'Kalender',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}