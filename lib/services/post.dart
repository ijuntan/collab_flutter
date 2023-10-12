import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'storage.dart';

class PostService {
  final baseUrl = '${dotenv.env['API_URL']}/post';
  List<String> action = ["Like", "Dislike", "None"];

  Future<dynamic> getPost(int skipLength) async {
    final url = Uri.parse('$baseUrl/posts').replace(
        queryParameters: {
      'skip': skipLength,
    }.map((key, value) => MapEntry(key, value.toString())));

    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Get Posts failed');
    }
    return json.decode(response.body);
  }

  Future<dynamic> getActions(String uid) async {
    final url = Uri.parse('$baseUrl/action/$uid');

    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Get Actions failed');
    }
    return json.decode(response.body);
  }

  Future<void> actionPost(
      String action, String beforeAction, String postId) async {
    final url = Uri.parse('$baseUrl/action');
    final headers = {
      'Content-Type': 'application/json',
    };
    final userId = await storage.readStorage("_id");
    final body = json.encode({
      'act': action,
      'beforeAct': beforeAction,
      'postID': postId,
      'userID': userId,
    });
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Action Post failed');
    }
  }
}
