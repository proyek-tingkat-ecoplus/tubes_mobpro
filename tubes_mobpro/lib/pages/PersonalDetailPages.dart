import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/Home.dart';
import 'package:tubes_webpro/pages/portfile.dart';

class Personaldetailpages extends StatefulWidget {
  const Personaldetailpages({super.key});

  static const routeName = '/personalDetail';

  @override
  State<Personaldetailpages> createState() => _PersonaldetailpagesState();
}

class _PersonaldetailpagesState extends State<Personaldetailpages> {
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
                      title: 'Personal Details',
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Expanded(
                // ngambil page yang free
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
                              'General',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(38, 66, 22, 10)),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 20),
                            InputWidget(
                              label: 'Nama Lengkap',
                              controller: TextEditingController(),
                              obscureText: false,
                              icon: Icons.person,
                            ),
                            SizedBox(height: 20),
                            InputWidget(
                              label: 'Email',
                              controller: TextEditingController(),
                              obscureText: false,
                              icon: Icons.email,
                            ),
                            SizedBox(height: 20),
                            InputWidget(
                              label: 'Tanggal lahir',
                              controller: TextEditingController(),
                              obscureText: false,
                              icon: Icons.calendar_month,
                            ),
                            SizedBox(height: 20),
                            InputWidget(
                              label: 'Nomer telepone',
                              controller: TextEditingController(),
                              obscureText: false,
                              icon: Icons.phone,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Alamat',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(38, 66, 22, 10)),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 20),
                            InputWidget(
                              label: 'Kantor Cabang',
                              controller: TextEditingController(),
                              obscureText: false,
                              icon: Icons.map,
                            ),
                            SizedBox(height: 20),
                            InputWidget(
                              label: 'Alamat Lengkap',
                              controller: TextEditingController(),
                              obscureText: false,
                              icon: Icons.add_location_rounded,
                            ),
                            SizedBox(height: 20),
                            InputWidget(
                              label: 'Kode pos',
                              controller: TextEditingController(),
                              obscureText: false,
                              icon: Icons.card_giftcard_outlined,
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                // side: BorderSide(color: Colors.white),
                                minimumSize: Size(1000, 40),
                                foregroundColor: Color(Colors.white.value),
                                backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                              ),
                              onPressed: () {
                                    Navigator.pop(context);
                              },
                              child: Text(
                                'Masuk',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}

Widget InputWidget({
  required String label,
  // required String hint,
  required TextEditingController controller,
  bool obscureText = false,
  required IconData icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
          hintText: label,
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ],
  );
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
