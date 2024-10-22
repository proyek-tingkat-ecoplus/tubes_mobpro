import 'package:flutter/material.dart';
import 'package:tubes_webpro/pages/Home.dart';
import 'package:tubes_webpro/pages/dashboard.dart';
import 'package:tubes_webpro/pages/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key, }) : super(key: key);

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
      backgroundColor: Color.fromRGBO(38, 66, 22, 100),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Selamat Datang", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),),
            Center(
              child: Card(
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(16),
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
                          decoration:  InputDecoration(
                            labelText: 'Kata Sandi',
                            prefixIcon: Icon(Icons.lock),
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
            
                        SizedBox(height: 12),
                        
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                              fillColor: MaterialStateProperty.all<Color>(Color.fromRGBO(38, 66, 22, 10)),
                            ),
                            Text('Ingat saya', style: TextStyle(fontSize: 16),),
                          ],
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            // side: BorderSide(color: Colors.white),
                            minimumSize: Size(1000, 40),
                            foregroundColor: Color(Colors.white.value) ,
                            backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) { //  buat validasi form
                              Navigator.pushNamed(context, dashboard.routeName);
                            }
                          },
                          child: Text('Masuk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        ),
                        SizedBox(height: 12,),
                        // divider ---or----
                        const Row(
                          children:  <Widget>[
                            Expanded( // expanted buat ngisi ruang yg kosong
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        SizedBox(height: 12,),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            side: BorderSide(color: Color.fromRGBO(24, 119, 242, 10)),
                            minimumSize: Size(1000, 40),
                            foregroundColor: Color.fromRGBO(24, 119, 242, 10) ,
                            backgroundColor: Color(Colors.white.value),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) { //  buat validasi form
                              //Navigator.pushNamed(context, Home.routeName);
                              
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.g_mobiledata_outlined),
                              Text('Masuk dengan Google', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), ),
                            ],
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            // side: BorderSide(color: Colors.white),
                            minimumSize: Size(1000, 40),
                            foregroundColor: Color(Colors.white.value) ,
                            backgroundColor: Color.fromRGBO(24, 119, 242, 10),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) { //  buat validasi form
                              //Navigator.pushNamed(context, Home.routeName);
                              
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.facebook),
                              SizedBox(width: 10,),
                              Text('Masuk dengan facebook', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                            ],
                          ),
                        ),
                        SizedBox(height: 12,),
                            // divider ---or----
                          const Row(
                          children:  <Widget>[
                            Expanded( // expanted buat ngisi ruang yg kosong
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        SizedBox(height: 12,),
                        Text("Lupa password?", style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10), fontSize: 15, fontWeight: FontWeight.bold),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Belum punya akun?", style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10), fontSize: 15),),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Register.routeName);
                              },
                              child: Text("Buat Akun", style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10), fontSize: 15, fontWeight: FontWeight.bold),),
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
    );
  }
}