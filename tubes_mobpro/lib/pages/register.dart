import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tubes_webpro/compoennt/SplashScreen.dart';
import 'package:tubes_webpro/pages/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static const routeName = '/register';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  Future<void> _Register() async {
    const String url = "https://ecopulse.top/api/register";

    try{
      Map<String,String> payload = {
        "username" : usernameController.text,
        "email" : emailController.text,
        "first_name" : firstNameController.text,
        "last_name" : lastNameController.text,
        "password" : passwordController.text,
        "confirm_password" : confirmPasswordController.text,
      };

    final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: jsonEncode(payload),
      );

      if(response.statusCode == 200){
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(child: 
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: Column( mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                    const SizedBox(height: 80,),
                const Text("Selamat Datang", style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10), fontWeight: FontWeight.bold, fontSize: 30),),
                const SizedBox(height: 20,),
                TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your usename',
                  border: OutlineInputBorder(
                  )
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  hintText: 'Nama Depan',
                  border: OutlineInputBorder(
                  )
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  hintText: 'Nama Belakang',
                  border: OutlineInputBorder(
                  )
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                  )
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if(passwordController.text != confirmPasswordController.text){
                    return 'Password not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Kata Sandi',
                  border: OutlineInputBorder(
                  )
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if(passwordController.text != confirmPasswordController.text){
                    return 'Password not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Tulis Ulang Kata Sandi',
                  border: OutlineInputBorder(
                  )
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
                TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(1000, 50), 
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)),),
                  backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                  foregroundColor: Color (Colors.white.value), 
                  ),
                onPressed: () {
                  _Register();
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
               ),
               const SizedBox(height: 10,),
               const Row(
                  children:  <Widget>[
                    Expanded( // expanted buat ngisi ruang yg kosong
                          child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                 const SizedBox(height: 12,),
                          TextButton(
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              minimumSize: const Size(1000, 40),
                              foregroundColor: Color(Colors.white.value),
                              backgroundColor: const Color.fromRGBO(250, 31, 12, 10),
                            ),
                            onPressed: () {
                        
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.g_mobiledata_outlined),
                                Text('Masuk dengan Google', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                              ],
                            ),
                          ),
                const SizedBox(height: 10,),
                TextButton(
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              // side: BorderSide(color: Colors.white),
                              minimumSize: const Size(1000, 40),
                              foregroundColor: Color(Colors.white.value) ,
                              backgroundColor: const Color.fromRGBO(24, 119, 242, 10),
                            ),
                            onPressed: () {
                              
        
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.facebook),
                                SizedBox(width: 10,),
                                Text('Masuk dengan facebook', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                              ],
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
                      Navigator.pushNamed(context, '/login');
                    }, child: const Text("Masuk di sini", style: TextStyle(decoration: TextDecoration.underline, color: Color.fromRGBO(38, 66, 22, 10), fontWeight: FontWeight.bold),)),
                  ],
                )
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}
