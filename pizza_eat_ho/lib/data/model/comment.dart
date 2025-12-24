class CommentCreateRequestDto {
  final int userId;
  final int productId;
  final int orderDetailId;
  final int rating;
  final String comment;

  CommentCreateRequestDto({
    required this.userId,
    required this.productId,
    required this.orderDetailId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'productId': productId,
        'orderDetailId': orderDetailId,
        'rating': rating,
        'comment': comment,
      };
}

class CommentCreateResponseDto {
  final bool success;

  CommentCreateResponseDto({required this.success});

  factory CommentCreateResponseDto.fromJson(dynamic json) {
    if (json is bool) return CommentCreateResponseDto(success: json);

    if (json is Map<String, dynamic> && json['success'] is bool) {
      return CommentCreateResponseDto(success: json['success'] as bool);
    }

    throw ArgumentError('Unexpected comment create response: $json');
  }
}

class CommentUpdateRequestDto {
  final int rating;
  final String comment;

  CommentUpdateRequestDto({
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'comment': comment,
      };
}

class ProductCommentDto {
  final int commentId;
  final int userId;
  final String userName;
  final int rating;
  final String comment;
  final String createdAt;

  ProductCommentDto({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ProductCommentDto.fromJson(Map<String, dynamic> json) {
    return ProductCommentDto(
      commentId: (json['commentId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}
