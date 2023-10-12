import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CommentService {
  final baseUrl = '${dotenv.env['API_URL']}/comment';

  Future<Object> getComments(String postID) async {
    final url = Uri.parse('$baseUrl/$postID');

    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Get Comments failed');
    }
    return json.decode(response.body);
  }

  Future<void> addComment(Object comment) async {
    final url = Uri.parse('$baseUrl');

    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode(comment);
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Post Comments failed');
    }
  }
}
