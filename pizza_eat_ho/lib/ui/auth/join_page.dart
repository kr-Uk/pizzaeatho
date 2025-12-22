import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'join_view.dart';
import 'join_viewmodel.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<JoinViewModel>(
      create: (_) => JoinViewModel(),
      child: const JoinView(),
    );
  }
}
