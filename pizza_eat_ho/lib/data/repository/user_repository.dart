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
    final user = await _remoteDataSource.login(request);
    currentUser.value = user;
    final prefs = SharedPreferencesAsync();
    await prefs.setInt(_keyUserId, user.userId);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setInt(_keyUserStamp, user.stamp);
    return user;
  }

  void logout() {
    currentUser.value = null;
    final prefs = SharedPreferencesAsync();
    prefs.remove(_keyUserId);
    prefs.remove(_keyUserName);
    prefs.remove(_keyUserStamp);
  }
}
