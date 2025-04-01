// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class DataLocalService {
  SharedPreferences? prefs;
  // https://randomkeygen.com/
  static const String _LANGUAGE_KEY = 'vpaSBRhqTLTBWoo8PM14usLTPtFqjXCoXqX2WEqusntf';

  Future<void> saveLanguage(String? value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs?.setString(_LANGUAGE_KEY, value ?? '');
  }

  Future<String?> getLanguage() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs?.getString(_LANGUAGE_KEY);
  }

}
