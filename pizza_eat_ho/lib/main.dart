import 'package:flutter/material.dart';
import 'package:pizzaeatho/ui/event/event_view.dart';
import 'package:pizzaeatho/ui/home/home_view.dart';
import 'package:pizzaeatho/ui/mypage/mypage_view.dart';
import 'package:pizzaeatho/ui/order/order_detail_view.dart';
import 'package:pizzaeatho/ui/order/order_view.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.amber,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 24, color: Colors.black),
              label: "홈",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star, size: 24, color: Colors.black),
              label: "이벤트",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu, size: 24, color: Colors.black),
              label: "주문하기",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 24, color: Colors.black,),
              label: "마이페이지",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long, size: 24, color: Colors.black),
              label: "주문내역",
            ),
          ],
        ),
        body: _screenList.elementAt(_selectedIndex)
    );
  }
}

List _screenList = [
  HomeView(),
  EventView(),
  OrderView(),
  MypageView(),
  OrderDetailView()
];