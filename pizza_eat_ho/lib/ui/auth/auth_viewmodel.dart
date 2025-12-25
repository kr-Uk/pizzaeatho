import 'package:flutter/material.dart';

import '../../data/model/user.dart';
import '../../data/repository/auth_repository.dart';

class AuthViewModel with ChangeNotifier {
  late final AuthRepository _authRepository;

  UserLoginResponseDto? _user;

  UserLoginResponseDto? get user => _user;

  bool get isLoggedIn => _user != null;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  String? _errorMessage;

  AuthViewModel() {
    _authRepository = AuthRepository();
    _restoreLogin();
  }

  Future<void> _restoreLogin() async {
    _user = await _authRepository.getCurrentUser();
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    notifyListeners();
  }

  Future<bool> login({required String id, required String pw}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authRepository.login(UserLoginRequestDto(id: id, pw: pw));
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = '아이디 또는 비밀번호가 틀렸습니다.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup({
    required String id,
    required String pw,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.signup(
        UserSignupRequestDto(id: id, pw: pw, name: name),
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkUserId(String userId) async {
    try {
      _errorMessage = null;
      return await _authRepository.checkUserId(userId);
    } catch (e) {
      _errorMessage = '아이디 중복 확인에 실패했습니다.';
      notifyListeners();
      return false;
    }
  }

  Future<void> incrementStamp(int count) async {
    if (_user == null || count <= 0) return;
    final updated = UserLoginResponseDto(
      userId: _user!.userId,
      name: _user!.name,
      stamp: _user!.stamp + count,
    );
    await _authRepository.saveUser(updated);
    _user = updated;
    notifyListeners();
  }
}
