import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Service {
  final baseUrl = dotenv.env['API_URL'];

  Future<Object> login(Object data) async {
    final url = Uri.parse('$baseUrl/user/login');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(data);
    final response = await http.post(url, headers: headers, body: body);
    //print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Login failed');
    }

    return json.decode(response.body);
  }
}
