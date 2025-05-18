import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefs;
  static const _keyUserName = 'username';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getUserName() => _prefs.getString(_keyUserName);

  static Future setUserName(String name) async =>
      await _prefs.setString(_keyUserName, name);
}
