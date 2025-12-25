import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/model/enums.dart';
import '../../data/model/order.dart';
import '../../util/common.dart';
import '../auth/auth_viewmodel.dart';
import 'shoppingcart_viewmodel.dart';
import 'order_history_detail_viewmodel.dart';
import 'review_form_page.dart';

const Color _christmasGreen = redBackground;
const Color _snowBackground = Color(0xFFF9F6F1);

class OrderHistoryDetailView extends StatelessWidget {
  const OrderHistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderHistoryDetailViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final shoppingcartViewModel = context.read<ShoppingcartViewModel>();
    final baseUrl = "http://${IP_PORT}/imgs/pizza/";
    final orderHistoryDetail = viewModel.orderDetails;

    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (viewModel.errorMessage != null) {
      return Scaffold(body: Center(child: Text(viewModel.errorMessage!)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('주문 상세', style: TextStyle(color: Colors.white)),
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
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: orderHistoryDetail.length,
        itemBuilder: (_, index) {
          final item = orderHistoryDetail[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            padding: const EdgeInsets.all(12.0),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 400.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    image: DecorationImage(
                      image: NetworkImage("${baseUrl}${item.product.image}"),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 42.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '주문 상세 정보',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _infoChip('주문 가격 ${item.unitPrice}원'),
                    _infoChip('상태 ${item.status.name}'),
                    _infoChip('크러스트 ${item.crust}'),
                    _infoChip('도우 ${item.dough}'),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '토핑',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 6,
                  children: item.toppings.map((topping) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE6E2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _christmasGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        topping.name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (item.status == OrderStatus.done)
                      ElevatedButton(
                        onPressed: () {
                          final user = authViewModel.user;
                          if (user == null) {
                            Navigator.pushNamed(context, '/login');
                            return;
                          }
                          _openReviewPage(context, item, user.userId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redBackground,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('리뷰 작성하기'),
                      ),
                    if (item.status == OrderStatus.done) SizedBox(width: 8.w),
                    ElevatedButton(
                      onPressed: viewModel.hasOptions
                          ? () async {
                              final cartItem = viewModel.buildCartItem(item);
                              if (cartItem == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('장바구니 담기에 실패했습니다.'),
                                  ),
                                );
                                return;
                              }
                              final success =
                                  await shoppingcartViewModel.addItem(cartItem);
                              if (!context.mounted) return;
                              if (!success) {
                                Navigator.pushNamed(context, '/login');
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('장바구니에 담았습니다.'),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redBackground,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('장바구니 담기'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openReviewPage(
    BuildContext context,
    OrderHistoryDetailDto item,
    int userId,
  ) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ReviewFormPage.create(
          userId: userId,
          options: [item],
        ),
      ),
    ).then((result) {
      if (!context.mounted || result != true) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리뷰가 등록되었습니다.')),
      );
    });
  }

  Widget _buildSectionTitle(
    String title, {
    bool showAccent = true,
    bool showAccentLine = false,
  }) {
    final accentColor = showAccent ? _christmasGreen : Colors.transparent;

    return Row(
      children: [
        if (showAccentLine) ...[
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: _christmasGreen,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: redBackground,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 2,
            color: showAccentLine
                ? _christmasGreen.withOpacity(0.3)
                : (showAccent
                    ? _christmasGreen.withOpacity(0.3)
                    : Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _christmasGreen.withOpacity(0.4),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
