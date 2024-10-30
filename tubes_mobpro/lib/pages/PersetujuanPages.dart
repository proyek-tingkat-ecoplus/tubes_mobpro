import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/dashboard.dart';
import 'package:tubes_webpro/pages/portfile.dart';

class Persetujuanpages extends StatefulWidget {
  const Persetujuanpages({super.key});

  static const routeName = '/persetujuan-pages';

  @override
  State<Persetujuanpages> createState() => _PersetujuanpagesState();
}

class _PersetujuanpagesState extends State<Persetujuanpages> {
  bool _isAgreed = false; // Track agreement to the rules

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 66, 22, 10),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 150,
              child: Center(
                child: _buildOptionButton(
                  icon: Icons.arrow_back,
                  title: 'Persetujuan Aplikasi',
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
                  padding: EdgeInsets.all(25),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Aturan Persetujuan Aplikasi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(38, 66, 22, 10),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        _buildRuleItem(
                            "1. Lengkapi semua dokumen yang diperlukan."),
                        _buildRuleItem(
                            "2. Pastikan semua informasi yang diberikan adalah benar."),
                        _buildRuleItem(
                            "3. Setujui syarat dan ketentuan yang berlaku."),
                        _buildRuleItem(
                            "4. Kirim aplikasi sebelum tenggat waktu."),
                        SizedBox(height: 20),
                        Text(
                          'Saya telah membaca dan memahami aturan di atas.',
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isAgreed,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isAgreed = value ?? false;
                                });
                              },
                            ),
                            Text('Setuju'),
                          ],
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed:
                              _isAgreed // jika udh di celist munjulin button
                                  ? () {
                                      // Handle submission of agreement
                                      _showSubmissionDialog(context);
                                    }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              'Kirim Persetujuan',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              rule,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubmissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin mengirim persetujuan?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //  Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => Dashboard(selectedIndex: 2)),
                //   );
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Handle submission logic here
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Persetujuan telah dikirim!')),
                );
              },
              child: Text(' Kirim'),
            ),
          ],
        );
      },
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
