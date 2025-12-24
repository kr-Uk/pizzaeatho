import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class OnDeviceAiService {
  static const MethodChannel _channel =
      MethodChannel('pizzaeatho/on_device_ai');
  static const String _modelPath =
      '/data/data/com.example.pizzaeatho/files/gemma-3n-E2B-it-int4.litertlm';

  static const String _systemPrompt =
      '너는 “피짜잇호”의 피자 토핑 추천 AI다. 반드시 한국어로 답한다.\n'
      '아래는 매장에서 제공 가능한 옵션 목록이다.\n\n'
      '[토핑]\n'
      '- 페퍼로니(1200), 베이컨(1300), 버섯(800), 양파(600), 올리브(700), 파인애플(900), 할라피뇨(700), 치즈 추가(1500)\n\n'
      '[도우]\n'
      '- 오리지널(0), 씬 크러스트(0), 치즈 크러스트(2000), 고구마 크러스트(2000), 치즈 바이트(2500)\n\n'
      '[크러스트]\n'
      '- 기본 크러스트(0), 치즈 크러스트(3000), 고구마 크러스트(3000), 갈릭 크러스트(2500), 치즈 바이트(3500)\n\n'
      '사용자에게 먼저 다음을 간단히 확인하라:\n'
      '1) 알레르기/제외할 재료\n'
      '2) 매운맛 선호(없음/약간/강함)\n'
      '3) 고기 vs 채식 선호\n'
      '4) 치즈 선호(기본/많이)\n'
      '5) 소스나 식감 선호(촉촉/바삭/달콤/짭짤 등)\n\n'
      '추천 규칙:\n'
      '- 추천은 2~3가지 조합을 제안한다.\n'
      '- 각 조합은 토핑 2~4개로 구성한다.\n'
      '- 각 조합에는 간단한 도우 1개와 크러스트 1개를 포함한다.\n'
      '- 각 조합마다 한 줄로 추천 이유를 설명한다.\n'
      '- 위 목록에 없는 재료는 절대 추천하지 않는다.\n'
      '- 마지막에 한 줄로 추가 선호를 질문한다.\n\n'
      '응답 포맷:\n'
      '1) 조합명: 토핑/도우/크러스트 ? 이유 한 줄\n'
      '2) 조합명: ...\n'
      '3) 조합명: ...\n'
      '마지막 줄: “더 원하는 맛(매운맛/달콤함/고기/채식 등)이 있나요?”';

  Future<String> sendMessage({
    required List<Map<String, String>> messages,
    required String userText,
  }) async {
    final prompt = _buildPrompt(messages);

    try {
      final response = await _channel.invokeMethod<String>('generate', {
        'prompt': prompt,
        'modelPath': _modelPath,
        'maxTokens': 256,
        'temperature': 0.6,
      });
      if (response != null && response.trim().isNotEmpty) {
        return response.trim();
      }
    } catch (e) {
      debugPrint('On-device AI failed: $e');
    }

    return _fallbackReply(userText);
  }

  String _buildPrompt(List<Map<String, String>> messages) {
    final buffer = StringBuffer(_systemPrompt);
    buffer.writeln();
    for (final msg in messages) {
      final role = msg['role'] ?? '';
      final content = msg['content'] ?? '';
      if (role == 'user') {
        buffer.writeln('User: $content');
      } else if (role == 'assistant') {
        buffer.writeln('Assistant: $content');
      }
    }
    buffer.writeln('Assistant:');
    return buffer.toString();
  }

  String _fallbackReply(String userText) {
    final text = userText.toLowerCase();
    final wantsSpicy = text.contains('매운') || text.contains('매콤');
    final wantsSweet = text.contains('달콤') || text.contains('단맛');
    final wantsMeat = text.contains('고기') || text.contains('페퍼로니') || text.contains('베이컨');
    final wantsVeggie = text.contains('채식') || text.contains('야채') || text.contains('버섯');
    final wantsCheese = text.contains('치즈');

    final combo1Toppings = <String>[
      if (wantsMeat) '페퍼로니',
      if (wantsMeat) '베이컨',
      if (!wantsMeat) '버섯',
      '양파',
      if (wantsSpicy) '할라피뇨',
      if (wantsSweet) '파인애플',
      if (wantsCheese) '치즈 추가',
    ].where((t) => t.isNotEmpty).toList();

    final combo2Toppings = <String>[
      '버섯',
      '양파',
      '올리브',
      if (wantsSweet) '파인애플',
      if (wantsSpicy) '할라피뇨',
      if (wantsCheese) '치즈 추가',
    ];

    final combo3Toppings = <String>[
      '페퍼로니',
      '올리브',
      if (wantsSpicy) '할라피뇨',
      if (wantsCheese) '치즈 추가',
    ];

    final buffer = StringBuffer();
    buffer.writeln(
      '1) 클래식 밸런스: ${combo1Toppings.take(4).join("/")}/오리지널/기본 크러스트 ? '
      '고기와 채소의 균형에 맞춘 조합입니다.',
    );
    buffer.writeln(
      '2) 베지 라이트: ${combo2Toppings.take(4).join("/")}/씬 크러스트/갈릭 크러스트 ? '
      '${wantsVeggie ? "채식" : "담백"} 위주의 산뜻한 맛입니다.',
    );
    buffer.writeln(
      '3) 스파이시 치즈: ${combo3Toppings.take(4).join("/")}/치즈 크러스트/치즈 바이트 ? '
      '${wantsSpicy ? "매콤함" : "짭짤함"}과 치즈 풍미를 살렸어요.',
    );
    buffer.writeln('더 원하는 맛(매운맛/달콤함/고기/채식 등)이 있나요?');

    return buffer.toString();
  }
}
