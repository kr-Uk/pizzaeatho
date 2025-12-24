import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class LocalDataSource {

  // User
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _keyUser = 'LOGIN_USER';

  Future<void> saveUser(UserLoginResponseDto user) async {
    await _storage.write(
      key: _keyUser,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<UserLoginResponseDto?> loadUser() async {
    final jsonString = await _storage.read(key: _keyUser);
    if (jsonString == null) return null;

    return UserLoginResponseDto.fromJson(jsonDecode(jsonString));
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyUser);
  }

  // Order
  static SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  String _cartKey(int userId) => 'shopping_cart_$userId';

  Future<void> saveCart(int userId, List<Map<String, dynamic>> items) async {
    final p = await prefs;
    final jsonList = items.map(jsonEncode).toList();
    await p.setStringList(_cartKey(userId), jsonList);
  }

  Future<List<Map<String, dynamic>>> loadCart(int userId) async {
    final p = await prefs;
    final jsonList = p.getStringList(_cartKey(userId));
    if (jsonList == null) return [];

    return jsonList
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clearCart(int userId) async {
    final p = await prefs;
    await p.remove(_cartKey(userId));
  }

}