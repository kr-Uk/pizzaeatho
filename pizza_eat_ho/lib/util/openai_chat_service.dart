import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAiChatService {
  OpenAiChatService({
    required this.apiKey,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String apiKey;
  final http.Client _client;

  static const String _endpoint =
      'https://gms.ssafy.io/gmsapi/api.openai.com/v1/chat/completions';

  Future<String> sendMessage({
    required List<Map<String, String>> messages,
  }) async {
    final response = await _client.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4o',
        'temperature': 0.6,
        'messages': messages,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('OpenAI error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>;
    if (choices.isEmpty) {
      throw Exception('OpenAI response is empty');
    }

    final message = choices.first['message'] as Map<String, dynamic>;
    return (message['content'] as String).trim();
  }
}
