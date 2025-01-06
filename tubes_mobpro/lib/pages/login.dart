import 'package:flutter/material.dart';
import 'package:tubes_mobpro/compoennt/SplashScreen.dart';
import 'package:tubes_mobpro/pages/dashboard.dart';
import 'package:tubes_mobpro/pages/register.dart';
import 'package:tubes_mobpro/compoennt/CostomTextButton.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static const routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isChecked = false;
  bool _isObscured = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _checkIfLogin();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkIfLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('access_token') != null) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Splashscreen(Pages: Dashboard())),
        );
      }
    }
  }

  Future<void> _login() async {
    // Reset errors
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    String email = _usernameController.text.trim();
    String password = _passwordController.text;

    bool hasError = false;

    // Client-side validation
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email tidak boleh kosong';
      });
      hasError = true;
    } else {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        setState(() {
          _emailError = 'Format email tidak valid';
        });
        hasError = true;
      }
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password tidak boleh kosong';
      });
      hasError = true;
    } else if (password.length < 6) {
      setState(() {
        _passwordError = 'Password minimal 6 karakter';
      });
      hasError = true;
    }

    if (hasError) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://ecopulse.top/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', responseData['access_token']);
        await prefs.setString('token_type', responseData['token_type']);
        await prefs.setString('expires_at', responseData['expires_at']);
        await prefs.setString('user', jsonEncode(responseData['user']));

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Splashscreen(Pages: Dashboard())),
        );
      } else {
        if (response.statusCode == 422 && responseData['errors'] != null) {
          Map<String, dynamic> errors = responseData['errors'];
          setState(() {
            if (errors['email'] != null) {
              _emailError = errors['email'][0];
            }
            if (errors['password'] != null) {
              _passwordError = errors['password'][0];
            }
          });
        } else if (response.statusCode == 401) {
          setState(() {
            _passwordError = 'Email atau password salah';
          });
        } else {
          setState(() {
            _passwordError = responseData['message'] ?? 'Terjadi kesalahan saat login';
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _passwordError = 'Tidak dapat terhubung ke server';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Selamat Datang",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
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
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              errorText: _emailError,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(38, 66, 22, 1),
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              if (_emailError != null) {
                                setState(() => _emailError = null);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              errorText: _passwordError,
                              suffixIcon: IconButton(
                                icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                                onPressed: () => setState(() => _isObscured = !_isObscured),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(38, 66, 22, 1),
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),
                            obscureText: _isObscured,
                            onChanged: (value) {
                              if (_passwordError != null) {
                                setState(() => _passwordError = null);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() => isChecked = value!);
                                },
                                fillColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(38, 66, 22, 1),
                                ),
                              ),
                              const Text(
                                'Ingat saya',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(38, 66, 22, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _isLoading ? null : _login,
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
                                      'Masuk',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const _OrDivider(),
                          const SizedBox(height: 12),
                          _buildSocialLoginButton(
                            text: 'Masuk dengan Google',
                            icon: Icons.g_mobiledata_outlined,
                            onPressed: () {},
                            isGoogle: true,
                          ),
                          const SizedBox(height: 8),
                          _buildSocialLoginButton(
                            text: 'Masuk dengan Facebook',
                            icon: Icons.facebook,
                            onPressed: () {},
                            isGoogle: false,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Lupa password?",
                              style: TextStyle(
                                color: Color.fromRGBO(38, 66, 22, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Belum punya akun?",
                                style: TextStyle(
                                  color: Color.fromRGBO(38, 66, 22, 1),
                                  fontSize: 15,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (_) => const Splashscreen(Pages: Register(),)),
                                    );
                                },
                                child: const Text(
                                  "Buat Akun",
                                  style: TextStyle(
                                    color: Color.fromRGBO(38, 66, 22, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isGoogle,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: isGoogle ? Colors.white : const Color.fromRGBO(24, 119, 242, 1),
          foregroundColor: isGoogle ? const Color.fromRGBO(24, 119, 242, 1) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isGoogle
                ? const BorderSide(color: Color.fromRGBO(24, 119, 242, 1))
                : BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('ATAU', style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider(thickness: 1)),
      ],
    );
  }
}