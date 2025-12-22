import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/data/repository/user_repository.dart';
import 'package:pizzaeatho/splash.dart';
import 'package:pizzaeatho/ui/home/home_view.dart';
import 'package:pizzaeatho/ui/auth/login_view.dart';
import 'package:pizzaeatho/ui/order/order_detail_page.dart';
import 'package:pizzaeatho/ui/order/order_history_viewmodel.dart';
import 'package:pizzaeatho/ui/order/shoppingcart_view.dart';
import 'package:pizzaeatho/ui/auth/login_page.dart';
import 'package:pizzaeatho/ui/order/shoppingcart_viewmodel.dart';
import 'package:pizzaeatho/ui/store/store_finder_view.dart';
import 'package:provider/provider.dart';

import 'main.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserRepository.restoreSession();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppingcartViewModel()),
      ],
      child: MyApp(),
    ),
  );
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
              '/shoppingcart': (context) => ShoppingcartView(),
              '/order_detail': (context) => OrderDetailPage(),
              '/login' : (context) => LoginPage(),
              '/store' : (context) => StoreFinderView()
            },
          );
        },
    );
  }
}
