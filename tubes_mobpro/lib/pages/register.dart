import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tubes_mobpro/compoennt/SplashScreen.dart';
import 'package:tubes_mobpro/pages/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static const routeName = '/register';

  @override
  State<Register> createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  
  // Error states for each field
  Map<String, String> errors = {};

  Future<void> _Register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    const String url = "https://ecopulse.top/api/register";

    try {
      Map<String, String> payload = {
        "username": usernameController.text,
        "email": emailController.text,
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
        "role": "1",
        "nik": nikController.text,
        "phone": phoneController.text
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const Splashscreen(Pages: Login()),
          ),
        );
      } else if (response.statusCode == 422 && responseData['errors'] != null) {
        // Handle Laravel validation errors
        setState(() {
          errors = Map<String, String>.from(
            responseData['errors'].map((key, value) => 
              MapEntry(key, (value as List).first.toString())
            )
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    const Text(
                      "Selamat Datang",
                      style: TextStyle(
                        color: Color.fromRGBO(38, 66, 22, 10),
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        border: const OutlineInputBorder(),
                        errorText: errors['username'],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        if (value.length < 8) {
                          return 'Username must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: const OutlineInputBorder(),
                        errorText: errors['email'],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nikController,
                      decoration: InputDecoration(
                        hintText: 'NIK',
                        border: const OutlineInputBorder(),
                        errorText: errors['nik'],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIK is required';
                        }
                        if (value.length < 16) {
                          return 'NIK must be 16 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        hintText: 'Nama Depan',
                        border: const OutlineInputBorder(),
                        errorText: errors['first_name'],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Nama Belakang',
                        border: const OutlineInputBorder(),
                        errorText: errors['last_name'],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        border: const OutlineInputBorder(),
                        errorText: errors['phone'],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        if (value.length < 10) {
                          return 'Phone number must be at least 10 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Kata Sandi',
                        border: const OutlineInputBorder(),
                        errorText: errors['password'],
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Tulis Ulang Kata Sandi',
                        border: const OutlineInputBorder(),
                        errorText: errors['password_confirmation'],
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(1000, 50),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isLoading ? null : _Register,
                      child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah Punya Akun?",
                          style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10)),
                        ),
                        TextButton(onPressed: (){
                          Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (_) => const Splashscreen(Pages: Login(),)),
                          );
                        }, child: const Text("Masuk di sini", style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(38, 66, 22, 10), fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}