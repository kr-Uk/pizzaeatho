import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pizzaeatho/data/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/fcm_service.dart';
import '../../data/model/order.dart';
import '../../data/model/shoppingcart.dart';
import '../../data/repository/order_repository.dart';
import '../auth/auth_viewmodel.dart';

class ShoppingcartViewModel with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthRepository _authRepository = AuthRepository();
  final AuthViewModel _authViewModel;

  final List<ShoppingcartDto> _items = [];
  List<ShoppingcartDto> get items => _items;

  // 생성자 유저 갖고오기, 카트 로드하기
  ShoppingcartViewModel(this._authViewModel) {
    _authViewModel.addListener(_onAuthChanged);
    _onAuthChanged();
  }


  void _onAuthChanged() async {
    final user = _authViewModel.user;

    _items.clear();

    if (user != null) {
      _items.clear();
      _items.addAll(
        await _orderRepository.loadCart(user.userId),
      );
    }

    notifyListeners();
  }


  @override
  void dispose() {
    _authViewModel.removeListener(_onAuthChanged);
    super.dispose();
  }

  // 주문하기
  Future<bool> placeOrder(BuildContext context) async {
    final user = await _authRepository.getCurrentUser();

    if (user == null || _items.isEmpty) return false;

    final totalQuantity = _items.fold(0, (sum, item) => sum + item.quantity);

    String? fcmToken;
    try {
      fcmToken = await FcmService.instance.ensureToken();
    } catch (e) {
      debugPrint('FCM token fetch failed: $e');
    }

    final orderRequest = _items.map((item) => OrderCreateRequestDto(
      userId: user.userId,
      userName: user.name,
      productId: item.product.productId,
      doughId: item.dough.doughId,
      crustId: item.crust.crustId,
      toppings: item.toppings
          .map((t) => OrderCreateToppingReqDto(
        toppingId: t.toppingId,
        quantity: 1,
      ))
          .toList(),
      quantity: item.quantity,
      unitPrice: item.totalPrice,
      fcmToken: fcmToken,
    )).toList();

    try {
      await _orderRepository.placeOrder(orderRequest);
      await clearCart();
      await _authViewModel.incrementStamp(totalQuantity);

      // 주문 성공 메시지 출력
      debugPrint("주문이 성공적으로 완료되었습니다!");

      return true;
    } catch (e) {
      debugPrint("Order failed: $e");
      return false;
    }
  }

  // 카트 기능들!!
  Future<bool> addItem(ShoppingcartDto item) async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) return false;

    _items.add(item);
    notifyListeners();

    await _orderRepository.saveCart(user.userId, _items);

    return true;
  }

  Future<void> removeItem(int index) async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) return;
    _items.removeAt(index);
    notifyListeners();
    await _orderRepository.saveCart(user.userId, _items);
  }

  Future<void> clearCart() async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) return;

    _items.clear();
    notifyListeners();

    await _orderRepository.clearCart(user.userId);
  }


  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);
}

