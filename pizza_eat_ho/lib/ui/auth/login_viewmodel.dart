import 'package:flutter/cupertino.dart';
import 'package:pizzaeatho/data/model/user.dart';
import 'package:pizzaeatho/data/repository/user_repository.dart';

class LoginViewModel with ChangeNotifier {
  final UserRepository _userRepository;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  String? _errorMessage;

  UserLoginResponseDto? get user => _user;
  UserLoginResponseDto? _user;

  LoginViewModel({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository();

  Future<bool> login({
    required String id,
    required String pw,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _userRepository.login(
        UserLoginRequestDto(id: id, pw: pw),
      );
      return true;
    } catch (e) {
      _user = null;
      _errorMessage = '아이디 또는 비밀번호가 틀렸습니다.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
