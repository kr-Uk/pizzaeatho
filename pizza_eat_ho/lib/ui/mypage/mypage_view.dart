import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/ui/auth/auth_viewmodel.dart';
import 'package:pizzaeatho/ui/order/order_history_page.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:provider/provider.dart';

const Color _christmasGreen = redBackground;
const Color _snowBackground = Color(0xFFF9F6F1);

class MypageView extends StatefulWidget {
  const MypageView({super.key});

  @override
  State<MypageView> createState() => _MypageViewState();
}

class _MypageViewState extends State<MypageView> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFB91D2A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/store');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/shoppingcart');
            },
          ),
        ],
      ),
      backgroundColor: _snowBackground,
      body: authViewModel.isLoggedIn
          ? _UserLogin(userName: user!.name, stamp: user.stamp)
          : const _NotUserLogin(),
    );
  }
}

class _NotUserLogin extends StatelessWidget {
  const _NotUserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_outline,
              color: redBackground,
              size: 40,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            '로그인이 필요합니다.',
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCE1933),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }
}

class _UserLogin extends StatelessWidget {
  const _UserLogin({super.key, required this.userName, required this.stamp});

  final String userName;
  final int stamp;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 288.w,
                      height: 288.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(72.r),
                        image: const DecorationImage(
                          image: AssetImage('assets/ganadi1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 40.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 70.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            '님 반가워요!',
                            style: TextStyle(
                              fontSize: 70.sp,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 36.h),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE6E2),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '멤버십 등급: ${_gradeForStamp(stamp)}',
                        style: TextStyle(
                          fontSize: 54.sp,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '스탬프 ${stamp}개',
                        style: TextStyle(
                          fontSize: 48.sp,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _StampGauge(
                        stamp: stamp,
                        color: redBackground,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _nextGradeMessage(stamp),
                        style: TextStyle(
                          fontSize: 44.sp,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AuthViewModel>().logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redBackground,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                    ),
                    child: const Text('로그아웃'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildMenuCard(
            icon: Icons.receipt_long_outlined,
            title: '주문 내역',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryPage(),
                ),
              );
            },
          ),
          _buildMenuCard(
            icon: Icons.shopping_cart_outlined,
            title: '장바구니',
            onTap: () {
              Navigator.pushNamed(context, '/shoppingcart');
            },
          ),
          _buildMenuCard(
            icon: Icons.smart_toy_outlined,
            title: '온디바이스 AI',
            onTap: () {
              Navigator.pushNamed(context, '/on_device_ai');
            },
          ),
          _buildMenuCard(
            icon: Icons.map_outlined,
            title: '매장 찾기',
            onTap: () {
              Navigator.pushNamed(context, '/store');
            },
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  String _gradeForStamp(int stamp) {
    if (stamp >= 10) return '피짜잇호잇짜';
    if (stamp >= 5) return '피짜잇';
    return '피짜';
  }

  String _nextGradeMessage(int stamp) {
    if (stamp >= 10) return '최고 등급입니다.';
    if (stamp >= 5) return '다음 등급까지 ${10 - stamp}개 남았습니다.';
    return '다음 등급까지 ${5 - stamp}개 남았습니다.';
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _christmasGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: _christmasGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _StampGauge extends StatelessWidget {
  const _StampGauge({
    required this.stamp,
    required this.color,
  });

  final int stamp;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isMax = stamp >= 10;
    final int maxStamp = stamp >= 5 ? 10 : 5;
    final double value = isMax ? 1 : (stamp / maxStamp).clamp(0, 1).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: value,
          minHeight: 14,
          backgroundColor: color.withOpacity(0.15),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(12),
        ),
        SizedBox(height: 6.h),
        Text(
          isMax ? 'MAX' : '$stamp / $maxStamp',
          style: TextStyle(
            fontSize: 38.sp,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
