import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MypageView extends StatefulWidget {
  const MypageView({super.key});

  @override
  State<MypageView> createState() => _MypageViewState();
}

class _MypageViewState extends State<MypageView> {
  String _user = "준규";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              // 장바구니 페이지 이동
              Navigator.pushNamed(context, "/shoppingcart");

            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _user == null ? _NotUserLogin() : _UserLogin(),
    );
  }
}

// 로그인 전
class _NotUserLogin extends StatelessWidget {
  const _NotUserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("로그인 안했슨"));
  }
}

// 로그인 후
class _UserLogin extends StatelessWidget {
  const _UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            height: 300.h,
            color: Colors.orange,
            child: Center(child: Text("김준규님 ㅎㅇ")),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: double.infinity,
            color: Colors.orange,
            child: Column(
              children: [
                Container(
                  height: 150.h,
                  color: Colors.purple,
                ),
                Divider(),
                Container(
                  height: 150.h,
                  color: Colors.purple,
                ),
                Divider(),
                Container(
                  height: 150.h,
                  color: Colors.purple,
                ),
                Divider(),
                Container(
                  height: 150.h,
                  color: Colors.purple,
                ),
                Divider(),
                Container(
                  height: 150.h,
                  color: Colors.purple,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


