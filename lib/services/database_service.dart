import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('settings');
  }

  Future<void> saveToken(String token) async {
    final box = Hive.box('settings');
    await box.put('token', token);
  }

  Future <String?> getToken() async {
    final box = Hive.box('settings');
    return box.get('token') as String?;
  }
}