import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/order.dart';
import '../../data/model/shoppingcart.dart';
import '../../data/repository/order_repository.dart';
import '../../data/repository/user_repository.dart';

class ShoppingcartViewModel with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();

  final List<ShoppingcartDto> _items = [];
  List<ShoppingcartDto> get items => _items;

  // Shared에 장바구니 유저별로 넣게 !!!
  String? get _storageKey {
    final user = UserRepository.currentUser.value;
    if (user == null) return null;
    return 'shopping_cart_${user.userId}';
  }

  // 생성자 유저 갖고오기, 카트 로드하기
  ShoppingcartViewModel() {
    _init();

  }

  Future<void> _init() async {
    final user = UserRepository.currentUser.value;
    if (user != null) {
      await loadCart();
    }

    UserRepository.currentUser.addListener(() async {
      final user = UserRepository.currentUser.value;
      if (user == null) {
        await clearCart();
      } else {
        await loadCart();
      }
    });
  }

  // 주문하기
  Future<bool> placeOrder(BuildContext context) async {
    final user = UserRepository.currentUser.value;

    if (user == null || _items.isEmpty) return false;

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
      unitPrice: item.totalPrice,
    )).toList();

    try {
      await _orderRepository.placeOrder(orderRequest);
      await clearCart();

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
    if (_storageKey == null) {
      // 로그인 안 됨
      return false;
    }

    _items.add(item);
    notifyListeners();
    await saveCart();
    return true;
  }

  Future<void> removeItem(int index) async {
    _items.removeAt(index);
    notifyListeners();
    await saveCart();
  }

  Future<void> saveCart() async {
    final key = _storageKey;
    if (key == null) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonList = _items.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  Future<void> loadCart() async {
    final key = _storageKey;

    _items.clear();

    if (key == null) {
      notifyListeners();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key);

    if (jsonList != null) {
      _items.addAll(
        jsonList.map((e) => ShoppingcartDto.fromJson(jsonDecode(e))),
      );
    }

    notifyListeners();
  }

  Future<void> clearCart() async {
    final key = _storageKey;

    _items.clear();
    notifyListeners();

    if (key == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  void dispose() {
    super.dispose();
  }
}

