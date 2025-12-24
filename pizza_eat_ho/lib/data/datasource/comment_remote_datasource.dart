import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../util/common.dart';
import '../model/comment.dart';

class CommentRemoteDataSource {
  final String endPoint = "pizza/comment";

  Future<List<ProductCommentDto>> getProductComment(int productId) async {
    final url = Uri.http(IP_PORT, "$endPoint/product/$productId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load comments');
    }

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList
        .map((e) => ProductCommentDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> createComment(CommentCreateRequestDto request) async {
    final url = Uri.http(IP_PORT, endPoint);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create comment');
    }

    final decoded = jsonDecode(response.body);
    return CommentCreateResponseDto.fromJson(decoded).success;
  }

  Future<bool> updateComment(
    int commentId,
    int userId,
    CommentUpdateRequestDto request,
  ) async {
    final url = Uri.http(IP_PORT, "$endPoint/$commentId/user/$userId");

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update comment');
    }

    return _parseBoolean(response.body);
  }

  Future<bool> deleteComment(int commentId, int userId) async {
    final url = Uri.http(IP_PORT, "$endPoint/$commentId/user/$userId");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }

    return _parseBoolean(response.body);
  }

  bool _parseBoolean(String body) {
    final decoded = jsonDecode(body);
    if (decoded is bool) return decoded;
    if (decoded is Map<String, dynamic> && decoded['success'] is bool) {
      return decoded['success'] as bool;
    }
    throw ArgumentError('Unexpected boolean response: $decoded');
  }
}
