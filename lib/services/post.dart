import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
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
      return response;
    }
    return json.decode(response.body);
  }

  Future<void> addPost(Object post, File? image) async {
    final url = Uri.parse('$baseUrl');

    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode(post);
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Add Posts failed');
    }

    final postId = json.decode(response.body);
    if (image != null) {
      final picUrl = Uri.parse('$baseUrl/image/$postId');

      final imageRequest = http.MultipartRequest('POST', picUrl);

      imageRequest.files.add(await http.MultipartFile.fromPath(
          'image', image.path,
          contentType: MediaType('image', 'jpeg')));
      print(imageRequest.files[0].filename);
      print(imageRequest.files[0].contentType);
      final imageResponse = await imageRequest.send();

      if (imageResponse.statusCode != 200) {
        print('Add Image failed');
      }
    }
  }

  Future<void> deletePost(String postId) async {
    final url = Uri.parse('$baseUrl/$postId');

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Delete Post failed');
    }
  }

  Future<void> editPost(Object post, String postId) async {
    final url = Uri.parse('$baseUrl/$postId');

    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode(post);
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Patch Post failed');
    }
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
