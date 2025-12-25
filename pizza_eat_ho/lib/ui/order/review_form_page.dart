import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/order.dart';
import 'review_form_view.dart';
import 'review_form_viewmodel.dart';

class ReviewFormPage extends StatelessWidget {
  const ReviewFormPage._(this._create, {super.key});

  final ReviewFormViewModel Function() _create;

  factory ReviewFormPage.create({
    required int userId,
    required List<OrderHistoryDetailDto> options,
  }) {
    return ReviewFormPage._(
      () => ReviewFormViewModel.create(
        userId: userId,
        options: options,
      ),
    );
  }

  factory ReviewFormPage.edit({
    required int userId,
    required int commentId,
    required String productName,
    required int rating,
    required String comment,
  }) {
    return ReviewFormPage._(
      () => ReviewFormViewModel.edit(
        userId: userId,
        commentId: commentId,
        productName: productName,
        rating: rating,
        comment: comment,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReviewFormViewModel>(
      create: (_) => _create(),
      child: const ReviewFormView(),
    );
  }
}
