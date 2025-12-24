import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/data/model/enums.dart';
import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/ui/admin/admin_orders_viewmodel.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:provider/provider.dart';

class AdminOrdersView extends StatefulWidget {
  const AdminOrdersView({super.key});

  @override
  State<AdminOrdersView> createState() => _AdminOrdersViewState();
}

class _AdminOrdersViewState extends State<AdminOrdersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminOrdersViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminOrdersViewModel>();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('관리자 주문 관리'),
          backgroundColor: redBackground,
          foregroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          bottom: const TabBar(
            tabs: [
              Tab(text: '받은 주문'),
              Tab(text: '조리 중'),
              Tab(text: '주문 완료'),
            ],
          ),
        ),
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildOrderList(
                    context,
                    viewModel.receivedOrders,
                  ),
                  _buildOrderList(
                    context,
                    viewModel.cookingOrders,
                  ),
                  _buildOrderList(
                    context,
                    viewModel.doneOrders,
                    showActions: false,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    List<UserOrderListItemDto> orders, {
    bool showActions = true,
  }) {
    if (orders.isEmpty) {
      return const Center(child: Text('주문이 없습니다.'));
    }
    return RefreshIndicator(
      onRefresh: context.read<AdminOrdersViewModel>().load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
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
                Text(
                  '주문번호 #${order.orderId}',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '주문시간: ${order.orderTime.toLocal()}',
                  style: TextStyle(fontSize: 24.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  '총액: ${order.totalPrice}원',
                  style: TextStyle(fontSize: 24.sp),
                ),
                if (showActions) ...[
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final targetStatus = order.status == OrderStatus.received
                            ? OrderStatus.cooking
                            : OrderStatus.done;
                        context
                            .read<AdminOrdersViewModel>()
                            .updateStatus(order.orderId, targetStatus);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redBackground,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        order.status == OrderStatus.received
                            ? '주문 받기'
                            : '조리 완료',
                        style: TextStyle(fontSize: 24.sp),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
