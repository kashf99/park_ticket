import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _keyEmail = 'user_email';
  static const String _keyPhone = 'user_phone';

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
}
