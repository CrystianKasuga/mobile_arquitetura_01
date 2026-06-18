import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/failure.dart';

class AppHttpClient {
  Future<Map<String, dynamic>> getMap(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Failure('Erro ao carregar dados: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Failure('Credenciais inválidas. Verifique usuário e senha.');
    }
  }
}
