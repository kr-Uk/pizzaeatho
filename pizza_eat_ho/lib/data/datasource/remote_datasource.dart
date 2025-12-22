import 'dart:convert';

import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/model/user.dart';

class RemoteDataSource {

  Future<List<ProductDto>> getProducts() async {
    final server = """
          [
        {
          "productId": 1,
          "name": "포테이토 피자",
          "basePrice": 11000
        },
        {
          "productId": 5,
          "name": "커스텀 피자",
          "basePrice": 10000
        }
      ]
    """;

    final List<dynamic> jsonList = jsonDecode(server);

    final products = jsonList
        .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return products;

    return products;
    // const path = '/pizza/product';
    // const params = <String, String>{};
    // final uri = Uri.https("flutter_sample.com", path, params);
    // final res = await http.get(uri);
    // if (res.statusCode == HttpStatus.ok) {
    //   final data = _bytesToJson(res.bodyBytes) as List;
    //   return data.map((el) => Post.fromMap(el as Map)).toList();
    // } else {
    //   throw Exception("Error on server");
    // }
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

}
