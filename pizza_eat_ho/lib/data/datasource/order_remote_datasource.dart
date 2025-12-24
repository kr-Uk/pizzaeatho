import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/model/user.dart';

import '../../util/common.dart';

class OrderRemoteDataSource {
  final String END_POINT = "pizza/order";

  /* 주문하기 */
  // POST /pizza/order (List<OrderCreateRequestDto> -> OrderCreateResponseDto)
  Future<OrderCreateResponseDto> placeOrder(List<OrderCreateRequestDto> request) async {
    final url = Uri.http(IP_PORT, "${END_POINT}");

    final response = await http.post(
      url,
      // json 형식이라고 알려줘야 함
      headers: {
        'Content-Type': 'application/json',
      },
      // DTO -> map -> json string
      body: jsonEncode(
        request.map((e) => e.toJson()).toList(),
      ),
    );

    // 실패시
    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('주문생성 실패');
    }

    // json은 request.body에 json String -> map
    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    // map -> DTO
    return OrderCreateResponseDto.fromJson(json);
  }

  /* 주문현황 */
  // GET /pizza/order/user/{userId} (-> List<UserOrderListItemDto>)
  Future<List<UserOrderListItemDto>> getOrderHistory(int userId) async {
    final url = Uri.http(IP_PORT, "${END_POINT}/user/${userId}");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('주문현황 실패');
    }

    // json String -> Map의 List로
    final List<dynamic> jsonList = jsonDecode(response.body);
    // 각각 Map을 Dto로 변환 후 List로 묶기
    final orderHistory = jsonList
      .map((e) => UserOrderListItemDto.fromJson(e as Map<String, dynamic>))
      .toList();

    return orderHistory;
  }

  /* ???: ?? ?? */
  // GET /pizza/order (-> List<UserOrderListItemDto>)
  Future<List<UserOrderListItemDto>> getAllOrders() async {
    final url = Uri.http(IP_PORT, END_POINT);

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load orders');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList
        .map((e) => UserOrderListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }


  /* 주문 상세 */
  // GET /pizza/order/{orderId} (-> List<UserOrderListItemDto>)
  Future<List<OrderDetailResponseDto>> getOrderDetail(int orderId) async {
    final url = Uri.http(IP_PORT, "${END_POINT}/${orderId}");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      throw Exception('주문상세 실패');
    }

    // json String -> Map의 List로
    final List<dynamic> jsonList = jsonDecode(response.body);
    // 각각 Map을 Dto로 변환 후 List로 묶기
    final orderDetail = jsonList
      .map((e) => OrderDetailResponseDto.fromJson(e as Map<String, dynamic>))
      .toList();

    return orderDetail;
  }

  /* 주문 히스토리 */
  // GET /pizza/order/user/{userId}/recent6months (-> List<UserOrderListItemDto>)
  Future<List<UserOrderListItemDto>> getOrderHistoryRecent(int userId) async {
    final url = Uri.http(IP_PORT, "${END_POINT}/user/${userId}/recent6months");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      throw Exception('최근 주문현황 실패');
    }

    // json String -> Map의 List로
    final List<dynamic> jsonList = jsonDecode(response.body);
    // 각각 Map을 Dto로 변환 후 List로 묶기
    final orderHistory = jsonList
        .map((e) => UserOrderListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return orderHistory;
  }

  /* DONE이 아닌 Status */
  // GET /pizza/order/user/{userId}/status (-> List<UserOrderListItemDto>)
  Future<List<UserOrderListItemDto>> getUserOrderStatus(int userId) async {
    final url = Uri.http(IP_PORT, "${END_POINT}/user/${userId}/status");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      throw Exception('DONE이 아닌 주문현황 실패');
    }

    // json String -> Map의 List로
    final List<dynamic> jsonList = jsonDecode(response.body);
    // 각각 Map을 Dto로 변환 후 List로 묶기
    final orderHistory = jsonList
        .map((e) => UserOrderListItemDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return orderHistory;
  }

  /* ???: ?? ?? ?? */
  // PATCH /pizza/order/{orderId}/status (OrderStatusPatchRequestDto -> OrderStatusPatchResponseDto)
  Future<OrderStatusPatchResponseDto> updateOrderStatus(
      int orderId,
      OrderStatusPatchRequestDto request,
  ) async {
    final url = Uri.http(IP_PORT, "${END_POINT}/${orderId}/status");

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order status');
    }

    final Map<String, dynamic> json =
        jsonDecode(response.body) as Map<String, dynamic>;
    return OrderStatusPatchResponseDto.fromJson(json);
  }

}
