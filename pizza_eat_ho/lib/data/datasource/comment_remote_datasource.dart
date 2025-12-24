import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pizzaeatho/data/model/comment.dart';

import '../../util/common.dart';

class CoomentRemoteDataSource {
  final String END_POINT = "pizza/comment";

  /* 갖고오기 */
  // GET /pizza/comment/product/productId
  Future<List<ProductCommentDto>> getProductComment(int productId) async{
    final url = Uri.http(IP_PORT, "${END_POINT}/product/${productId}");

    final response = await http.get(
      url,
    );

    // 실패시
    if (response.statusCode != 200) {
      print(response.statusCode);
      throw Exception('갖고오기 실패');
    }

    // json String -> list<map<~>>
    final List<dynamic> jsonList =
    jsonDecode(response.body);

    final comments = jsonList
        .map((e) => ProductCommentDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return comments;
  }

}