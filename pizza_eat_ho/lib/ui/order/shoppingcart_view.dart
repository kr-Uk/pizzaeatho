import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/ui/auth/auth_viewmodel.dart';
import 'package:pizzaeatho/ui/order/shoppingcart_viewmodel.dart';
import 'package:provider/provider.dart';

const Color _snowBackground = Color(0xFFF9F6F1);

class ShoppingcartView extends StatefulWidget {
  const ShoppingcartView({super.key});

  @override
  State<ShoppingcartView> createState() => _ShoppingcartViewState();
}

class _ShoppingcartViewState extends State<ShoppingcartView> {
  @override
  Widget build(BuildContext context) {
    final shoppingcartViewModel = context.watch<ShoppingcartViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final isLoggedIn = authViewModel.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('장바구니', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFFB91D2A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: _snowBackground,
      body: _buildShoppingcart(shoppingcartViewModel, isLoggedIn),
      bottomNavigationBar: isLoggedIn
          ? SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    )
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    shoppingcartViewModel.placeOrder(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCE1933),
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('주문하기'),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildShoppingcart(
    ShoppingcartViewModel shoppingcartViewModel,
    bool isLoggedIn,
  ) {
    if (!isLoggedIn) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '로그인이 필요한 서비스입니다.',
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
              child: const Text('로그인 하기'),
            ),
          ],
        ),
      );
    }

    final items = shoppingcartViewModel.items;
    final itemCount = items.length;
    if (itemCount == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '장바구니가 비었습니다.',
              style: TextStyle(
                fontSize: 44.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/order');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE1933),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: const Text('맛있는 피자 보러 가기'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.vertical,
      itemCount: itemCount,
      itemBuilder: (_, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 280.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    image: DecorationImage(
                      image: AssetImage(item.product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text('도우 : ${item.dough.name}'),
                Text('크러스트 : ${item.crust.name}'),
                Row(
                  children: [
                    const Text('토핑 : '),
                    Expanded(
                      child: Text(
                        item.toppings.map((t) => "${t.name} ").join(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => shoppingcartViewModel.removeItem(index),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}