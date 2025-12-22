import 'package:flutter/material.dart';
import 'package:pizzaeatho/ui/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

import 'home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(),
        child: HomeView());
  }
}