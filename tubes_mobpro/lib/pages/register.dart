import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static const routeName = '/register';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(child: 
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
          child: Column( mainAxisAlignment: MainAxisAlignment.start, 
            children: [
                  const SizedBox(height: 80,),
              const Text("Selamat Datang", style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10), fontWeight: FontWeight.bold, fontSize: 30),),
              const SizedBox(height: 20,),
              TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your email',
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
              decoration: const InputDecoration(
                hintText: 'Email',
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
              decoration: const InputDecoration(
                hintText: 'Kata Sandi',
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
    );
  }
}
