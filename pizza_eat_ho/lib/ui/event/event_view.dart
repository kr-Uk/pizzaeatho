import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color _eventRed = Color(0xFFB91D2A);
const Color _eventGold = Color(0xFFF8D36A);
const Color _snowBackground = Color(0xFFF8F4EF);
const Color _ink = Color(0xFF1D1A17);

class _EventBanner {
  const _EventBanner({
    required this.imagePath,
  });

  final String imagePath;
}

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    const banners = [
      _EventBanner(imagePath: "assets/event1.png"),
      _EventBanner(imagePath: "assets/event3.png"),
      _EventBanner(imagePath: "assets/event2.png"),
      _EventBanner(imagePath: "assets/temp_event.png"),
      _EventBanner(imagePath: "assets/temp_event.png"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('이벤트', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: _eventRed,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/store");
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/shoppingcart");
            },
          ),
        ],
      ),
      backgroundColor: _snowBackground,
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        itemCount: banners.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (_, index) {
          return _EventBannerCard(
            banner: banners[index],
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('알림'),
                    content: const Text('종료된 이벤트입니다.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('확인'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _EventBannerCard extends StatelessWidget {
  const _EventBannerCard({
    required this.banner,
    required this.onTap,
  });

  final _EventBanner banner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: SizedBox(
                height: 700.h,
                width: double.infinity,
                child: Image.asset(banner.imagePath, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
