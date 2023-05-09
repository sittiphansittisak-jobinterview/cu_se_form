import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSetting {
  static late final SharedPreferences db;

  static Future<bool> clear() async {
    return await db.clear();
  }
}
