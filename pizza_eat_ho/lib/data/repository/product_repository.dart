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

  // 피자 메뉴 갖고오기
  Future<List<ProductDto>> getProducts() {
    return _remoteDataSource.getProducts();
  }

  // 토핑 목록 갖고오기
  Future<List<ToppingDto>> getToppings() {
    return _remoteDataSource.getToppings();
  }

  // 도우 목록 갖고오기
  Future<List<DoughDto>> getDoughs() {
    return _remoteDataSource.getDoughs();
  }

  // 크로스트 목록 갖고오기
  Future<List<CrustDto>> getCrusts() {
    return _remoteDataSource.getCrusts();
  }
}
