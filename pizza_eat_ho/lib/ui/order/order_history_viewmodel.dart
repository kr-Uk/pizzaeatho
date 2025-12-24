import 'package:flutter/material.dart';
import 'package:pizzaeatho/data/repository/auth_repository.dart';
import '../../data/model/order.dart';
import '../../data/repository/order_repository.dart';

class OrderHistoryViewModel with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthRepository _authRepository = AuthRepository();

  List<UserOrderListItemDto> _orderHistory = [];
  List<UserOrderListItemDto> get orderHistory => _orderHistory;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  OrderHistoryViewModel() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    final user = await _authRepository.getCurrentUser();

    if (user != null) {
      await _loadOrderHistory(user.userId);
    } else {
      _orderHistory.clear();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadOrderHistory(int userId) async {
    _orderHistory = await _orderRepository.getOrderHistory(userId);
    _isLoading = false;
    notifyListeners();
  }

  void clearOrders() {
    _orderHistory.clear();
    notifyListeners();
  }
}
