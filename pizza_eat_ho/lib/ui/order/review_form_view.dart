import 'package:flutter/material.dart';
import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:provider/provider.dart';

import 'review_form_viewmodel.dart';

class ReviewFormView extends StatefulWidget {
  const ReviewFormView({super.key});

  @override
  State<ReviewFormView> createState() => _ReviewFormViewState();
}

class _ReviewFormViewState extends State<ReviewFormView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ReviewFormViewModel>();
    _controller = TextEditingController(text: viewModel.comment);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReviewFormViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.isEdit ? '리뷰 수정' : '리뷰 작성'),
        backgroundColor: redBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductSection(viewModel),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: viewModel.rating,
                decoration: const InputDecoration(
                  labelText: '평점',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}점'),
                  ),
                ),
                onChanged: viewModel.isSubmitting
                    ? null
                    : (value) {
                        if (value == null) return;
                        viewModel.setRating(value);
                      },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                maxLines: 4,
                onChanged: viewModel.setComment,
                decoration: const InputDecoration(
                  labelText: '한줄평',
                  hintText: '한줄평을 입력해주세요.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isSubmitting
                      ? null
                      : () async {
                          final success = await viewModel.submit();
                          if (!context.mounted) return;
                          if (success) {
                            Navigator.pop(context, true);
                            return;
                          }
                          final message = viewModel.errorMessage;
                          if (message != null && message.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redBackground,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(viewModel.isEdit ? '수정 완료' : '등록'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection(ReviewFormViewModel viewModel) {
    if (viewModel.canSelectProduct) {
      return DropdownButtonFormField<OrderHistoryDetailDto>(
        value: viewModel.selected,
        decoration: const InputDecoration(
          labelText: '리뷰할 메뉴',
          border: OutlineInputBorder(),
        ),
        items: viewModel.options
            .map(
              (detail) => DropdownMenuItem<OrderHistoryDetailDto>(
                value: detail,
                child: Text(detail.product.name),
              ),
            )
            .toList(),
        onChanged: viewModel.isSubmitting
            ? null
            : (value) {
                if (value == null) return;
                viewModel.selectProduct(value);
              },
      );
    }

    return InputDecorator(
      decoration: const InputDecoration(
        labelText: '리뷰할 메뉴',
        border: OutlineInputBorder(),
      ),
      child: Text(
        viewModel.productName.isEmpty ? '-' : viewModel.productName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
