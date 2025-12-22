import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';
import '../model/order.dart';

class OrderRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<bool> placeOrder(List<OrderCreateRequestDto> orders) async {
    final jsonList = orders.map((e) => e.toJson()).toList();
    return await _remoteDataSource.placeOrder(jsonList);
  }

  Future<List<UserOrderListItemDto>> getOrderHistory(int userId) async {
    return _remoteDataSource.getOrderHistory(userId);
  }

}
