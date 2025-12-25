import 'package:flutter/material.dart';
import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:provider/provider.dart';

import 'review_form_viewmodel.dart';

const Color _christmasGreen = redBackground;
const Color _snowBackground = Color(0xFFF9F6F1);

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
        title: Text(
          viewModel.isEdit ? '리뷰 수정' : '리뷰 작성',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFB91D2A),
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: _snowBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                '리뷰 정보',
                showAccent: false,
                showAccentLine: true,
              ),
              const SizedBox(height: 12),
              _buildCard(
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
                        labelText: '리뷰 내용',
                        hintText: '리뷰 내용을 입력해주세요.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
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

  Widget _buildSectionTitle(
    String title, {
    bool showAccent = true,
    bool showAccentLine = false,
  }) {
    final accentColor = showAccent ? _christmasGreen : Colors.transparent;

    return Row(
      children: [
        if (showAccentLine) ...[
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: _christmasGreen,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: redBackground,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: accentColor, width: 2),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 2,
            color: showAccentLine
                ? _christmasGreen.withOpacity(0.3)
                : (showAccent
                    ? _christmasGreen.withOpacity(0.3)
                    : Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
