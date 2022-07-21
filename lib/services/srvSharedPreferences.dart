import 'package:shared_preferences/shared_preferences.dart';

class srvSharedPreferences {
  static void writeString({String? key, required String value}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString(key!, value);
  }

  static Future<String> readString({required String key}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getString(key) ?? "";
  }
}
