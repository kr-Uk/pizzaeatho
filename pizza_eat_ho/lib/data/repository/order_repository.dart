import '../datasource/local_datasource.dart';
import '../datasource/order_remote_datasource.dart';
import '../model/order.dart';
import '../model/shoppingcart.dart';

class OrderRepository {
  final OrderRemoteDataSource _remoteDataSource = OrderRemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<OrderCreateResponseDto> placeOrder(List<OrderCreateRequestDto> orders) async {
    return await _remoteDataSource.placeOrder(orders);
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
