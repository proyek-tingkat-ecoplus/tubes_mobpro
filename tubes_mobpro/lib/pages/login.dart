import 'package:flutter/material.dart';
import 'package:tubes_mobpro/compoennt/SplashScreen.dart';
import 'package:tubes_mobpro/pages/dashboard.dart';
import 'package:tubes_mobpro/pages/register.dart';
import 'package:tubes_mobpro/compoennt/CostomTextButton.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static const routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // ini buat validasi fprm
  final _formKey = GlobalKey<FormState>();
  // ini buat controller form input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // state varibles
  bool isChecked = false;
  bool _isObscured = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkIfLogin();
    _checkBiometric();
    _getAvailableBiometrics();
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
          MaterialPageRoute(
              builder: (_) => const Splashscreen(Pages: Dashboard())),
        );
      }
    }
  }

  // fungsi untuk cek biometric
  Future<void> _checkBiometric() async {
    try {
      bool canCheckBiometric = await _localAuth.isDeviceSupported();
      setState(() {
        _canCheckBiometric = canCheckBiometric;
      });
    } catch (e) {
      print("Error checking biometrics: $e");
    }
  }

  // fungsi untuk mendapatkan biometric yang tersedia
  Future<void> _getAvailableBiometrics() async {
    try {
      List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();
      setState(() {
        _availableBiometrics = availableBiometrics;
      });
      print("Biometrik yang tersedia: $_availableBiometrics");
    } catch (e) {
      print("Gagal mendapatkan biometrik: $e");
    }
  }

  // fungsi untuk autentikasi dengan biometric jadi tinggal _authenticateWithBiometrics() aja kalau sudah ada nanti di arahkan ke login
  Future<void> _authenticateWithBiometrics() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Gunakan sidik jari untuk login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // jadi ga cuman biometric aja bisa
        ),
      );

      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        final storedEmail = prefs.getString('stored_email');
        final storedPassword = prefs.getString('stored_password');

        if (storedEmail != null && storedPassword != null) {
          _usernameController.text = storedEmail;
          _passwordController.text = storedPassword;
          await _login();
        } else {
          setState(() {
            _passwordError = 'Silakan login secara manual terlebih dahulu';
          });
        }
      }
    } on PlatformException catch (e) {
      print(e.message);
      setState(() {
        _passwordError = 'Autentikasi gagal: ${e.message}';
      });
    }
  }

  Future<void> _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _isLoading = true;
    });

    String email = _usernameController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _emailError = email.isEmpty ? 'Email tidak boleh kosong' : null;
        _passwordError =
            password.isEmpty ? 'Password tidak boleh kosong' : null;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://ecopulse.top/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', responseData['access_token']);
        await prefs.setString('token_type', responseData['token_type']);
        await prefs.setString('expires_at', responseData['expires_at']);
        await prefs.setString('user', jsonEncode(responseData['user']));
        await prefs.setString('stored_email', email);
        await prefs.setString('stored_password', password);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => const Splashscreen(Pages: Dashboard())),
        );
      } else {
        setState(() {
          _passwordError = 'Login gagal. Periksa kembali email dan password.';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _passwordError = 'Tidak dapat terhubung ke server';
      });
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
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Selamat Datang di Ecopulse",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Masuk untuk Melanjutkan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
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
                                icon: Icon(_isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () =>
                                    setState(() => _isObscured = !_isObscured),
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
                                backgroundColor:
                                    const Color.fromRGBO(38, 66, 22, 1),
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
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const _OrDivider(),
                          const SizedBox(height: 12),
                          if (_canCheckBiometric &&
                              _availableBiometrics.isNotEmpty)
                            _costomButton(
                              text: 'Masuk dengan Biometric',
                              backgroundColor:
                                  const Color.fromRGBO(38, 66, 22, 1),
                              foregroundColor: Colors.white,
                              onPressed: _authenticateWithBiometrics,
                              icon: Icons.fingerprint,
                            ),
                          TextButton(
                            onPressed: () async {
                              const url = 'https://ecopulse.top/forgetPassword';
                              final Uri uri = Uri.parse(url);

                              if (!await launchUrl(uri,
                                  mode: LaunchMode.externalApplication)) {
                                print('Gagal membuka URL');
                              }
                            },
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
                                    MaterialPageRoute(
                                        builder: (_) => const Splashscreen(
                                              Pages: Register(),
                                            )),
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

  Widget _costomButton({
    required String text,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: Colors.white,
              ),
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
