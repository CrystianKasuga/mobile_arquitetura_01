import 'dart:convert';
import 'package:http/http.dart' as http;

class AppHttpClient {
  Future<List<dynamic>> get(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Erro ao carregar dados: ${response.statusCode}');
    }
  }
}
