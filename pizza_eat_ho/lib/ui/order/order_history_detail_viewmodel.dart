import 'package:flutter/cupertino.dart';
import 'package:pizzaeatho/data/model/comment.dart';

import '../../data/model/order.dart';
import '../../data/repository/comment_repository.dart';
import '../../data/repository/order_repository.dart';

class OrderHistoryDetailViewModel with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  final CommentRepository _commentRepository = CommentRepository();

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
        _errorMessage = '주문 상세가 없습니다.';
      }
    } catch (e) {
      _errorMessage = '주문 상세를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
}
