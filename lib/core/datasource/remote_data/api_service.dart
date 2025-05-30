import 'dart:convert';

import 'package:http/http.dart' as http;

import 'base_api_service.dart';

class ApiService implements BaseApiService {
  final http.Client _client;

  ApiService() : _client = http.Client();

  @override
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _client.get(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  @override
  Future<dynamic> post(String url, {Map<String, String>? headers, dynamic body}) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  @override
  Future<dynamic> put(String url, {Map<String, String>? headers, dynamic body}) async {
    try {
      final response = await _client.put(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  @override
  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _client.delete(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  void dispose() {
    _client.close();
  }
}
