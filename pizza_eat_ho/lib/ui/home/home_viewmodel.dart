import 'package:flutter/material.dart';

import '../../data/model/user.dart';
import '../../data/repository/user_repository.dart';

class HomeViewModel with ChangeNotifier {
  UserLoginResponseDto? _user;

  UserLoginResponseDto? get user => _user;
  bool get isLoggedIn => _user != null;

  late final VoidCallback _listener;

  HomeViewModel() {
    _user = UserRepository.currentUser.value;

    _listener = () {
      _user = UserRepository.currentUser.value;
      notifyListeners();
    };

    UserRepository.currentUser.addListener(_listener);
  }

  void onLoginButtonTap(BuildContext context) {
    if (isLoggedIn) {
      UserRepository().logout();
    } else {
      Navigator.pushNamed(context, "/login");
    }
  }

  void logout() {
    UserRepository().logout();
  }

  @override
  void dispose() {
    UserRepository.currentUser.removeListener(_listener);
    super.dispose();
  }
}
