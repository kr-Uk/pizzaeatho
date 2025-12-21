import 'package:pizzaeatho/data/model/product.dart';

import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';

class ProductRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();

  /// 로컬에 캐싱된 게시물 목록가져옴
  // Future<List<Post>> getCachedPosts() {
  // return _localDataSource.getCachedPosts();
  // }

  /// 게시물 목록을 가져옴
  Future<List<ProductDto>> getProducts() {
    return _remoteDataSource.getProducts();
  }
}
