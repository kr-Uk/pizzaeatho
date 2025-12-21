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

/// 명세: True/False
/// 서버가 JSON boolean(true/false)로 주는 경우를 가정
class CommentCreateResponseDto {
  final bool success;

  CommentCreateResponseDto({required this.success});

  factory CommentCreateResponseDto.fromJson(dynamic json) {
    // 서버가 그냥 true/false를 던지는 경우
    if (json is bool) return CommentCreateResponseDto(success: json);

    // 혹시 {"success": true} 같은 형태면 이것도 대응
    if (json is Map<String, dynamic> && json['success'] is bool) {
      return CommentCreateResponseDto(success: json['success'] as bool);
    }

    throw ArgumentError('Unexpected comment create response: $json');
  }
}

class ProductCommentDto {
  final String userName;
  final int rating;
  final String comment;
  final String createdAt; // 명세가 "2025-09-19" 형태라 string 유지

  ProductCommentDto({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ProductCommentDto.fromJson(Map<String, dynamic> json) {
    return ProductCommentDto(
      userName: json['userName'] as String,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}
