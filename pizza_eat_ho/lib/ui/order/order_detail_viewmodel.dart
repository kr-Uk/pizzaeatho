import 'package:flutter/cupertino.dart';
import 'package:pizzaeatho/data/model/comment.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/repository/comment_repository.dart';
import '../../data/repository/product_repository.dart';

class OrderDetailViewModel with ChangeNotifier {
  final int productId;

  late final ProductRepository _productRepository;
  late final CommentRepository _commentRepository;

  List<ProductCommentDto> _comments = [];
  List<ProductCommentDto> get comments => _comments;

  List<ToppingDto> _toppings = [];
  List<DoughDto> _doughs = [];
  List<CrustDto> _crusts = [];

  List<ToppingDto> get toppings => _toppings;
  List<DoughDto> get doughs => _doughs;
  List<CrustDto> get crusts => _crusts;

  DoughDto? selectedDough;
  CrustDto? selectedCrust;
  Set<int> selectedToppingIds = {};
  bool _defaultToppingsApplied = false;

  OrderDetailViewModel(this.productId) {
    _productRepository = ProductRepository();
    _commentRepository = CommentRepository();
    _loadComments();
    _loadToppings();
    _loadDefaultToppings();
    _loadDoughs();
    _loadCrusts();
  }

  Future<void> _loadComments() async {
    _comments = await _commentRepository.getProductComment(productId);
    notifyListeners();
  }

  Future<void> refreshComments() async {
    await _loadComments();
  }

  Future<bool> addComment(CommentCreateRequestDto request) async {
    try {
      final success = await _commentRepository.createComment(request);
      if (success) {
        await _loadComments();
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateComment(
    int commentId,
    int userId,
    CommentUpdateRequestDto request,
  ) async {
    try {
      final success = await _commentRepository.updateComment(
        commentId,
        userId,
        request,
      );
      if (success) {
        await _loadComments();
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteComment(int commentId, int userId) async {
    try {
      final success = await _commentRepository.deleteComment(commentId, userId);
      if (success) {
        await _loadComments();
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<void> _loadToppings() async {
    _toppings = await _productRepository.getToppings();
    notifyListeners();
  }

  Future<void> _loadDefaultToppings() async {
    try {
      final defaults = await _productRepository.getDefaultToppings(productId);
      if (_defaultToppingsApplied) return;
      if (selectedToppingIds.isEmpty) {
        selectedToppingIds = defaults.defaultTopping.toSet();
        _defaultToppingsApplied = true;
        notifyListeners();
      }
    } catch (_) {
      // Ignore if default toppings are unavailable.
    }
  }

  Future<void> _loadDoughs() async {
    _doughs = await _productRepository.getDoughs();
    notifyListeners();
  }

  Future<void> _loadCrusts() async {
    _crusts = await _productRepository.getCrusts();
    notifyListeners();
  }

  void selectDough(DoughDto dough) {
    selectedDough = dough;
    notifyListeners();
  }

  void selectCrust(CrustDto crust) {
    selectedCrust = crust;
    notifyListeners();
  }

  void toggleTopping(int toppingId) {
    if (selectedToppingIds.contains(toppingId)) {
      selectedToppingIds.remove(toppingId);
    } else {
      selectedToppingIds.add(toppingId);
    }
    notifyListeners();
  }

  List<ToppingDto> get selectedToppings {
    return toppings
        .where((topping) => selectedToppingIds.contains(topping.toppingId))
        .toList();
  }

  int totalPrice(int basePrice) {
    final doughPrice = selectedDough?.price ?? 0;
    final crustPrice = selectedCrust?.price ?? 0;

    final toppingsPrice = _toppings
        .where((t) => selectedToppingIds.contains(t.toppingId))
        .fold(0, (sum, t) => sum + t.price);

    return basePrice + doughPrice + crustPrice + toppingsPrice;
  }

  bool get isOptionValid => selectedDough != null && selectedCrust != null;
}
