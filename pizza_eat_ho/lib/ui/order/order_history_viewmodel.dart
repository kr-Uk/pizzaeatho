import 'package:flutter/material.dart';
import 'package:pizzaeatho/data/model/comment.dart';
import 'package:pizzaeatho/data/model/enums.dart';
import 'package:pizzaeatho/data/repository/auth_repository.dart';
import '../../data/model/order.dart';
import '../../data/repository/comment_repository.dart';
import '../../data/repository/order_repository.dart';

class OrderHistoryViewModel with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  final AuthRepository _authRepository = AuthRepository();
  final CommentRepository _commentRepository = CommentRepository();

  List<OrderHistoryDto> _orderHistory = [];
  List<OrderHistoryDto> get orderHistory => _orderHistory;

  List<OrderHistoryDto> get activeOrders => _orderHistory
      .where((o) =>
          o.status == OrderStatus.received ||
          o.status == OrderStatus.cooking)
      .toList();

  List<OrderHistoryDto> get doneOrders =>
      _orderHistory.where((o) => o.status == OrderStatus.done).toList();

  String? get errorMessage => _errorMessage;
  String? _errorMessage;

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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _orderHistory = await _orderRepository.getOrderHistoryWithDetail(userId);
      if (_orderHistory.isEmpty) {
        _errorMessage = '주문 내역이 없습니다.';
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = '주문 내역을 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<OrderHistoryDetailDto>> fetchOrderDetails(int orderId) async {
    return _orderRepository.getOrderHistoryDetail(orderId);
  }

  Future<bool> addReview({
    required int userId,
    required int productId,
    required int orderDetailId,
    required int rating,
    required String comment,
  }) async {
    try {
      final request = CommentCreateRequestDto(
        userId: userId,
        productId: productId,
        orderDetailId: orderDetailId,
        rating: rating,
        comment: comment,
      );
      return await _commentRepository.createComment(request);
    } catch (_) {
      return false;
    }
  }

  void clearOrders() {
    _orderHistory.clear();
    notifyListeners();
  }
}
