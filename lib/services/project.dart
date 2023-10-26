import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'storage.dart';

class ProjectService {
  final baseUrl = '${dotenv.env['API_URL']}/project';

  Future<dynamic> getProject(uid) async {
    final url = Uri.parse('$baseUrl/projects/$uid');

    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);
    //print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Get Projects failed');
    }
    return json.decode(response.body);
  }

  Future<void> addProject(Object project) async {
    final url = Uri.parse('$baseUrl');

    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode(project);
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Add Project failed');
    }
  }

  Future<void> deleteProject(String projectId) async {
    final url = Uri.parse('$baseUrl/$projectId');

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Delete Project failed');
    }
  }

  Future<void> editProject(Object project, String projectId) async {
    final url = Uri.parse('$baseUrl/$projectId');

    final headers = {
      'Content-Type': 'application/json',
    };
    final body = json.encode(project);
    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Patch Project failed');
    }
  }
}
