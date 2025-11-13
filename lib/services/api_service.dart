import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart'; // ✅ added import for environment switching

class ApiService {
  // 🌐 BASE URLs
  // For LOCAL development (when running Django locally)
  // static const String baseUrl = 'http://127.0.0.1:8000/api';

  // For PRODUCTION (when using deployed backend on Render)
  // static const String baseUrl = 'https://gym-app-be.onrender.com/api';

  // ✅ Updated: Dynamic base URL (switches automatically)
  static final String baseUrl = ApiConfig.baseUrl;

  // 🔹 LOGIN API
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login/'); // ✅ same as Postman
    print('🔹 Sending POST to: $url');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      print('🔹 Response status: ${response.statusCode}');
      print('🔹 Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login failed (${response.statusCode})');
      }
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  // 🔹 CALCULATE NUTRITION API
  static Future<Map<String, dynamic>> calculateNutrition(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/calculate-nutrition/"), // ✅ matches Django endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    print('🔹 Request URL: $baseUrl/calculate-nutrition/');
    print('🔹 Request Body: $data');
    print('🔹 Response Status: ${response.statusCode}');
    print('🔹 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to calculate nutrition (${response.statusCode})');
    }
  }
}
