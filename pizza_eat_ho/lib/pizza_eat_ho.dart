import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/data/repository/user_repository.dart';
import 'package:pizzaeatho/splash.dart';
import 'package:pizzaeatho/ui/home/home_view.dart';
import 'package:pizzaeatho/ui/order/shoppingcart_view.dart';
import 'package:pizzaeatho/ui/auth/login_page.dart';

import 'main.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserRepository.restoreSession();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(1080, 2340),
        builder: (context, child) {
          return MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (context) => Splash(),
              '/main': (context) => Main(),
              '/home': (context) => HomeView(),
              '/shoppingcart': (context) => ShoppingcartView(),
              '/login' : (context) => LoginPage(),
            },
          );
        },
    );
  }
}
