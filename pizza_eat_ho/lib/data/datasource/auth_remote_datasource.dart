import 'dart:convert';

import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:pizzaeatho/util/common.dart';

class AuthRemoteDataSource {
  final String END_POINT = "pizza/user";

  /* 회원가입 */
  // POST /pizza/user (UserSignupRequestDto -> bool)
  Future<bool> signup(UserSignupRequestDto request) async {

    final url = Uri.http(IP_PORT, "${END_POINT}");

    final response = await http.post(
      url,
      // json 형식이라고 알려줘야 함
      headers: {
        'Content-Type': 'application/json',
      },
      // DTO -> map -> json string
      body: jsonEncode(request.toJson()),
    );

    // 실패시
    if (response.statusCode != 200) {
      throw Exception('회원가입 실패');
    }

    return jsonDecode(response.body) as bool;

  }

  /* 로그인 */
  // POST /pizza/user/login (UserLoginRequestDto -> UserLoginResponseDto)
  Future<UserLoginResponseDto> login(UserLoginRequestDto request) async {

    final url = Uri.http(IP_PORT, "${END_POINT}/login");

    final response = await http.post(
      url,
      // json 형식이라고 알려줘야 함
      headers: {
        'Content-Type': 'application/json',
      },
      // DTO -> map -> json string
      body: jsonEncode(request.toJson()),
    );

    // 실패시
    if (response.statusCode != 200) {
      throw Exception('로그인 실패');
    }

    // json은 request.body에 json String -> map
    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    // map -> DTO
    return UserLoginResponseDto.fromJson(json);

  }

  /* 사용자 정보 조회 */
  // GET /pizza/user/{userId} ( -> UserInfoResponseDto)
  Future<UserInfoResponseDto?> getUserInfo(String userId) async {

    final url = Uri.http(IP_PORT, "${END_POINT}/${userId}");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      throw Exception('사용자 정보 조회 실패');
    }

    // json은 request.body에 json String -> map
    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    // map -> DTO
    return UserInfoResponseDto.fromJson(json);
  }

  /* 아이디 중복체크 */
  // GET /pizza/user/checkid/{userId} (userId -> bool)
  Future<bool> checkUserId(String userId) async {

    final url = Uri.http(IP_PORT, "${END_POINT}/checkid/${userId}");

    final response = await http.post(url);

    // 실패시
    if (response.statusCode != 200) {
      throw Exception('아이디 중복 체크 실패');
    }

    return jsonDecode(response.body) as bool;
  }
}
