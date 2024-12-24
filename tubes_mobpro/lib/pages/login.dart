import 'package:flutter/material.dart';
import 'package:tubes_webpro/compoennt/SplashScreen.dart';
import 'package:tubes_webpro/pages/dashboard.dart';
import 'package:tubes_webpro/pages/register.dart';
import 'package:tubes_webpro/compoennt/CostomTextButton.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key, });

  static const routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setOnboarding();
    _checkIfLogin();
  }
  bool isChecked = false; 
  bool _isObscured = true;
  bool _isLoading = false;

  Future<void> _setOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
  }

  Future<void> _checkIfLogin() async{
    SharedPreferences.getInstance().then((prefs) {
      if(prefs.getString('access_token') != null){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Splashscreen(Pages: Dashboard(),)),
        );
      }
    });
  }
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    const String url = 'https://ecopulse.top/api/login';

    try {
      // Prepare request payload
      Map<String, String> payload = {
        'email': _usernameController.text,
        'password': _passwordController.text,
      };

      // Make POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Save data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('access_token', data['access_token']);
        await prefs.setString('token_type', data['token_type']);
        await prefs.setString('expires_at', data['expires_at']);
        await prefs.setString('user', jsonEncode(data['user']));

        // Navigate to dashboard or another page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Splashscreen(Pages: Dashboard(),)),
        );
      } else {
        // Handle error response
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Selamat Datang", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
                  Center(
                    child: Card(
                      margin: const EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _passwordController,
                                decoration:  InputDecoration(
                                  labelText: 'Kata Sandi',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isObscured = !_isObscured; // Toggle obscure text
                                      });
                                    }, 
                                    icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off)),
                                ),
                                obscureText: _isObscured, // buat ****
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(38, 66, 22, 10)),
                                  ),
                                  const Text('Ingat saya', style: TextStyle(fontSize: 16),),
                                ],
                              ),
                              _isLoading
                                  ? CircularProgressIndicator()
                                  : TextButton(
                                      style: TextButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        minimumSize: const Size(1000, 40),
                                        foregroundColor: Color(Colors.white.value) ,
                                        backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                                      ),
                                      onPressed: _login,
                                      child: const Text('Masuk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                    ),
                              const SizedBox(height: 12,),
                              const Row(
                                children:  <Widget>[
                                  Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(color: Colors.grey),
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
                                  side: const BorderSide(color: Color.fromRGBO(24, 119, 242, 10)),
                                  minimumSize: const Size(1000, 40),
                                  foregroundColor: const Color.fromRGBO(24, 119, 242, 10) ,
                                  backgroundColor: Color(Colors.white.value),
                                ),
                                onPressed: () {},
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.g_mobiledata_outlined),
                                    Text('Masuk dengan Google', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                                  ],
                                ),
                              ),
                              CustomTextButton(
                                  onPressed: () {
                                    print("Button Pressed");
                                  }, 
                                  style: TextButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                    minimumSize: const Size(1000, 40),
                                    foregroundColor: Color(Colors.white.value) ,
                                    backgroundColor: const Color.fromRGBO(24, 119, 242, 10),
                                  ), 
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
                              const Row(
                                children:  <Widget>[
                                  Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "OR",
                                      style: TextStyle(color: Colors.grey),
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
                              const Text("Lupa password?", style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10), fontSize: 15, fontWeight: FontWeight.bold),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Belum punya akun?", style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10), fontSize: 15),),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, Register.routeName);
                                    },
                                    child: const Text("Buat Akun", style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10), fontSize: 15, fontWeight: FontWeight.bold),),
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
}


 