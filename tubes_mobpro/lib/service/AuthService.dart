import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_mobpro/service/ApiService.dart';

class AuthService {
  final ApiService api = ApiService(baseUrl: 'https://ecopulse.top/api');

  Future<void> login(String email, String password) async {
    final response = await api.request(
      endpoint: '/auth/login',
      method: 'POST',
      body: {
        'email': email,
        'password': password,
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', response['access_token']);
  }

  Future<void> me() async {
    final response = await api.request(
      endpoint: '/auth/me',
      method: 'GET',
    );

    if(response['statusCode'] == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(response['body']));
    }else{
      throw Exception('Failed to get user data');
    }
  }

  Future<void> register(String email, String password, String name) async {
    await api.request(
      endpoint: '/auth/register',
      method: 'POST',
      body: {
        'email': email,
        'password': password,
        'name': name,
      },
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('access_token');
  }
}