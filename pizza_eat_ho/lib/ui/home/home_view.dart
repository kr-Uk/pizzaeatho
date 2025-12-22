import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/data/model/user.dart';
import 'package:pizzaeatho/data/repository/user_repository.dart';
import 'package:pizzaeatho/util/beacon_service.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;
  BeaconService? _beaconService;
  bool _dialogOpen = false;

  final banners = List.generate(
    6,
    (index) => Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: SizedBox(
        height: 500.h,
        child: Center(
          child: Text("Page $index", style: TextStyle(color: Colors.indigo)),
        ),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _currentPage = (_currentPage + 1) % banners.length;

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });


    _beaconService = BeaconService(
      uuid: 'e2c56db5-dffb-48d2-b060-d0f5a71096e0',
      major: 40011,
      minor: 45369,
      enterDistanceMeters: 3.0,
      onEnter: () {
        _showBeaconDialog('피짜잇호에 오신 것을 환영합니다!');
      },
      onExit: () {
        _showBeaconDialog('다음에 또 이용해주세요!');
      },
    );
    _beaconService?.start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    // _beaconService?.dispose();
    super.dispose();
  }

  void _showBeaconDialog(String message) {
    if (!mounted || _dialogOpen) return;
    _dialogOpen = true;
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    ).then((_) {
      if (mounted) {
        _dialogOpen = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    final user = homeViewModel.user;
    final isLoggedIn = homeViewModel.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pizza잇호!', style: TextStyle(color: Colors.white)),
        backgroundColor: redBackground,
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: redBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: .center,
                      children: [
                        SizedBox(
                          height: 500.h,
                          child: ClipRRect(
                            borderRadius: .circular(30.r),
                            child: PageView.builder(
                              controller: _controller,
                              onPageChanged: (index) {
                                _currentPage = index;
                              },
                              itemBuilder: (_, index) {
                                return banners[index % banners.length];
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: SmoothPageIndicator(
                            controller: _controller,
                            count: banners.length,
                            effect: ScrollingDotsEffect(
                              activeDotColor: redBackground,
                              activeStrokeWidth: 2.6,
                              activeDotScale: 1.3,
                              maxVisibleDots: 5,
                              radius: 8,
                              spacing: 10,
                              dotHeight: 12,
                              dotWidth: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60.h),
                  InkWell(
                    onTap: () => homeViewModel.onLoginButtonTap(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: redBackground,
                        border: Border.all(color: Colors.white, width: 4.w),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      width: double.infinity,
                      height: 250.h,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.power_settings_new_outlined,
                              color: Colors.white,
                              size: 100.w,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              isLoggedIn ? "LOG OUT" : "LOG IN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 80.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isLoggedIn) ...[
                              SizedBox(width: 20.w),
                              Flexible(
                                child: Text(
                                  "${user!.name}님",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
              height: 70.h,
              width: 300.w,
              decoration: BoxDecoration(
                color: redBackground,
                borderRadius: .circular(100.r),
              ),
              child: Center(
                child: Text("최근 주문 내역", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 600.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (_, index) {
                  return Container(
                    width: 300.w,
                    margin: index == 9
                        ? EdgeInsets.symmetric(horizontal: 8.0)
                        : EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 300.w,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: .circular(30.r),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text("$index번 째 아이템"),
                        SizedBox(height: 20.h),
                        Text("가격 : 3000원"),
                      ],
                    ),
                  );
                },
              ),
            ),

              SizedBox(height: 20.h),
              Container(
                height: 70.h,
                width: 300.w,
                decoration: BoxDecoration(
                  color: redBackground,
                  borderRadius: .circular(100.r),
                ),
                child: Center(
                  child: Text("이거 어때유~?", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 600.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (_, index) {
                    return Container(
                      width: 300.w,
                      margin: index == 9
                          ? EdgeInsets.symmetric(horizontal: 8.0)
                          : EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 300.w,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: .circular(30.r),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text("$index번 째 아이템"),
                          SizedBox(height: 20.h),
                          Text("가격 : 3000원"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}
