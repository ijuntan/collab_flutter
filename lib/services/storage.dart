import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  void clearStorage() async {
    await storage.deleteAll();
  }

  Future<String?> readStorage(String key) async {
    try {
      return await storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  void writeStorage(key, value) async {
    //print(key);
    //print(value);
    await storage.write(key: key, value: value);
  }
}

Storage storage = Storage();
