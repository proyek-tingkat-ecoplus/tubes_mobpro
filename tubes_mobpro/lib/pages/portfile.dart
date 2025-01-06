import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_mobpro/compoennt/SplashScreen.dart';
import 'package:tubes_mobpro/pages/PersetujuanPages.dart';
import 'package:tubes_mobpro/pages/PersonalDetailPages.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_mobpro/pages/help.dart';
import 'package:tubes_mobpro/pages/login.dart';
import 'package:tubes_mobpro/pages/profile_details.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const routeName="/profile";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  String _username = "Guest";
  String _token = "";

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    final getToken = prefs.getString('access_token');
    if (userJson != null) {
    Map<String, dynamic> userMap = jsonDecode(userJson);
    setState(() {
        _username = userMap["username"];
        _token = getToken.toString();
    });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _logout() async {
      const String url = "https://ecopulse.top/api/auth/logout";
    try{
    final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          "Authorization" : "Bearer $_token",
        },
        //body: jsonEncode(payload),
      );

      if(response.statusCode == 200){
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('user');
        prefs.remove('access_token');
        prefs.remove('expires_at');
        prefs.remove('refresh_token');

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Splashscreen(Pages: Login(),)),
        );
      }else{
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? 'Login failed' + response.body)),
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          title: const Center(
            child: Text(
              'Keluar dari akun?',
              style: TextStyle(
                color: Color.fromRGBO(38, 66, 22, 10),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: const Text(
            'Apakah Anda yakin untuk keluar akun?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                        _logout();
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'keluar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('tidak', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          title: const Center(
            child: Text(
              'Hapus Akun?',
              style: TextStyle(
                color: Color.fromRGBO(38, 66, 22, 10),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: const Text(
            'Apakah Anda yakin untuk menghapus akun Anda?',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'ya, hapus akun Saya',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('tidak', style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const ImagePickerWidget(), // Added the ImagePickerWidget here
              const SizedBox(height: 20),
              Text(
                '${_username}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(206, 231, 195, 10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Staff ESDM',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(38, 66, 22, 10),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        const Text(
                          'General',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ProfileOption(
                          icon: Icons.person,
                          color: Colors.black,
                          text: 'Info Personal',
                          onPressed: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PersonalDetails()),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        ProfileOption(
                          icon: Icons.help_outline,
                          color: Colors.black,
                          text: 'Bantuan',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HelpPage()),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        ProfileOption(
                          icon: Icons.logout,
                          color: Colors.red,
                          text: 'Keluar',
                          onPressed: _showLogoutDialog,
                          textColor: Colors.red,
                          iconColor: Colors.red,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Aksi Akun',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ProfileOption(
                          icon: Icons.lock,
                          color: Colors.black,
                          text: 'Kata Sandi',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        ProfileOption(
                          icon: Icons.check_circle,
                          color: Colors.black,
                          text: 'Persetujuan',
                          onPressed: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Persetujuanpages()),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        ProfileOption(
                          icon: Icons.delete,
                          color: Colors.red,
                          text: 'Hapus Akun',
                          onPressed: _showDeleteAccountDialog,
                          textColor: Colors.red,
                          iconColor: Colors.red,
                        ),
                        const SizedBox(height: 10),
                      ],
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

// ImagePickerWidget
class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _captureImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Pilih Sumber Gambar',
            style: TextStyle(
              color: Color.fromRGBO(38, 66, 22, 10),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _captureImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(75),
              border: Border.all(
                color: const Color.fromRGBO(38, 66, 22, 10),
                width: 2,
              ),
            ),
            child: _image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.file(
                      _image!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Color.fromRGBO(38, 66, 22, 10),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _image != null ? 'Ketuk untuk mengubah foto' : 'Ketuk untuk menambah foto',
          style: const TextStyle(
            color: Color.fromRGBO(38, 66, 22, 10),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color iconColor;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 18),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: textColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kata sandi"),
        backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 100,
              color: Color.fromRGBO(38, 66, 22, 10),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ubah Kata Sandi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tambah Kata Sandi',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: 'Kata Sandi',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Kata Sandi Baru',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
        title: const Text("Bantuan", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kenapa bumi itu bulat?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(38, 66, 22, 10),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. '
                'Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, '
                'mattis ligula consectetur, ultrices mauris.',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

