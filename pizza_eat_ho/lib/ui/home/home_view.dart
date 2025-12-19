import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFA11111),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      width: double.infinity,
                      height: 500.h,
                      child: Center(child: Text("배너")),
                    ),
                    SizedBox(height: 20.h),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFA11111),
                          border: Border.all(color: Colors.white, width: 4.w),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        width: double.infinity,
                        height: 250.h,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: .center,
                            children: [
                              Icon(Icons.power_settings_new_outlined, color: Colors.white, size: 100.w,),
                              SizedBox(width: 10.w),
                              Text(
                                "LOG IN",
                                style: TextStyle(color: Colors.white, fontSize: 80.sp, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              color: Colors.green,
              height: 500.h,
              child: Center(child: Text("최근 주문 내역")),
            ),
            SizedBox(height: 20.h),
            Container(
              color: Colors.green,
              height: 500.h,
              child: Center(child: Text("이거 어때유 ~")),
            ),
          ],
        ),
      ),
    );
  }
}
