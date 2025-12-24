import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/ui/order/shoppingcart_viewmodel.dart';
import 'package:pizzaeatho/util/commgon.dart';
import 'package:provider/provider.dart';

import '../../data/model/product.dart';
import '../../data/model/shoppingcart.dartg';
import 'order_detail_viewmodel.dart';

const Color _christmasGreen = Color(0xFF0F6B3E);
const Color _snowBackground = Color(0xFFF9F6F1);

class OrderDetailView extends StatefulWidget {
  const OrderDetailView({super.key});

  @override
  State<OrderDetailView> createState() => _OrderDetailViewState();
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final BASE_URL = "http://${IP_PORT}/imgs/pizza/";

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductDto;
    final orderDetailViewModel = context.watch<OrderDetailViewModel>();
    final shoppingcartViewModel = context.read<ShoppingcartViewModel>();
    final comments = orderDetailViewModel.comments;

    return Scaffold(
      backgroundColor: _snowBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/shoppingcart");
            },
          ),
        ],
      ),
      body: _buildOrderDetail(product, orderDetailViewModel),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "합계 ${orderDetailViewModel.totalPrice(product.price)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final cartItem = ShoppingcartDto(
                    product: product,
                    dough: orderDetailViewModel.selectedDough!,
                    crust: orderDetailViewModel.selectedCrust!,
                    toppings: orderDetailViewModel.selectedToppings,
                    quantity: 1,
                    totalPrice: orderDetailViewModel.totalPrice(product.price),
                  );

                  final success = await shoppingcartViewModel.addItem(cartItem);

                  if (!success) {
                    Navigator.pushNamed(context, "/login");
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: redBackground,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text("장바구니 담기"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetail(ProductDto product, OrderDetailViewModel viewModel) {
    final toppings = viewModel.toppings;
    final doughs = viewModel.doughs;
    final crusts = viewModel.crusts;
    final comments = viewModel.comments;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 800.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  image: DecorationImage(
                    image: NetworkImage("${BASE_URL}${product.image}"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 260.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.45),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.description),
                const SizedBox(height: 8),
                Text("${product.price}", style: textProductPrice),
                Divider(),
                Text("리뷰", style: textProductName),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: (){},
                  child: SizedBox(
                    height: 400.h,
                    child: viewModel.comments.isEmpty
                    ? Center(child: Text("아직 리뷰가 없어용 ㅠㅠ"))
                    : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: comments.length,
                      itemBuilder: (_, index) {
                        final comment = comments[index];
                        return Container(
                          width: 420.w,
                          margin: EdgeInsets.only(
                            left: 12.w,
                            right: index == 4 ? 12.w : 0,
                          ),
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFC31E2E),
                              width: 1.5.w,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < comment.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  );
                                }),
                              ),

                              SizedBox(height: 20.h),

                              Text(
                                comment.comment,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),

                              const Spacer(),

                              Text(
                                comment.createdAt,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(),
                const SizedBox(height: 16),
                _sectionCard(
                  title: "도우",
                  showTitleBorder: false,
                  child: Column(
                    children: doughs.map((dough) {
                      return RadioListTile<DoughDto>(
                        value: dough,
                        groupValue: viewModel.selectedDough,
                        title: Text(dough.name),
                        secondary: Text("+${dough.price}"),
                        activeColor: _christmasGreen,
                        onChanged: (value) {
                          viewModel.selectDough(value!);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                _sectionCard(
                  title: "크러스트",
                  showTitleBorder: false,
                  child: Column(
                    children: crusts.map((crust) {
                      return RadioListTile<CrustDto>(
                        value: crust,
                        groupValue: viewModel.selectedCrust,
                        title: Text(crust.name),
                        secondary: Text("+${crust.price}"),
                        activeColor: _christmasGreen,
                        onChanged: (value) {
                          viewModel.selectCrust(value!);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                _sectionCard(
                  title: "토핑",
                  showTitleBorder: false,
                  child: Column(
                    children: toppings.map((topping) {
                      final isChecked = viewModel.selectedToppingIds.contains(
                        topping.toppingId,
                      );

                      return CheckboxListTile(
                        value: isChecked,
                        onChanged: (checked) {
                          viewModel.toggleTopping(topping.toppingId);
                        },
                        title: Text(topping.name),
                        secondary: Text("+${topping.price}"),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: _christmasGreen,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    bool showTitleBorder = true,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: redBackground,
              borderRadius: BorderRadius.circular(10),
              border: showTitleBorder
                  ? Border.all(color: _christmasGreen, width: 2)
                  : null,
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
