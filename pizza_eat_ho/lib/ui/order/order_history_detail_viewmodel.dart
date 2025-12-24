import 'package:flutter/cupertino.dart';
import 'package:pizzaeatho/data/model/product.dart';

import '../../data/model/order.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/order_repository.dart';
import '../../data/repository/product_repository.dart';

class OrderHistoryDetailViewModel with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();

  final int orderId;

  OrderHistoryDetailViewModel(this.orderId) {
    _init();
  }

  List<OrderHistoryDetailDto> _orderDetails = [];
  List<OrderHistoryDetailDto> get orderDetails => _orderDetails;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> _init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orderDetails = await _orderRepository.getOrderHistoryDetail(orderId);

      if (_orderDetails.isEmpty) {
        _errorMessage = '주문 상세가 없습니다';
      }
    } catch (e) {
      _errorMessage = '주문 상세를 불러오지 못했습니다';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}