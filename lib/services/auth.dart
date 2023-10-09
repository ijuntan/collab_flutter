import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../services/storage.dart';

class Auth with ChangeNotifier {
  bool _isAuth = false;

  bool get isAuth {
    return _isAuth;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  void login(token) {
    final payload = _decodeBase64(token['token'].split('.')[1]);
    final payloadMap = json.decode(payload);
    payloadMap.forEach(
        (key, value) => storage.writeStorage(key.toString(), value.toString()));
    _isAuth = true;
    notifyListeners();
  }

  logout() async {
    storage.clearStorage();
    _isAuth = false;
    notifyListeners();
  }

  void readStorage(String key) async {
    final token = await storage.readStorage(key);
    _isAuth = (token != null);
    notifyListeners();
  }
}
