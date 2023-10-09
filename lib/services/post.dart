import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PostService {
  final baseUrl = '${dotenv.env['API_URL']}/post';

  Future<Object> getPost(int skipLength) async {
    final url = Uri.parse('$baseUrl/posts').replace(
        queryParameters: {
      'skip': skipLength,
    }.map((key, value) => MapEntry(key, value.toString())));

    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);
    //print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Login failed');
    }
    return json.decode(response.body);
  }
}
