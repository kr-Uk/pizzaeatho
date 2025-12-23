import 'package:flutter/material.dart';
import 'package:pizzaeatho/ui/event/event_view.dart';
import 'package:pizzaeatho/ui/home/home_page.dart';
import 'package:pizzaeatho/ui/mypage/mypage_view.dart';
import 'package:pizzaeatho/ui/order/order_history_page.dart';
import 'package:pizzaeatho/ui/order/order_page.dart';
import 'package:pizzaeatho/util/common.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 2;

  Widget _navItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28, color: Colors.black),
        const SizedBox(height: 4),
        FittedBox(
          child: Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _homeNavItem() {
    return SizedBox(
      width: 72,
      height: 72,
      child: Center(
        child: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: redBackground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0XFF4B4747),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home_outlined, color: Colors.white, size: 28),
              SizedBox(height: 2),
              Text('HOME', style: TextStyle(color: Colors.white, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

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
            icon: _navItem(Icons.menu_outlined, '주문하기'),
            label: '주문하기',
          ),
          BottomNavigationBarItem(
            icon: _navItem(Icons.star_border_outlined, '이벤트'),
            label: '이벤트',
          ),
          BottomNavigationBarItem(
            icon: _homeNavItem(),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: _navItem(Icons.person_outlined, '마이페이지'),
            label: '마이페이지',
          ),
          BottomNavigationBarItem(
            icon: _navItem(Icons.receipt_long_outlined, '주문내역'),
            label: '주문내역',
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
  HomePage(),
  MypageView(),
  OrderHistoryPage(),

];
