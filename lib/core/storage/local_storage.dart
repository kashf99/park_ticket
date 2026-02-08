import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _keyEmail = 'user_email';
  static const String _keyPhone = 'user_phone';
  static const String _keyAdminToken = 'admin_token';
  static const String _keyAdminName = 'admin_name';
  static const String _keyAdminEmail = 'admin_email';
  static const String _keyAdminRole = 'admin_role';

  Future<void> saveUserContact({
    required String email,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (email.isNotEmpty) {
      await prefs.setString(_keyEmail, email);
    }
    if (phone.isNotEmpty) {
      await prefs.setString(_keyPhone, phone);
    }
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyEmail);
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyPhone);
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  Future<void> saveAdminSession({
    required String token,
    String? name,
    String? email,
    String? role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAdminToken, token);
    if (name != null && name.trim().isNotEmpty) {
      await prefs.setString(_keyAdminName, name);
    }
    if (email != null && email.trim().isNotEmpty) {
      await prefs.setString(_keyAdminEmail, email);
    }
    if (role != null && role.trim().isNotEmpty) {
      await prefs.setString(_keyAdminRole, role);
    }
  }

  Future<void> clearAdminSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAdminToken);
    await prefs.remove(_keyAdminName);
    await prefs.remove(_keyAdminEmail);
    await prefs.remove(_keyAdminRole);
  }

  Future<String?> getAdminToken() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyAdminToken);
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  Future<String?> getAdminName() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyAdminName);
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }

  Future<String?> getAdminRole() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_keyAdminRole);
    if (value == null || value.trim().isEmpty) return null;
    return value;
  }
}
