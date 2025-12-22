import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_view.dart';
import 'login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
        create: (_) => LoginViewModel(),
        child: LoginView());
  }
}