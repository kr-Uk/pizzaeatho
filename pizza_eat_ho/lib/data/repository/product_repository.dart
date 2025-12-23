import 'package:pizzaeatho/data/model/product.dart';

import '../datasource/local_datasource.dart';
import '../datasource/product_remote_datasource.dart';

class ProductRepository {
  final ProductRemoteDataSource _remoteDataSource = ProductRemoteDataSource();

  // 피자 메뉴 갖고오기
  Future<List<ProductDto>> getProducts() {
    return _remoteDataSource.getProducts();
  }

  // 피자 기본 토핑 갖고오기
  Future<DefaultTopping> getDefaultToppings() {
    return _remoteDataSource.getDefaultToppings();
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
