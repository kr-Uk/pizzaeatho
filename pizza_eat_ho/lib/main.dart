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
      appBar: AppBar(
        title: Text('Pizza잇호!', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFA11111),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              // 장바구니 페이지 이동
              Navigator.pushNamed(context, "/shoppingcart");

            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 24, color: Colors.black),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline, size: 24, color: Colors.black),
            label: "이벤트",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_outlined, size: 24, color: Colors.black),
            label: "주문하기",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined, size: 24, color: Colors.black),
            label: "마이페이지",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined, size: 24, color: Colors.black),
            label: "주문내역",
          ),
        ],
      ),
      body: _screenList.elementAt(_selectedIndex),
    );
  }
}

List _screenList = [
  HomeView(),
  EventView(),
  OrderView(),
  MypageView(),
  OrderDetailView(),
];
