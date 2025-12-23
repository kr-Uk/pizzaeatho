import '../datasource/local_datasource.dart';
import '../datasource/remote_datasource.dart';
import '../model/order.dart';
import '../model/shoppingcart.dart';

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

  Future<void> saveCart(int userId, List<ShoppingcartDto> items) async {
    await _localDataSource.saveCart(
      userId,
      items.map((e) => e.toJson()).toList(),
    );
  }

  Future<List<ShoppingcartDto>> loadCart(int userId) async {
    final jsonList = await _localDataSource.loadCart(userId);
    return jsonList.map(ShoppingcartDto.fromJson).toList();
  }

  Future<void> clearCart(int userId) async {
    await _localDataSource.clearCart(userId);
  }

}
