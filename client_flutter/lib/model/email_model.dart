import 'package:client_flutter/setting/shared_preferences_setting.dart';

class EmailModel {
  static const _key = 'email';

  static Future<bool> replace(email) async {
    if (email is! String) return false;
    return await SharedPreferencesSetting.db.setString(_key, email);
  }

  static Future<String?> find() async {
    return SharedPreferencesSetting.db.getString(_key);
  }
}
