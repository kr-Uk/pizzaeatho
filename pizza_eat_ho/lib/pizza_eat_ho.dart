import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/splash.dart';
import 'package:pizzaeatho/ui/auth/auth_viewmodel.dart';
import 'package:pizzaeatho/ui/auth/join_view.dart';
import 'package:pizzaeatho/ui/auth/login_view.dart';
import 'package:pizzaeatho/ui/admin/admin_login_view.dart';
import 'package:pizzaeatho/ui/admin/admin_orders_page.dart';
import 'package:pizzaeatho/ui/ai/on_device_ai_page.dart';
import 'package:pizzaeatho/ui/order/order_detail_page.dart';
import 'package:pizzaeatho/ui/order/order_page.dart';
import 'package:pizzaeatho/ui/order/shoppingcart_view.dart';
import 'package:pizzaeatho/ui/order/shoppingcart_viewmodel.dart';
import 'package:pizzaeatho/ui/store/store_finder_view.dart';
import 'package:pizzaeatho/util/fcm_service.dart';
import 'package:provider/provider.dart';

import 'package:pizzaeatho/ui/main_shell.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initServices();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProxyProvider<AuthViewModel, ShoppingcartViewModel>(
          create: (context) =>
              ShoppingcartViewModel(context.read<AuthViewModel>()),
          update: (_, auth, cart) => cart!,
        ),
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
              '/order': (context) => OrderPage(),
              '/shoppingcart': (context) => ShoppingcartView(),
              '/order_detail': (context) => OrderDetailPage(),
              '/login' : (context) => LoginView(),
              '/join' : (context) => JoinView(),
              '/store' : (context) => StoreFinderView(),
              '/on_device_ai' : (context) => OnDeviceAiPage(),
              '/admin/login' : (context) => AdminLoginView(),
              '/admin/orders' : (context) => AdminOrdersPage(),
            },
          );
        },
    );
  }
}

Future<void> _initServices() async {
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 5));
    await FcmService.instance.initialize().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('Service init failed: $e');
  }
}
