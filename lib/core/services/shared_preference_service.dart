import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static const String _appVersionKey = 'app_version';
  static const String _accessTokenKey = 'access_token';
  static const String _lastUpdatedKey = 'last_updated';
  static const String _userDataKey = 'user_data';

  Future<void> saveData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data.containsKey('app_version')) {
      await prefs.setString(_appVersionKey, data['app_version']);
    }
    if (data.containsKey('access_token')) {
      await prefs.setString(_accessTokenKey, data['access_token']);
    }
    if (data.containsKey('last_updated')) {
      await prefs.setString(_lastUpdatedKey, data['last_updated']);
    }
    if (data.containsKey('user_data')) {
      await prefs.setString(_userDataKey, jsonEncode(data['user_data']));
    }
  }

  Future<String?> getAppVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_appVersionKey);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getLastUpdated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastUpdatedKey);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }
}
