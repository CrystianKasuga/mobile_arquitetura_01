import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyToken = 'session_token';
  static const _keyUsername = 'session_username';
  static const _keyFirstName = 'session_firstName';

  Future<void> saveSession({
    required String token,
    required String username,
    required String firstName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyFirstName, firstName);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFirstName);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyFirstName);
  }
}
