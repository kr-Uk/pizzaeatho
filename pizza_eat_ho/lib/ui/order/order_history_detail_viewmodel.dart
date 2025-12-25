import 'package:flutter/cupertino.dart';
import 'package:pizzaeatho/data/model/comment.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/model/shoppingcart.dart';

import '../../data/model/order.dart';
import '../../data/repository/comment_repository.dart';
import '../../data/repository/order_repository.dart';
import '../../data/repository/product_repository.dart';

class OrderHistoryDetailViewModel with ChangeNotifier {
  final OrderRepository _orderRepository = OrderRepository();
  final CommentRepository _commentRepository = CommentRepository();
  final ProductRepository _productRepository = ProductRepository();

  final int orderId;

  OrderHistoryDetailViewModel(this.orderId) {
    _init();
  }

  List<OrderHistoryDetailDto> _orderDetails = [];
  List<OrderHistoryDetailDto> get orderDetails => _orderDetails;

  List<DoughDto> _doughs = [];
  List<CrustDto> _crusts = [];
  List<ToppingDto> _toppings = [];

  bool get hasOptions => _doughs.isNotEmpty && _crusts.isNotEmpty;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> _init() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _orderRepository.getOrderHistoryDetail(orderId),
        _productRepository.getDoughs(),
        _productRepository.getCrusts(),
        _productRepository.getToppings(),
      ]);
      _orderDetails = results[0] as List<OrderHistoryDetailDto>;
      _doughs = results[1] as List<DoughDto>;
      _crusts = results[2] as List<CrustDto>;
      _toppings = results[3] as List<ToppingDto>;

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

  ShoppingcartDto? buildCartItem(OrderHistoryDetailDto detail) {
    final dough = _findDough(detail.dough);
    final crust = _findCrust(detail.crust);
    if (dough == null || crust == null) return null;

    final mappedToppings = <ToppingDto>[];
    for (final topping in detail.toppings) {
      final match = _findTopping(topping.name);
      if (match != null) {
        mappedToppings.add(match);
      }
    }

    return ShoppingcartDto(
      product: detail.product,
      dough: dough,
      crust: crust,
      toppings: mappedToppings,
      quantity: 1,
      totalPrice: detail.unitPrice,
    );
  }

  DoughDto? _findDough(String name) {
    for (final dough in _doughs) {
      if (dough.name == name) return dough;
    }
    return null;
  }

  CrustDto? _findCrust(String name) {
    for (final crust in _crusts) {
      if (crust.name == name) return crust;
    }
    return null;
  }

  ToppingDto? _findTopping(String name) {
    for (final topping in _toppings) {
      if (topping.name == name) return topping;
    }
    return null;
  }
}
