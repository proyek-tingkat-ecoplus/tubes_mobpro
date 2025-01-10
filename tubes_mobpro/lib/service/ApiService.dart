import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  // Helper function to get the token
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, dynamic>> request({
    required String endpoint,
    required String method,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    File? image, // Optional image parameter for file uploads
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    // Default headers
    headers ??= {
      'Accept': 'application/json',
    };

    // Add Bearer token to headers if it exists
    final token = await _getAuthToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      late http.Response response;

      if (image != null) {
        // Handle file upload with multipart/form-data
        var request = http.MultipartRequest(method, uri);
        request.headers.addAll(headers);

        // Add the body fields (excluding image)
        body?.forEach((key, value) {
          if (value is String) {
            request.fields[key] = value;
          } else if (value is int) {
            request.fields[key] = value.toString();
          }
        });

        // Add image if provided
        var imageFile = await http.MultipartFile.fromPath(
          'avatar', // The field name in the API
          image.path,
          contentType: MediaType('image', 'jpeg'), // Adjust MIME type if needed
        );
        request.files.add(imageFile);

        // Send the request and get the response
        response = await request.send().then((res) => http.Response.fromStream(res));
      } else {
        // Handle regular JSON requests (if no image is provided)
        switch (method.toUpperCase()) {
          case 'GET':
            response = await http.get(uri, headers: headers);
            break;
          case 'POST':
            response = await http.post(uri, headers: headers, body: jsonEncode(body));
            break;
          case 'PUT':
            response = await http.put(uri, headers: headers, body: jsonEncode(body));
            break;
          case 'PATCH':
            response = await http.patch(uri, headers: headers, body: jsonEncode(body));
            break;
          case 'DELETE':
            response = await http.delete(uri, headers: headers);
            break;
          default:
            throw Exception('Invalid HTTP method: $method');
        }
      }

      // Handle token expiration
      if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      }

      // Return response body and status code as a map
      return {
        'statusCode': response.statusCode,
        'body': response.statusCode >= 200 && response.statusCode < 300
            ? jsonDecode(response.body)
            : response.body,
      };
    } catch (e) {
      // Handle any errors that occur during the request
      rethrow;
    }
  }
}
