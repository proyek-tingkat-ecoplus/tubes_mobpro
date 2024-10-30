import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/Home.dart';
import 'package:tubes_webpro/pages/dashboard.dart';
import 'package:tubes_webpro/pages/register.dart';
import 'package:tubes_webpro/compoennt/CostomTextButton.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  static const routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  bool isChecked = false;
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Selamat Datang",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
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
                            decoration: InputDecoration(
                              labelText: 'Kata Sandi',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscured =
                                          !_isObscured; // Toggle obscure text
                                    });
                                  },
                                  icon: Icon(_isObscured
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
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
                                fillColor: WidgetStateProperty.all<Color>(
                                    const Color.fromRGBO(38, 66, 22, 10)),
                              ),
                              const Text(
                                'Ingat saya',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              // side: BorderSide(color: Colors.white),
                              minimumSize: const Size(1000, 40),
                              foregroundColor: Color(Colors.white.value),
                              backgroundColor:
                                  const Color.fromRGBO(38, 66, 22, 10),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //  buat validasi form
                                Navigator.pushNamed(
                                    context, Dashboard.routeName);
                              }
                            },
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          // divider ---or----
                          const Row(
                            children: <Widget>[
                              Expanded(
                                // expanted buat ngisi ruang yg kosong
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
                          const SizedBox(
                            height: 12,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              side: const BorderSide(
                                  color: Color.fromRGBO(24, 119, 242, 10)),
                              minimumSize: const Size(1000, 40),
                              foregroundColor:
                                  const Color.fromRGBO(24, 119, 242, 10),
                              backgroundColor: Color(Colors.white.value),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                //  buat validasi form
                                //Navigator.pushNamed(context, Home.routeName);
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.g_mobiledata_outlined),
                                Text(
                                  'Masuk dengan Google',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          CustomTextButton(
                            // Named argument
                            onPressed: () {
                              print("Button Pressed");
                            },
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              // side: BorderSide(color: Colors.white),
                              minimumSize: const Size(1000, 40),
                              foregroundColor: Color(Colors.white.value),
                              backgroundColor:
                                  const Color.fromRGBO(24, 119, 242, 10),
                            ), // Named argument
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.facebook),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Masuk dengan facebook',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          // divider ---or----
                          const Row(
                            children: <Widget>[
                              Expanded(
                                // expanted buat ngisi ruang yg kosong
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
                              //bottom
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            "Lupa password?",
                            style: TextStyle(
                                color: Color.fromRGBO(38, 66, 22, 10),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Belum punya akun?",
                                style: TextStyle(
                                    color: Color.fromRGBO(38, 66, 22, 10),
                                    fontSize: 15),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Register.routeName);
                                },
                                child: const Text(
                                  "Buat Akun",
                                  style: TextStyle(
                                      color: Color.fromRGBO(38, 66, 22, 10),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
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
    );
  }
}
