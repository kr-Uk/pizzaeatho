import 'package:pizzaeatho/data/model/product.dart';

import 'enums.dart';

class OrderCreateToppingReqDto {
  final int toppingId;
  final int quantity;

  OrderCreateToppingReqDto({
    required this.toppingId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'toppingId': toppingId,
    'quantity': quantity,
  };
}

// 주문 넣기
class OrderCreateRequestDto {
  final int userId;
  final String userName;
  final int productId;
  final int doughId;
  final int crustId;
  final List<OrderCreateToppingReqDto> toppings;
  final int unitPrice;
  final String? fcmToken;

  OrderCreateRequestDto({
    required this.userId,
    required this.userName,
    required this.productId,
    required this.doughId,
    required this.crustId,
    required this.toppings,
    required this.unitPrice,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'productId': productId,
      'doughId': doughId,
      'crustId': crustId,
      'toppings': toppings.map((e) => e.toJson()).toList(),
      'unitPrice': unitPrice,
    };
    if (fcmToken != null && fcmToken!.isNotEmpty) {
      json['fcmToken'] = fcmToken;
    }
    return json;
  }
}

// 주문 넣기 응답
class OrderCreateResponseDto {
  final int orderId;
  final OrderStatus status;

  OrderCreateResponseDto({
    required this.orderId,
    required this.status,
  });

  factory OrderCreateResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderCreateResponseDto(
      orderId: (json['orderId'] as num).toInt(),
      status: OrderStatus.fromJson(json['status'] as String),
    );
  }
}


// 사용자 주문 목록 조회 응답
class UserOrderListItemDto {
  final int orderId;
  final DateTime orderTime;
  final OrderStatus status;
  final int totalPrice;

  UserOrderListItemDto({
    required this.orderId,
    required this.orderTime,
    required this.status,
    required this.totalPrice,
  });

  factory UserOrderListItemDto.fromJson(Map<String, dynamic> json) {
    return UserOrderListItemDto(
      orderId: (json['orderId'] as num).toInt(),
      orderTime: DateTime.parse(json['orderTime'] as String),
      status: OrderStatus.fromJson(json['status'] as String),
      totalPrice: (json['totalPrice'] as num).toInt(),
    );
  }
}

// 디테일 토핑 DTO
class OrderDetailToppingDto {
  final String name;
  final int quantity;

  OrderDetailToppingDto({
    required this.name,
    required this.quantity,
  });

  factory OrderDetailToppingDto.fromJson(Map<String, dynamic> json) {
    return OrderDetailToppingDto(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );
  }
}

// 주문 상세 조회 응답
class OrderDetailResponseDto {
  final int orderId;
  final int orderDetailId;
  final int productId;
  final String product;
  final String dough;
  final String crust;
  final List<OrderDetailToppingDto> toppings;
  final int unitPrice;
  final OrderStatus status;

  OrderDetailResponseDto({
    required this.orderId,
    required this.orderDetailId,
    required this.productId,
    required this.product,
    required this.dough,
    required this.crust,
    required this.toppings,
    required this.unitPrice,
    required this.status,
  });

  factory OrderDetailResponseDto.fromJson(Map<String, dynamic> json) {
    final toppingsJson = (json['toppings'] as List<dynamic>? ?? const []);
    return OrderDetailResponseDto(
      orderId: (json['orderId'] as num).toInt(),
      orderDetailId: (json['orderDetailId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      product: json['product'] as String,
      dough: json['dough'] as String,
      crust: json['crust'] as String,
      toppings: toppingsJson
          .map((e) => OrderDetailToppingDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitPrice: (json['unitPrice'] as num).toInt(),
      status: OrderStatus.fromJson(json['status'] as String),
    );
  }
}

// 주문 내역 상세 조회
class OrderHistoryDetailDto {
  final int orderId;
  final int orderDetailId;
  final int productId;
  final ProductDto product;
  final String dough;
  final String crust;
  final List<OrderDetailToppingDto> toppings;
  final int unitPrice;
  final OrderStatus status;

  OrderHistoryDetailDto({
    required this.orderId,
    required this.orderDetailId,
    required this.productId,
    required this.product,
    required this.dough,
    required this.crust,
    required this.toppings,
    required this.unitPrice,
    required this.status,
  });
}

// 주문 상태 변경 요청 (관리자)
class OrderStatusPatchRequestDto {
  final OrderStatus status;

  OrderStatusPatchRequestDto({required this.status});

  Map<String, dynamic> toJson() => {
    'status': status.toJson(),
  };
}

// 주문 상태 변경 응답 (관리자)
class OrderStatusPatchResponseDto {
  final int orderId;
  final OrderStatus status;

  OrderStatusPatchResponseDto({
    required this.orderId,
    required this.status,
  });

  factory OrderStatusPatchResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderStatusPatchResponseDto(
      orderId: (json['orderId'] as num).toInt(),
      status: OrderStatus.fromJson(json['status'] as String),
    );
  }
}

class OrderHistoryDto {
  final int orderId;
  final List<ProductDto> products;
  final DateTime orderTime;
  final OrderStatus status;
  final int totalPrice;

  OrderHistoryDto({
    required this.orderId,
    required this.products,
    required this.orderTime,
    required this.status,
    required this.totalPrice,
  });
}


