import 'package:pizzaeatho/data/model/comment.dart';

import '../datasource/comment_remote_datasource.dart';

class CommentRepository {
  final CommentRemoteDataSource _remoteDataSource = CommentRemoteDataSource();

  Future<List<ProductCommentDto>> getProductComment(int productId) async {
    return _remoteDataSource.getProductComment(productId);
  }

  Future<bool> createComment(CommentCreateRequestDto request) async {
    return _remoteDataSource.createComment(request);
  }

  Future<bool> updateComment(
    int commentId,
    int userId,
    CommentUpdateRequestDto request,
  ) async {
    return _remoteDataSource.updateComment(commentId, userId, request);
  }

  Future<bool> deleteComment(int commentId, int userId) async {
    return _remoteDataSource.deleteComment(commentId, userId);
  }
}
