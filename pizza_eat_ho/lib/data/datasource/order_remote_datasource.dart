import 'dart:convert';

import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/model/user.dart';

class OrderRemoteDataSource {

  // POST /pizza/order (List<OrderCreateRequestDto> -> OrderCreateResponseDto)
  Future<OrderCreateResponseDto> placeOrder(List<OrderCreateRequestDto> orderRequest) async {
    final server = """
        {
          "orderId": 10,
          "status": "RECEIVED"
        }
    """;

    final Map<String, dynamic> jsonMap = jsonDecode(server);
    final order = OrderCreateResponseDto.fromJson(jsonMap);
    return order;
  }

  // GET /pizza/order/user/{userId} (-> List<UserOrderListItemDto>)
  Future<List<UserOrderListItemDto>> getOrderHistory(int userId) async {
    final server = """
    [
      {
        "orderId": 10,
        "orderTime": "2025-09-19T12:30:00",
        "status": "COOKING",
        "totalPrice": 12700
      }
    ]
  """;

    final List<dynamic> jsonList = jsonDecode(server);

    final orderHistory = jsonList
        .map((e) => UserOrderListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return orderHistory;

  }

  // GET /pizza/order/{orderId} (-> List<UserOrderListItemDto>)
  Future<List<OrderDetailResponseDto>> getOrderDetail(int orderId) async {
    final server = """
    [
{
  "orderId": 10,
  "product": "불고기 피자",
  "dough": "오리지널",
  "crust": "치즈 크러스트",
  "toppings": [
    { "name": "불고기", "quantity": 1 },
    { "name": "올리브", "quantity": 1 }
  ],
  "unitPrice": 12700,
  "status": "DONE"
}
]
  """;

    final List<dynamic> jsonList = jsonDecode(server);

    final orderDetail = jsonList
        .map((e) => OrderDetailResponseDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return orderDetail;
  }

  // GET /pizza/order/user/{userId}/recent6months (-> List<UserOrderListItemDto>)
  Future<List<UserOrderListItemDto>> getOrderHistoryRecent(int userId) async {
    final server = """
    [
      {
        "orderId": 10,
        "orderTime": "2025-09-19T12:30:00",
        "status": "COOKING",
        "totalPrice": 12700
      }
    ]
  """;

    final List<dynamic> jsonList = jsonDecode(server);

    final orderHistory = jsonList
        .map((e) => UserOrderListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return orderHistory;
  }

  // GET /pizza/order/user/{userId}/status (-> List<UserOrderListItemDto>)
  Future<List<UserOrderListItemDto>> getUserOrderStatus(int userId) async {
    final server = """
    [
      {
        "orderId": 10,
        "orderTime": "2025-09-19T12:30:00",
        "status": "COOKING",
        "totalPrice": 12700
      }
    ]
  """;

    final List<dynamic> jsonList = jsonDecode(server);

    final orderHistory = jsonList
        .map((e) => UserOrderListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return orderHistory;
  }

}
