import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:tubes_webpro/pages/login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Latar belakang putih
        elevation: 0, // Menghilangkan bayangan AppBar
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
        title: const Row(
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
          ],  
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_rounded),
            tooltip: 'Notifikasi',
            onPressed: () {
              showDialog(
                context: context,
                 builder: (context) => AlertDialog(
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, 
                    child: const Text('Tutup')
                    )
                  ],
                  title: Text('Notifikasi'),
                  content: Container(
                    height: 300,
                    width: 300,
                    
                    child: ListView(
                      children: [
                        Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                            )
                          ),
                          child: Center(
                            child: Text(
                              'Selamat! Proposal anda diterima',
                              style: TextStyle(color: Colors.white)
                            )
                          )
                        ),
                        SizedBox(height: 5,),
                        Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                            )
                          ),
                          child: Center(
                            child: Text(
                              'Selamat! Proposal anda diterima',
                              style: TextStyle(color: Colors.white)
                            )
                          )
                        ) 
                      ],
                    ),
                  ),
                 )
              );
            }, 
          ),
          SizedBox(width: 16),
          CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/profile.jpg'), // URL gambar profil
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
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Pencarian',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),

              // Image banner (example)
              Container(
                  child: Center(
                    child: Image.asset('assets/banner.jpeg')
                  ),
              ),
              const SizedBox(height: 16),

              // Menu grid
              const Text(
                'Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMenuButton(
                    icon: Icons.person_outline,
                    label: 'Role\nManagement',
                    onPressed: () {
                      print('Role Management clicked');
                    },
                  ),
                  _buildMenuButton(
                    icon: Icons.chat_bubble_outline,
                    label: 'Forum\nManagement',
                    onPressed: () {
                      print('Forum Management clicked');
                    },
                  ),
                  _buildMenuButton(
                    icon: Icons.description_outlined,
                    label: 'Peninjauan\nProposal',
                    onPressed: () {
                      print('Peninjauan Proposal clicked');
                    },
                  ),
                  _buildMenuButton(
                    icon: Icons.map_outlined,
                    label: 'Pemetaan\nInfrastruktur',
                    onPressed: () {
                      print('Pemetaan Infrastruktur clicked');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pending Proposal
              const Text(
                'Pending Proposal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: const Row(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
  
// Function to build menu item
   Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color.fromRGBO(38, 66, 22, 10), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Color.fromRGBO(38, 66, 22, 10)),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(38, 66, 22, 10),
            ),
          ),
        ],
      ),
    );
  }