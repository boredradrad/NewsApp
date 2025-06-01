import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {

  static final PreferencesManager _instance = PreferencesManager._internal();

  factory PreferencesManager() {
    return _instance;
  }

  PreferencesManager._internal();

  late final SharedPreferences _preferences;

  init() async {
    _preferences = await SharedPreferences.getInstance();
  }


  //Setters
  Future<bool> setString(String key, String value) async {
      return await _preferences.setString(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  //getters
  String? getString(String key)  {
    return _preferences.getString(key);
  }

  double? getDouble(String key)  {
    return _preferences.getDouble(key);
  }
  int? getInt(String key)  {
    return _preferences.getInt(key);
  }
  bool? getBool(String key)  {
    return _preferences.getBool(key);
  }
  List<String>? getStringList(String key)  {
    return _preferences.getStringList(key);
  }

  remove(String key) async {
    await _preferences.remove(key);
  }

  clear() async {
    await _preferences.clear();
  }

}