import 'package:flutter/material.dart';
import 'help_detail.dart';

class HelpPage extends StatelessWidget {
  final List<Map<String, String>> faqData = [
    {
      "question": "Apa itu EcoPulse Mobile?",
      "answer": "EcoPulse Mobile adalah aplikasi berbasis smartphone yang dirancang untuk mendukung pengajuan proposal pengembangan infrastruktur energi bersih oleh kepala desa. Aplikasi ini juga menyediakan platform forum diskusi, memungkinkan kepala desa, admin, dan pengguna lain untuk berbagi informasi dan pengalaman terkait proyek energi terbarukan. Dengan EcoPulse Mobile, pengguna dapat mengakses semua fitur dengan mudah dan cepat, di mana pun mereka berada."
    },
    {
      "question": "Siapa yang dapat menggunakan EcoPulse Mobile?",
      "answer": "EcoPulse Mobile dirancang untuk digunakan oleh berbagai pengguna, termasuk kepala desa yang ingin mengajukan proposal, admin yang bertugas mengelola dan meninjau proposal, serta tamu yang ingin mengakses informasi tentang proyek-proyek energi bersih. Setiap jenis pengguna memiliki akses yang disesuaikan dengan peran mereka dalam aplikasi, memastikan pengalaman pengguna yang optimal."
    },
    {
      "question": "Bagaimana cara mengajukan proposal melalui EcoPulse Mobile?",
      "answer": "Untuk mengajukan proposal melalui EcoPulse Mobile, kepala desa perlu melakukan langkah-langkah berikut: Registrasi dan Login: Pertama, pengguna harus mendaftar dan membuat akun di aplikasi. Setelah itu, mereka dapat masuk menggunakan kredensial yang telah dibuat"
      "Mengisi Formulir Proposal: Setelah login, pengguna dapat mengakses bagian pengajuan proposal dan mengisi formulir yang tersedia. Informasi yang diperlukan termasuk deskripsi proyek, tujuan, dan estimasi biaya."
      "Mengunggah Dokumen: Pengguna dapat mengunggah dokumen pendukung yang diperlukan, seperti rencana anggaran dan gambar proyek."
      "Mengirim Proposal: Setelah semua informasi diisi dan dokumen diunggah, pengguna dapat mengirim proposal. Proposal akan diterima oleh admin untuk ditinjau dan diproses lebih lanjut."
    },
    {
      "question": "Apakah ada biaya untuk menggunakan EcoPulse Mobile?",
      "answer": "Penggunaan EcoPulse Mobile sepenuhnya gratis bagi semua pengguna. Namun, biaya mungkin muncul terkait dengan proyek yang diusulkan, seperti biaya konstruksi atau operasional yang ditanggung oleh pihak terkait. Aplikasi ini bertujuan untuk mempermudah akses dan partisipasi dalam pengembangan infrastruktur energi bersih tanpa adanya biaya akses aplikasi."
    },
    {
      "question": "Bagaimana cara mengetahui status proposal yang diajukan?",
      "answer": "Pengguna dapat mengetahui status proposal mereka dengan cara:"
      "Notifikasi dalam Aplikasi: Setelah mengajukan proposal, pengguna akan menerima notifikasi di aplikasi tentang status proposal mereka, termasuk apakah proposal diterima, ditolak, atau membutuhkan revisi."
      "Lihat Riwayat Proposal: Pengguna dapat mengakses riwayat proposal di bagian profil mereka untuk melihat semua proposal yang telah diajukan beserta status masing-masing."
    },
    {
      "question": "Apa fitur utama yang ditawarkan oleh EcoPulse Mobile?",
      "answer": "EcoPulse Mobile dilengkapi dengan berbagai fitur utama yang mendukung pengguna, antara lain:"
      "Pengajuan Proposal: Memudahkan kepala desa dalam mengajukan proposal proyek energi bersih secara langsung melalui aplikasi."
      "Forum Diskusi: Menyediakan platform bagi pengguna untuk berdiskusi, berbagi pengalaman, dan bertanya seputar proyek energi terbarukan."
      "Manajemen Proposal: Admin dapat meninjau, mengelola, dan memberikan konfirmasi terhadap proposal yang diajukan, semuanya dapat dilakukan melalui antarmuka yang intuitif."
      "Integrasi Google Maps: Memungkinkan pengguna untuk menandai lokasi proyek infrastruktur energi yang diusulkan, sehingga memberikan gambaran yang jelas tentang distribusi proyek di wilayah tersebut."
    }
  ];

  HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 66, 22, 1), // Latar hijau
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: _buildOptionButton(
                  icon: Icons.arrow_back,
                  title: 'Bantuan',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded( 
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: Colors.white, 
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      itemCount: faqData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: ListTile(
                            title: Text(
                              faqData[index]['question'] ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(38, 66, 22, 1),
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward,
                              color: Color.fromRGBO(38, 66, 22, 1),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HelpDetailPage(
                                    question: faqData[index]['question'] ?? '',
                                    answer: faqData[index]['answer'] ?? '',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  Widget _buildOptionButton({
    required IconData icon,
    required String title,
    Color titleColor = Colors.white,
    Color iconColor = Colors.white,
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
        SizedBox(width: 20),
        Icon(
          icon, // Use the provided icon parameter
          color: iconColor, // Use the iconColor parameter
          size: 30,
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: titleColor, fontSize: 20),
            ),
          ),
        ),
        SizedBox(width: 30), // Optional spacing on the right
      ],
    ),
  );
}