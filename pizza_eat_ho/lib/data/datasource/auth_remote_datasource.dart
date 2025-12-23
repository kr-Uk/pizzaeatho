import 'dart:convert';

import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/model/user.dart';

class AuthRemoteDataSource {

  // POST /pizza/user (UserSignupRequestDto -> bool)
  Future<bool> signup(UserSignupRequestDto request) async {
    return true;
  }

  // POST /pizza/user/login (UserLoginRequestDto -> UserLoginResponseDto)
  Future<UserLoginResponseDto> login(UserLoginRequestDto request) async {
    final server = """
      {
        "userId": 1,
        "id": "id01",
        "pw": "pw01",
        "name": "grigjnrigjri",
        "payment": 0
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
      'payment': json['payment'],
    };

    return UserLoginResponseDto.fromJson(responseJson);
  }

  // POST /pizza/user ( -> UserInfoResponseDto)
  Future<UserInfoResponseDto?> getUserInfo() async {
    return null;
  }

  Future<bool> checkUserId(String userId) async {
    return true;
  }

}
