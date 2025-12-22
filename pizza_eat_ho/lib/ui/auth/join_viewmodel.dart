import 'package:flutter/foundation.dart';
import 'package:pizzaeatho/data/model/user.dart';
import 'package:pizzaeatho/data/repository/user_repository.dart';

class JoinViewModel with ChangeNotifier {
  final UserRepository _userRepository;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  String? _errorMessage;

  JoinViewModel({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository();

  Future<bool> signup({
    required String id,
    required String pw,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userRepository.signup(
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
}
