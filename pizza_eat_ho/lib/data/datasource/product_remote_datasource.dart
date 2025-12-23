import 'dart:convert';

import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/model/user.dart';

class ProductRemoteDataSource {
  // GET /pizza/product ( -> List<ProductDto>)
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

  // GET /pizza/product/{productId}/default-topping (->List<ToppingDto>)
  Future<DefaultTopping> getDefaultToppings() async {
    final server = '''
{
  "toppingId": [1, 2, 3, 4]
}
''';

    final Map<String, dynamic> jsonMap = jsonDecode(server);

    final DefaultTopping result =
    DefaultTopping.fromJson(jsonMap);

    return result;
  }

  // GET /pizza/product/topping (-> List<ToppingDto>)
  Future<List<ToppingDto>> getToppings() async {
    final server = """
          [
            {
              "toppingId": 1,
              "image": "url",
              "name": "페퍼로니",
              "price": 1200
            },
            {
              "toppingId": 2,
              "image": "url",
              "name": "베이컨",
              "price": 1300
            },
            {
              "toppingId": 3,
              "image": "url",
              "name": "버섯",
              "price": 800
            },
            {
              "toppingId": 4,
              "image": "url",
              "name": "양파",
              "price": 600
            },
            {
              "toppingId": 5,
              "image": "url",
              "name": "올리브",
              "price": 700
            },
            {
              "toppingId": 6,
              "image": "url",
              "name": "파인애플",
              "price": 900
            },
            {
              "toppingId": 7,
              "image": "url",
              "name": "할라피뇨",
              "price": 700
            },
            {
              "toppingId": 8,
              "image": "url",
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

  // GET /pizza/product/dough (-> List<DoughDto>)
  Future<List<DoughDto>> getDoughs() async {
    final server = """
          [
            {
              "doughId": 1,
              "image": "url",
              "name": "오리지널",
              "price": 0
            },
            {
              "doughId": 2,
              "image": "url",
              "name": "씬 크러스트",
              "price": 0
            },
            {
              "doughId": 3,
              "image": "url",
              "name": "치즈 크러스트",
              "price": 2000
            },
            {
              "doughId": 4,
              "image": "url",
              "name": "고구마 크러스트",
              "price": 2000
            },
            {
              "doughId": 5,
              "image": "url",
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

  // GET /pizza/product/crust (->List<CrustDto>)
  Future<List<CrustDto>> getCrusts() async {
    final server = """
          [
            {
              "crustId": 1,
              "image": "url",
              "name": "기본 크러스트",
              "price": 0
            },
            {
              "crustId": 2,
              "image": "url",
              "name": "치즈 크러스트",
              "price": 3000
            },
            {
              "crustId": 3,
              "image": "url",
              "name": "고구마 크러스트",
              "price": 3000
            },
            {
              "crustId": 4,
              "image": "url",
              "name": "갈릭 크러스트",
              "price": 2500
            },
            {
              "crustId": 5,
              "image": "url",
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
}
