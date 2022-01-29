import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _keyUsername = "username";
  static const String _keyPassword = "password";
  static const String _keyConnexionToken = "connexionToken";
  static const String _keySchedule = "schedule";
  static const String _keyName = "name";

  // Setters
  static Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);

  static Future setPassword(String password) async =>
      await _storage.write(key: _keyPassword, value: password);

  static Future setConnexionToken(String connexionToken) async =>
      await _storage.write(key: _keyConnexionToken, value: connexionToken);

  static Future setSchedule(String schedule) async =>
      await _storage.write(key: _keySchedule, value: schedule);

  static Future setName(String name) async =>
      await _storage.write(key: _keyName, value: name);

  // Getters
  static Future<String?> getUsername() async =>
      await _storage.read(key: _keyUsername);

  static Future<String?> getPassword() async =>
      await _storage.read(key: _keyPassword);

  static Future<String?> getConnexionToken() async =>
      await _storage.read(key: _keyConnexionToken);

  static Future<String?> getSchedule() async =>
      await _storage.read(key: _keySchedule);

  static Future<String?> getName() async => await _storage.read(key: _keyName);

  // Deleters
  static Future<void> deleteUsername() async =>
      await _storage.delete(key: _keyUsername);

  static Future<void> deletePassword() async =>
      await _storage.delete(key: _keyPassword);

  static Future<void> deleteConnexionToken() async =>
      await _storage.delete(key: _keyConnexionToken);

  static Future<void> deleteSchedule() async =>
      await _storage.delete(key: _keySchedule);

  static Future<void> deleteName() async =>
      await _storage.delete(key: _keyName);
}
