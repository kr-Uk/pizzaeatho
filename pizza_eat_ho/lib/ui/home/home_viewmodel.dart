import 'package:flutter/material.dart';
import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/repository/order_repository.dart';

import '../../data/repository/auth_repository.dart';


class HomeViewModel with ChangeNotifier {

  final OrderRepository _orderRepository = OrderRepository();
  final AuthRepository _authRepository = AuthRepository();

  List<OrderHistoryDto> _orderHistory = [];
  List<OrderHistoryDto> get orderHistory => _orderHistory;

  String? get errorMessage => _errorMessage;
  String? _errorMessage;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  HomeViewModel() {
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orderHistory = await _orderRepository.getOrderHistoryWithDetail(userId);
      if (_orderHistory.isEmpty){
        _errorMessage = "주문 내역이 없습니다";
      }
      notifyListeners();
    } catch (e){
      _errorMessage = '주문현황 못갖고옴';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearOrders() {
    _orderHistory.clear();
    notifyListeners();
  }
}
