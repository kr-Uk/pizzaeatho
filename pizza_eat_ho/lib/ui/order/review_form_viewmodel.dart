import 'package:flutter/foundation.dart';
import 'package:pizzaeatho/data/model/comment.dart';
import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/repository/comment_repository.dart';

enum ReviewFormMode { create, edit }

class ReviewFormViewModel extends ChangeNotifier {
  ReviewFormViewModel._({
    required this.mode,
    required this.userId,
    required List<OrderHistoryDetailDto> options,
    OrderHistoryDetailDto? selected,
    String? productName,
    int? commentId,
    int initialRating = 5,
    String initialComment = '',
  })  : _options = options,
        _selected = selected,
        _productName = productName,
        _commentId = commentId,
        _rating = initialRating,
        _comment = initialComment;

  factory ReviewFormViewModel.create({
    required int userId,
    required List<OrderHistoryDetailDto> options,
  }) {
    final selected = options.isNotEmpty ? options.first : null;
    return ReviewFormViewModel._(
      mode: ReviewFormMode.create,
      userId: userId,
      options: options,
      selected: selected,
      initialRating: 5,
      initialComment: '',
    );
  }

  factory ReviewFormViewModel.edit({
    required int userId,
    required int commentId,
    required String productName,
    required int rating,
    required String comment,
  }) {
    return ReviewFormViewModel._(
      mode: ReviewFormMode.edit,
      userId: userId,
      options: const [],
      productName: productName,
      commentId: commentId,
      initialRating: rating,
      initialComment: comment,
    );
  }

  final CommentRepository _commentRepository = CommentRepository();
  final ReviewFormMode mode;
  final int userId;

  final List<OrderHistoryDetailDto> _options;
  OrderHistoryDetailDto? _selected;
  final String? _productName;
  final int? _commentId;

  int _rating;
  String _comment;
  bool _isSubmitting = false;
  String? _errorMessage;

  List<OrderHistoryDetailDto> get options => _options;
  OrderHistoryDetailDto? get selected => _selected;
  int get rating => _rating;
  String get comment => _comment;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  bool get isEdit => mode == ReviewFormMode.edit;
  bool get canSelectProduct => mode == ReviewFormMode.create && _options.length > 1;
  String get productName {
    if (isEdit) {
      return _productName ?? '';
    }
    return _selected?.product.name ?? '';
  }

  void selectProduct(OrderHistoryDetailDto detail) {
    _selected = detail;
    notifyListeners();
  }

  void setRating(int value) {
    _rating = value;
    notifyListeners();
  }

  void setComment(String value) {
    _comment = value;
  }

  Future<bool> submit() async {
    final trimmed = _comment.trim();
    if (trimmed.isEmpty) {
      _errorMessage = '리뷰 내용을 입력해주세요.';
      notifyListeners();
      return false;
    }

    if (!isEdit && _selected == null) {
      _errorMessage = '리뷰할 메뉴를 선택해주세요.';
      notifyListeners();
      return false;
    }

    _errorMessage = null;
    _isSubmitting = true;
    notifyListeners();

    try {
      if (isEdit) {
        final commentId = _commentId;
        if (commentId == null) {
          _errorMessage = '수정 대상이 없습니다.';
          return false;
        }
        final request = CommentUpdateRequestDto(
          rating: _rating,
          comment: trimmed,
        );
        return await _commentRepository.updateComment(
          commentId,
          userId,
          request,
        );
      }

      final selected = _selected!;
      final request = CommentCreateRequestDto(
        userId: userId,
        productId: selected.productId,
        orderDetailId: selected.orderDetailId,
        rating: _rating,
        comment: trimmed,
      );
      return await _commentRepository.createComment(request);
    } catch (_) {
      _errorMessage = isEdit ? '리뷰 수정에 실패했습니다.' : '리뷰 등록에 실패했습니다.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
