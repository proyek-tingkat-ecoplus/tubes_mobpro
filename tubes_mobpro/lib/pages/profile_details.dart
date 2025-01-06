import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
  static const routeName = '/PersonalDetails';
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perubahan disimpan!')),
      );
    }
  }

  void _bottomDatePicker(BuildContext context) {
    BottomPicker.date(
      pickerTitle: Text(
        'Pilih tanggal',
        style: TextStyle(
          color: Color.fromRGBO(38, 66, 22, 1),
          fontSize: 20,
        ),
      ),
      dateOrder: DatePickerDateOrder.dmy,
      pickerTextStyle:
          TextStyle(color: Color.fromRGBO(38, 66, 22, 1), fontSize: 16),
      onChange: (index) {
        DateTime selectedDate = DateTime.parse(index.toString());
        _dateController.text =
            "${selectedDate.day.toString().padLeft(2, '0')}-${(selectedDate.month).toString().padLeft(2, '0')}-${selectedDate.year}";
      },
      bottomPickerTheme: BottomPickerTheme.orange,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 66, 22, 1),
      body: Column(
        children: [
          Container(
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Text(
                    'Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Info Personal',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(38, 66, 22, 1)),
                  ),
                  SizedBox(height: 10),
                  // Form info personal start
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Nama Lengkap
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              prefixIcon: Icon(Icons.person), // Prefix icon
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama Lengkap tidak boleh kosong';
                              }
                              if (value.length < 5) {
                                return 'Nama tidak kurang dari 5 karakter';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          // Email
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.alternate_email),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              String pattern =
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(value)) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          // Tanggal Lahir
                          TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Tanggal Lahir',
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.none,
                            readOnly: true,
                            validator: (value) {
                              // if (value == null || value.isEmpty) {
                              //   return 'Tanggal lahir tidak boleh kosong';
                              // }
                              return null;
                            },
                            onTap: () => _bottomDatePicker(context),
                          ),
                          SizedBox(height: 10),
                          // No Telepon
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nomor Telepon',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor Telepon tidak boleh kosong';
                              }
                              if (value.length != 12) {
                                return 'Nomor Telepon harus berjumlah 12 digit';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          // Form alamat start
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Alamat',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(38, 66, 22, 1)),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Kantor Cabang ESDM
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Kantor Cabang ESDM',
                              prefixIcon: Icon(Icons.map),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kantor Cabang ESDM tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          // Alamat
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Alamat Lengkap',
                              prefixIcon: Icon(Icons.location_on),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          // Alamat
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Kode Pos',
                              prefixIcon: Icon(Icons.local_post_office),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kode Pos tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          // Tombol Simpan
                          TextButton(
                            onPressed: _submitForm,
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromRGBO(38, 66, 22, 1),
                              minimumSize: Size(500, 50),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                            ),
                            child: Text(
                              'Simpan',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
