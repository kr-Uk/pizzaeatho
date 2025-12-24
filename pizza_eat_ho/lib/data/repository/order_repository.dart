import '../datasource/local_datasource.dart';
import '../datasource/order_remote_datasource.dart';
import '../datasource/product_remote_datasource.dart';
import '../model/order.dart';
import '../model/product.dart';
import '../model/shoppingcart.dart';

class OrderRepository {
  final OrderRemoteDataSource _remoteDataSource = OrderRemoteDataSource();
  final LocalDataSource _localDataSource = LocalDataSource();
  final ProductRemoteDataSource _productRemoteDataSource =
  ProductRemoteDataSource();

  Future<OrderCreateResponseDto> placeOrder(List<OrderCreateRequestDto> orders) async {
    return await _remoteDataSource.placeOrder(orders);
  }

  Future<List<UserOrderListItemDto>> getOrderHistory(int userId) async {
    return _remoteDataSource.getOrderHistory(userId);
  }

  Future<List<UserOrderListItemDto>> getOrderHistoryRecent(int userId) async {
    return _remoteDataSource.getOrderHistoryRecent(userId);
  }

  Future<List<OrderDetailResponseDto>> getOrderDetail(int orderId) async {
    return _remoteDataSource.getOrderDetail(orderId);
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

  Future<List<OrderHistoryDto>> getOrderHistoryWithDetail(int userId) async {
    // 1. 주문 목록
    final orders = await _remoteDataSource.getOrderHistory(userId);

    // 2. 상품 전체 목록
    final products = await _productRemoteDataSource.getProducts();

    // 3. productId → ProductDto Map
    final productMap = {
      for (final p in products) p.name: p
    };

    final List<OrderHistoryDto> result = [];

    // 4. 주문별 처리
    for (final order in orders) {
      final details = await _remoteDataSource.getOrderDetail(order.orderId);

      if (details.isEmpty) continue;

      final List<ProductDto> productList = [];

      for (final detail in details) {
        final productId = detail.product;
        final product = productMap[productId];

        if (product != null) {
          productList.add(product);
        }
      }

      result.add(
        OrderHistoryDto(
          orderId: order.orderId,
          products: productList,
          orderTime: order.orderTime,
          totalPrice: order.totalPrice,
          status: order.status,
        ),
      );
    }
    return result;
  }

  Future<List<OrderHistoryDetailDto>> getOrderHistoryDetail(int orderId) async {
    final orders = await _remoteDataSource.getOrderDetail(orderId);

    final products = await _productRemoteDataSource.getProducts();

    final productMap = {
      for (final p in products) p.name: p
    };

    final List<OrderHistoryDetailDto> result = [];

    for (final order in orders) {
      result.add(
        OrderHistoryDetailDto(
          orderId: order.orderId,
          product: productMap[order.product] as ProductDto,
          dough: order.dough,
          crust: order.crust,
          toppings: order.toppings,
          unitPrice: order.unitPrice,
          status: order.status,
        ),
      );
    }
    return result;
  }
}
