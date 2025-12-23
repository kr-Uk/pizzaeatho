import 'package:flutter/material.dart';
import 'package:pizzaeatho/data/repository/auth_repository.dart';
import '../../data/model/order.dart';
import '../../data/repository/order_repository.dart';

class OrderHistoryViewModel with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthRepository _authRepository = AuthRepository();

  List<UserOrderListItemDto> _orderHistory = [];
  List<UserOrderListItemDto> get orderHistory => _orderHistory;

  OrderHistoryViewModel() {
    _init();
  }

  Future<void> _init() async {
    final user = await _authRepository.getCurrentUser();

    if (user != null) {
      await _loadOrderHistory(user.userId);
    } else {
      _orderHistory.clear();
      notifyListeners();
    }
  }

  Future<void> _loadOrderHistory(int userId) async {
    _orderHistory = await _orderRepository.getOrderHistory(userId);
    notifyListeners();
  }

  void clearOrders() {
    _orderHistory.clear();
    notifyListeners();
  }
}
