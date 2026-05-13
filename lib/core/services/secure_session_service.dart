import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSessionService {
  const SecureSessionService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _accessTokenKey = 'cdip_access_token';
  static const String _verifiedTokenKey = 'cdip_verified_token';
  static const String _verifiedPhoneKey = 'cdip_verified_phone';

  static Future<void> saveAccessToken(String token) async {
    if (token.trim().isEmpty) return;
    await _storage.write(key: _accessTokenKey, value: token.trim());
  }

  static Future<String> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey) ?? '';
  }

  static Future<void> saveVerifiedToken({
    required String phone,
    required String verifiedToken,
  }) async {
    if (verifiedToken.trim().isEmpty) return;
    await _storage.write(key: _verifiedTokenKey, value: verifiedToken.trim());
    await _storage.write(key: _verifiedPhoneKey, value: phone.trim());
  }

  static Future<String> getVerifiedToken() async {
    return await _storage.read(key: _verifiedTokenKey) ?? '';
  }

  static Future<String> getVerifiedPhone() async {
    return await _storage.read(key: _verifiedPhoneKey) ?? '';
  }

  static Future<void> clearVerifiedToken() async {
    await _storage.delete(key: _verifiedTokenKey);
    await _storage.delete(key: _verifiedPhoneKey);
  }

  static Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _verifiedTokenKey);
    await _storage.delete(key: _verifiedPhoneKey);
  }
}
