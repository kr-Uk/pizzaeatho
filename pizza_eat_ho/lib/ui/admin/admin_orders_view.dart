import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/data/model/enums.dart';
import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/ui/admin/admin_orders_viewmodel.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:provider/provider.dart';

const Color _snowBackground = Color(0xFFF9F6F1);

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
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: '받은 주문'),
              Tab(text: '조리 중'),
              Tab(text: '주문 완료'),
            ],
          ),
        ),
        backgroundColor: _snowBackground,
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildOrderList(context, viewModel.receivedOrders),
                  _buildOrderList(context, viewModel.cookingOrders),
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
    final viewModel = context.watch<AdminOrdersViewModel>();
    if (orders.isEmpty) {
      return Center(
        child: Text(
          '주문이 없습니다.',
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: viewModel.load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final order = orders[index];
          final details = viewModel.getOrderDetails(order.orderId);
          return Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '주문 #${order.orderId}',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    _buildStatusChip(order.status),
                  ],
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
                SizedBox(height: 8.h),
                if (details == null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        viewModel.loadOrderDetails(order.orderId);
                      },
                      child: const Text('주문 상세 보기'),
                    ),
                  )
                else
                  _buildOrderDetails(details),
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
                            ? '조리 시작'
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

  Widget _buildOrderDetails(List<OrderDetailResponseDto> details) {
    return Column(
      children: details.map((detail) {
        final toppingText = detail.toppings.isEmpty
            ? '토핑: 없음'
            : '토핑: ${detail.toppings.map((t) => t.name).join(', ')}';
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _snowBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: redBackground.withOpacity(0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail.product,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                '도우: ${detail.dough}',
                style: TextStyle(fontSize: 22.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                '크러스트: ${detail.crust}',
                style: TextStyle(fontSize: 22.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                toppingText,
                style: TextStyle(fontSize: 22.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                '가격: ${detail.unitPrice}원',
                style: TextStyle(fontSize: 22.sp),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    String label;
    switch (status) {
      case OrderStatus.received:
        label = '접수';
        break;
      case OrderStatus.cooking:
        label = '조리중';
        break;
      case OrderStatus.done:
        label = '완료';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: redBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
