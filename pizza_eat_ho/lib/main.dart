import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/ui/auth/login_page.dart';
import 'package:pizzaeatho/ui/event/event_view.dart';
import 'package:pizzaeatho/ui/home/home_view.dart';
import 'package:pizzaeatho/ui/mypage/mypage_view.dart';
import 'package:pizzaeatho/ui/order/order_detail_view.dart';
import 'package:pizzaeatho/ui/order/order_page.dart';
import 'package:pizzaeatho/util/common.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.menu_outlined, size: 60.w, color: Colors.black),
                SizedBox(height: 12.h),
                Text("주문하기")
              ],
            ),
            label: "주문하기",
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.star_border_outlined, size: 60.w, color: Colors.black),
                SizedBox(height: 12.h),
                Text("이벤트")
              ],
            ),
            label: "이벤트",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 150.w,
              height: 150.w,
              child: Center(
                child: Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: BoxDecoration(
                    color: redBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0XFF4B4747),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_outlined, color: Colors.white, size: 60.w),
                      SizedBox(height: 6.h),
                      Text("HOME", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.person_outlined, size: 60.w, color: Colors.black),
                SizedBox(height: 12.h),
                Text("마이페이지")
              ],
            ),
            label: "마이페이지",
          ),
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(Icons.receipt_long_outlined, size: 60.w, color: Colors.black),
                SizedBox(height: 12.h),
                Text("주문내역")
              ],
            ),
            label: "주문내역",
          ),
        ],
      ),
      body: _screenList.elementAt(_selectedIndex),
    );
  }
}

List _screenList = [
  OrderPage(),
  EventView(),
  HomeView(),
  MypageView(),
  OrderDetailView(),
  LoginPage(),
];
