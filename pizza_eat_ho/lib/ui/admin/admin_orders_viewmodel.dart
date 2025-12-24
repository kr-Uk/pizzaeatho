import 'package:flutter/foundation.dart';
import 'package:pizzaeatho/data/model/enums.dart';
import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/repository/order_repository.dart';

class AdminOrdersViewModel with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();

  bool _isLoading = false;
  List<UserOrderListItemDto> _orders = [];

  bool get isLoading => _isLoading;
  List<UserOrderListItemDto> get orders => _orders;

  List<UserOrderListItemDto> get receivedOrders =>
      _orders.where((o) => o.status == OrderStatus.received).toList();

  List<UserOrderListItemDto> get cookingOrders =>
      _orders.where((o) => o.status == OrderStatus.cooking).toList();

  List<UserOrderListItemDto> get doneOrders =>
      _orders.where((o) => o.status == OrderStatus.done).toList();

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _orders = await _orderRepository.getAllOrders();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStatus(int orderId, OrderStatus status) async {
    await _orderRepository.updateOrderStatus(orderId, status);
    await load();
  }
}
