
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {
  // ignore: prefer_typing_uninitialized_variables
  late var pref;
  Future<void> getAppSharedPreference() async {
    pref = await SharedPreferences.getInstance();
  }

  void saveString(String key, String value) async {
    await pref.setString(key, value);
  }

  String? getString(String key) {
    return pref.getString(key);
  }

  void saveBool(String key, bool value) async {
    await pref.setBool(key, value);
  }

  bool? getBool(String key) {
    return pref.getBool(key);
  }

  void saveDouble(String key, double value) async {
    await pref.setDouble(key, value);
  }

  double? getDouble(String key) {
    return pref.getDouble(key);
  }

  void saveInt(String key, int value) async {
    await pref.setInt(key, value);
  }

  int? getInt(String key) {
    return pref.getInt(key);
  }

  void saveListString(String key, List<String> value) async {
    await pref.setStringList(key, value);
  }

  List<String>? getListString(String key) {
    return pref.getStringList(key);
  }

  void deleteData(String key) async {
    await pref.remove(key);
  }
}