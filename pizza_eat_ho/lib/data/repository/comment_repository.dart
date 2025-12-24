import 'package:pizzaeatho/data/model/comment.dart';

import '../datasource/comment_remote_datasource.dart';
import '../datasource/local_datasource.dart';

class CommentRepository {
  final CoomentRemoteDataSource _remoteDataSource = CoomentRemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<List<ProductCommentDto>> getProductComment(int productId) async {
    return await _remoteDataSource.getProductComment(productId);
  }
}