import 'dart:convert';

import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/model/user.dart';

class RemoteDataSource {
  // GET /pizza/product
  Future<List<ProductDto>> getProducts() async {
    final server = """
          [
        {
          "productId": 1,
          "name": "포테이토 피자",
          "description": "말해뭐해~ 최고의 피자",
          "price": 11000,
          "image": "assets/temp_pizza.jpg"
        },
        {
          "productId": 5,
          "name": "커스텀 피자",
          "description": "말해뭐해~ 최고의 피자 222",
          "price": 10000,
          "image": "assets/temp_pizza.jpg"
        }
      ]
    """;

    final List<dynamic> jsonList = jsonDecode(server);

    final products = jsonList
        .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return products;
  }

  // GET /pizza/product/topping
  Future<List<ToppingDto>> getToppings() async {
    final server = """
          [
            {
              "toppingId": 1,
              "name": "페퍼로니",
              "price": 1200
            },
            {
              "toppingId": 2,
              "name": "베이컨",
              "price": 1300
            },
            {
              "toppingId": 3,
              "name": "버섯",
              "price": 800
            },
            {
              "toppingId": 4,
              "name": "양파",
              "price": 600
            },
            {
              "toppingId": 5,
              "name": "올리브",
              "price": 700
            },
            {
              "toppingId": 6,
              "name": "파인애플",
              "price": 900
            },
            {
              "toppingId": 7,
              "name": "할라피뇨",
              "price": 700
            },
            {
              "toppingId": 8,
              "name": "치즈 추가",
              "price": 1500
            }
          ]
    """;

    final List<dynamic> jsonList = jsonDecode(server);

    final toppings = jsonList
        .map((e) => ToppingDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return toppings;
  }

  // GET /pizza/product/dough
  Future<List<DoughDto>> getDoughs() async {
    final server = """
          [
            {
              "doughId": 1,
              "name": "오리지널",
              "price": 0
            },
            {
              "doughId": 2,
              "name": "씬 크러스트",
              "price": 0
            },
            {
              "doughId": 3,
              "name": "치즈 크러스트",
              "price": 2000
            },
            {
              "doughId": 4,
              "name": "고구마 크러스트",
              "price": 2000
            },
            {
              "doughId": 5,
              "name": "치즈 바이트",
              "price": 2500
            }
          ]
    """;

    final List<dynamic> jsonList = jsonDecode(server);

    final doughs = jsonList
        .map((e) => DoughDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return doughs;
  }

  // GET /pizza/product/crust
  Future<List<CrustDto>> getCrusts() async {
    final server = """
          [
            {
              "crustId": 1,
              "name": "기본 크러스트",
              "price": 0
            },
            {
              "crustId": 2,
              "name": "치즈 크러스트",
              "price": 3000
            },
            {
              "crustId": 3,
              "name": "고구마 크러스트",
              "price": 3000
            },
            {
              "crustId": 4,
              "name": "갈릭 크러스트",
              "price": 2500
            },
            {
              "crustId": 5,
              "name": "치즈 바이트",
              "price": 3500
            }
          ]
    """;

    final List<dynamic> jsonList = jsonDecode(server);

    final crusts = jsonList
        .map((e) => CrustDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return crusts;
  }

  Future<bool> signup(UserSignupRequestDto request) async {
    return true;
  }

  Future<UserLoginResponseDto> login(UserLoginRequestDto request) async {
    final server = """
      {
        "userId": 1,
        "id": "id01",
        "pw": "pw01",
        "name": "grigjnrigjri",
        "stamp": 0
      }
    """;

    final Map<String, dynamic> json =
        jsonDecode(server) as Map<String, dynamic>;

    if (request.id != json['id'] || request.pw != json['pw']) {
      throw Exception('Invalid credentials');
    }

    final responseJson = <String, dynamic>{
      'userId': json['userId'],
      'name': json['name'],
      'stamp': json['stamp'],
    };

    return UserLoginResponseDto.fromJson(responseJson);
  }

  Future<bool> placeOrder(List<Map<String, dynamic>> orderRequest) async {
    final server = """
        {
          "orderId": 10,
          "status": "RECEIVED"
        }
    """;

    final Map<String, dynamic> jsonMap = jsonDecode(server);

    final order = OrderCreateResponseDto.fromJson(jsonMap);

    return true;

    // final response = await http.post(
    //   Uri.parse(_baseUrl),
    //   headers: {
    //     "Content-Type": "application/json",
    //   },
    //   body: jsonEncode(orderRequest),
    // );
    //
    // if (response.statusCode != 200) {
    //   throw Exception("주문 실패");
    // }

  }

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
    // final response = await http.get(Uri.parse("https://.../orders/$userId"));
    // if (response.statusCode != 200) {
    //   throw Exception("Failed to fetch order history");
    // }
    // return jsonDecode(response.body) as List<dynamic>;
  }

}
