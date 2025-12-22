import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pizzaeatho/data/datasource/local_datasource.dart';
import 'package:pizzaeatho/data/datasource/remote_datasource.dart';
import 'package:pizzaeatho/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();

  static final ValueNotifier<UserLoginResponseDto?> currentUser =
      ValueNotifier<UserLoginResponseDto?>(null);
  static const String _keyUserId = 'userId';
  static const String _keyUserName = 'userName';
  static const String _keyUserStamp = 'userStamp';
  static const String _keyUsers = 'users';
  static const String _keyNextUserId = 'nextUserId';

  static Future<void> restoreSession() async {
    final prefs = SharedPreferencesAsync();
    final userId = await prefs.getInt(_keyUserId);
    final name = await prefs.getString(_keyUserName);
    final stamp = await prefs.getInt(_keyUserStamp);

    if (userId == null || name == null || stamp == null) {
      currentUser.value = null;
      return;
    }

    currentUser.value = UserLoginResponseDto(
      userId: userId,
      name: name,
      stamp: stamp,
    );
  }

  Future<UserLoginResponseDto> login(UserLoginRequestDto request) async {
    final prefs = SharedPreferencesAsync();
    final users = await _loadUsers(prefs);

    for (final user in users) {
      if (user['id'] == request.id && user['pw'] == request.pw) {
        final localUser = UserLoginResponseDto(
          userId: (user['userId'] as num).toInt(),
          name: user['name'] as String,
          stamp: (user['stamp'] as num).toInt(),
        );
        currentUser.value = localUser;
        await _persistSession(prefs, localUser);
        return localUser;
      }
    }

    final remoteUser = await _remoteDataSource.login(request);
    currentUser.value = remoteUser;
    await _persistSession(prefs, remoteUser);
    return remoteUser;
  }

  Future<UserSignupResponseDto> signup(UserSignupRequestDto request) async {
    if (request.id.isEmpty || request.pw.isEmpty || request.name.isEmpty) {
      throw Exception('모든 항목을 입력해주세요.');
    }

    final prefs = SharedPreferencesAsync();
    final users = await _loadUsers(prefs);

    for (final user in users) {
      if (user['id'] == request.id) {
        throw Exception('이미 존재하는 아이디입니다.');
      }
    }

    final nextUserId = (await prefs.getInt(_keyNextUserId)) ?? 1;
    final newUser = <String, dynamic>{
      'userId': nextUserId,
      'id': request.id,
      'pw': request.pw,
      'name': request.name,
      'stamp': 0,
    };

    users.add(newUser);
    await _saveUsers(prefs, users);
    await prefs.setInt(_keyNextUserId, nextUserId + 1);

    return UserSignupResponseDto(
      userId: nextUserId,
      id: request.id,
      name: request.name,
      stamp: 0,
    );
  }

  void logout() {
    currentUser.value = null;
    final prefs = SharedPreferencesAsync();
    prefs.remove(_keyUserId);
    prefs.remove(_keyUserName);
    prefs.remove(_keyUserStamp);
  }

  Future<void> _persistSession(
    SharedPreferencesAsync prefs,
    UserLoginResponseDto user,
  ) async {
    await prefs.setInt(_keyUserId, user.userId);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setInt(_keyUserStamp, user.stamp);
  }

  Future<List<Map<String, dynamic>>> _loadUsers(
    SharedPreferencesAsync prefs,
  ) async {
    final rawUsers = await prefs.getStringList(_keyUsers) ?? <String>[];
    return rawUsers
        .map((raw) => jsonDecode(raw) as Map<String, dynamic>)
        .toList();
  }

  Future<void> _saveUsers(
    SharedPreferencesAsync prefs,
    List<Map<String, dynamic>> users,
  ) async {
    final rawUsers = users.map((user) => jsonEncode(user)).toList();
    await prefs.setStringList(_keyUsers, rawUsers);
  }
}
