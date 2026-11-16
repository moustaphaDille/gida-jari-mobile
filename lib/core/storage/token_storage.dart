import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _profileTypeKey = 'profile_type';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  Future<void> saveSessionProfile({
    required String userId,
    required String profileType,
  }) async {
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _profileTypeKey, value: profileType);
  }

  Future<String?> readAccessToken() => _storage.read(key: _accessKey);
  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);
  Future<String?> readUserId() => _storage.read(key: _userIdKey);
  Future<String?> readProfileType() => _storage.read(key: _profileTypeKey);

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _profileTypeKey);
  }
}
