import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>> getRequest({
    required String url,
    Map<String, String>? headers
}) async {
    try {
      final defaultHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      final response = await http.get(
        Uri.parse(url),
        headers: defaultHeaders
      );

      if (response.statusCode >=200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Erreur lors de la requête GET. Code: ${response.statusCode}, Message: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erreur lors de la requête GET : $e');
    }
  }

  Future<Map<String, dynamic>> postRequest({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final defaultHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      final jsonBody = jsonEncode(body);

      final response = await http.post(
        Uri.parse(url),
        headers: defaultHeaders,
        body: jsonBody,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Erreur lors de la requête POST. Code: ${response.statusCode}, Message: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erreur lors de la requête POST : $e');
    }
  }
}
