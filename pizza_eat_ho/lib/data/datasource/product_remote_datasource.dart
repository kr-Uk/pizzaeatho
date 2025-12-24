import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pizzaeatho/data/model/order.dart';
import 'package:pizzaeatho/data/model/product.dart';
import 'package:pizzaeatho/data/model/user.dart';

import '../../util/common.dart';

class ProductRemoteDataSource {
  final String END_POINT = "pizza/product";

  /* 제품 갖고오기 */
  // GET /pizza/product ( -> List<ProductDto>)
  Future<List<ProductDto>> getProducts() async {
    final url = Uri.http(IP_PORT, "${END_POINT}");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('제품 갖고오기 실패');
    }

    // json String -> list<map<~>>
    final List<dynamic> jsonList =
    jsonDecode(response.body);

    final products = jsonList
      .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
      .toList();

    return products;
  }

  /* 기본 체크 토핑 갖고오기 */
  // GET /pizza/product/{productId}/default-topping (->List<ToppingDto>)
  Future<DefaultTopping> getDefaultToppings(int productId) async {
    final url = Uri.http(IP_PORT, "${END_POINT}/${productId}/default-topping");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('기본 토핑 갖고오기 실패');
    }

    // json은 request.body에 json String -> map
    final Map<String, dynamic> json =
    jsonDecode(response.body) as Map<String, dynamic>;

    // map -> DTO
    return DefaultTopping.fromJson(json);
  }

  /* 토핑 목록 갖고오기 */
  // GET /pizza/product/topping (-> List<ToppingDto>)
  Future<List<ToppingDto>> getToppings() async {
    final url = Uri.http(IP_PORT, "${END_POINT}/topping");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('토핑목록 갖고오기 실패');
    }

    // json String -> list<map<~>>
    final List<dynamic> jsonList =
    jsonDecode(response.body);

    final toppings = jsonList
        .map((e) => ToppingDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return toppings;
  }

  /* 도우 목록 갖고오기 */
  // GET /pizza/product/dough (-> List<DoughDto>)
  Future<List<DoughDto>> getDoughs() async {
    final url = Uri.http(IP_PORT, "${END_POINT}/dough");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('도우 목록 갖고오기 실패');
    }

    // json String -> list<map<~>>
    final List<dynamic> jsonList =
    jsonDecode(response.body);

    final doughs = jsonList
        .map((e) => DoughDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return doughs;
  }

  /* 크러스트 목록 갖고오기 */
  // GET /pizza/product/crust (->List<CrustDto>)
  Future<List<CrustDto>> getCrusts() async {
    final url = Uri.http(IP_PORT, "${END_POINT}/crust");

    final response = await http.get(url);

    // 실패시
    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('크러스트 목록 갖고오기 실패');
    }

    // json String -> list<map<~>>
    final List<dynamic> jsonList =
    jsonDecode(response.body);

    final crusts = jsonList
        .map((e) => CrustDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return crusts;
  }
}
