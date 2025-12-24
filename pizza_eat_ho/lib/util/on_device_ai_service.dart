import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

class OnDeviceModelStatus {
  const OnDeviceModelStatus({
    required this.hasModel,
    required this.hasExternalData,
    required this.hasTokenizer,
    required this.isSupported,
    this.errorMessage,
  });

  final bool hasModel;
  final bool hasExternalData;
  final bool hasTokenizer;
  final bool isSupported;
  final String? errorMessage;

  bool get ready =>
      isSupported &&
      hasModel &&
      hasExternalData &&
      hasTokenizer &&
      errorMessage == null;
}

class OnDeviceAiService {
  OnDeviceAiService._();

  static final OnDeviceAiService instance = OnDeviceAiService._();

  static const String _modelAsset = 'assets/models/minilm_ir9.onnx';
  static const String _modelDataAsset = 'assets/models/minilm_ir9.onnx.data';
  static const String _tokenizerAsset = 'assets/models/tokenizer.json';

  OnDeviceModelStatus? _status;
  Future<OnDeviceModelStatus>? _initFuture;
  OrtSession? _session;
  _Tokenizer? _tokenizer;
  List<_ProfileEmbedding>? _profileEmbeddings;
  String? _modelPath;

  Future<OnDeviceModelStatus> ensureInitialized() {
    return _initFuture ??= _initialize();
  }

  Future<OnDeviceModelStatus> _initialize() async {
    try {
      final hasModel = await _assetExists(_modelAsset);
      final hasExternalData = await _assetExists(_modelDataAsset);
      final hasTokenizer = await _assetExists(_tokenizerAsset);

      if (kIsWeb) {
        _status = OnDeviceModelStatus(
          hasModel: hasModel,
          hasExternalData: hasExternalData,
          hasTokenizer: hasTokenizer,
          isSupported: false,
          errorMessage: 'Web 환경에서는 온디바이스 모델을 지원하지 않습니다.',
        );
        return _status!;
      }

      _status = OnDeviceModelStatus(
        hasModel: hasModel,
        hasExternalData: hasExternalData,
        hasTokenizer: hasTokenizer,
        isSupported: true,
      );
      if (!_status!.ready) {
        return _status!;
      }

      final modelDir = await _prepareModelFiles();
    _modelPath = '${modelDir.path}/minilm_ir9.onnx';
      _tokenizer = await _loadTokenizer();

      if (_session == null) {
        OrtEnv.instance.init();
        final options = OrtSessionOptions();
        options.setSessionGraphOptimizationLevel(
          GraphOptimizationLevel.ortEnableExtended,
        );
        _session = OrtSession.fromFile(File(_modelPath!), options);
        options.release();
      }

      _profileEmbeddings ??= await _buildProfileEmbeddings();
      return _status!;
    } catch (e) {
      debugPrint('On-device init failed: $e');
      final hasModel = await _assetExists(_modelAsset);
      final hasExternalData = await _assetExists(_modelDataAsset);
      final hasTokenizer = await _assetExists(_tokenizerAsset);
      _status = OnDeviceModelStatus(
        hasModel: hasModel,
        hasExternalData: hasExternalData,
        hasTokenizer: hasTokenizer,
        isSupported: true,
        errorMessage: '온디바이스 초기화 실패: $e',
      );
      return _status!;
    }
  }

  Future<String> recommend(String userText) async {
    await ensureInitialized();
    final status = _status;
    if (status == null || !status.ready) {
      return _buildDynamicReplyFromKeywords(userText);
    }

    try {
      if (_isSmallTalk(userText)) {
        return _buildSmallTalkReply(userText);
      }
      final embeddingResult = await _embedText(userText);
      final embedding = embeddingResult.vector;
      final encoding = embeddingResult.encoding;
      final unkRatio =
          encoding.tokenCount == 0 ? 1.0 : encoding.unkCount / encoding.tokenCount;
      final profiles = _profileEmbeddings ?? [];
      if (profiles.isEmpty) {
        return _buildDynamicReplyFromKeywords(userText);
      }

      final useKeywordOnly =
          _containsHangul(userText) || unkRatio > 0.6 || embedding.isEmpty;
      final scored = profiles
          .map((p) => _ScoredProfile(
                profile: p.profile,
                score: _combinedScore(
                  userText: userText,
                  profile: p.profile,
                  embeddingScore: useKeywordOnly
                      ? 0
                      : _cosineSimilarity(embedding, p.embedding),
                  useEmbedding: !useKeywordOnly,
                ),
              ))
          .toList();

      if (useKeywordOnly) {
        return _buildDynamicReplyFromKeywords(userText);
      }

      final ranked = _rankProfiles(userText, scored);
      return _buildProfileReply(ranked.take(3).toList());
    } catch (e) {
      debugPrint('On-device recommend failed: $e');
      return _buildDynamicReplyFromKeywords(userText);
    }
  }

  Future<Directory> _prepareModelFiles() async {
    final dir = Directory('${Directory.systemTemp.path}/pizzaeatho_onnx');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    await _copyAssetIfNeeded(
      _modelAsset,
      File('${dir.path}/minilm_ir9.onnx'),
    );
    await _copyAssetIfNeeded(
      _modelDataAsset,
      File('${dir.path}/minilm_ir9.onnx.data'),
    );
    await _copyAssetIfNeeded(
      _tokenizerAsset,
      File('${dir.path}/tokenizer.json'),
    );
    return dir;
  }

  Future<void> _copyAssetIfNeeded(String assetPath, File file) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    if (await file.exists()) {
      final stat = await file.stat();
      if (stat.size == bytes.length) {
        return;
      }
    }
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<_Tokenizer> _loadTokenizer() async {
    final jsonString = await rootBundle.loadString(_tokenizerAsset);
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return _Tokenizer.fromJson(data);
  }

  Future<_EmbeddingResult> _embedText(String text) async {
    final tokenizer = _tokenizer;
    final session = _session;
    if (tokenizer == null || session == null) {
      return const _EmbeddingResult.empty();
    }

    try {
      final encoding = tokenizer.encode(text);
      final inputIds = Int64List.fromList(encoding.inputIds);
      final attentionMask = Int64List.fromList(encoding.attentionMask);

      final inputIdsTensor = OrtValueTensor.createTensorWithDataList(
        inputIds,
        [1, inputIds.length],
      );
      final attentionMaskTensor = OrtValueTensor.createTensorWithDataList(
        attentionMask,
        [1, attentionMask.length],
      );

      final runOptions = OrtRunOptions();
      final outputs = session.run(
        runOptions,
        {
          'input_ids': inputIdsTensor,
          'attention_mask': attentionMaskTensor,
        },
        ['tanh'],
      );
      runOptions.release();

      inputIdsTensor.release();
      attentionMaskTensor.release();

      if (outputs.isEmpty || outputs.first is! OrtValueTensor) {
        outputs.whereType<OrtValue>().forEach((o) => o.release());
        return _EmbeddingResult(encoding: encoding, vector: const []);
      }

      final outputTensor = outputs.first as OrtValueTensor;
      final raw = outputTensor.value;
      outputTensor.release();

      if (raw is List && raw.isNotEmpty && raw.first is List) {
        return _EmbeddingResult(
          encoding: encoding,
          vector: (raw.first as List).cast<double>(),
        );
      }
      return _EmbeddingResult(encoding: encoding, vector: const []);
    } catch (e) {
      debugPrint('On-device embedding failed: $e');
      return const _EmbeddingResult.empty();
    }
  }

  Future<List<_ProfileEmbedding>> _buildProfileEmbeddings() async {
    final profiles = _profiles;
    final embeddings = <_ProfileEmbedding>[];
    for (final profile in profiles) {
      final result = await _embedText(profile.prompt);
      if (result.vector.isNotEmpty) {
        embeddings.add(
          _ProfileEmbedding(profile: profile, embedding: result.vector),
        );
      }
    }
    return embeddings;
  }

  String _buildProfileReply(List<_Profile> profiles) {
  if (profiles.isEmpty) {
    return '추천 조합을 준비 중이에요. 다른 취향을 알려주세요.';
  }
  final buffer = StringBuffer();
  final p = profiles.first;
  buffer.writeln(
    '1) ${p.title}: ${p.toppings.join("/")}/${p.dough}/${p.crust} - ${p.reason}',
  );
  buffer.writeln('더 원하는 맛(매운맛/달콤함/고기/채식 등)이 있나요?');
  return buffer.toString();
  }

  Future<bool> _assetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length || a.isEmpty) return 0;
    var dot = 0.0;
    var normA = 0.0;
    var normB = 0.0;
    for (var i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    }
    if (normA == 0 || normB == 0) return 0;
    return dot / (sqrt(normA) * sqrt(normB));
  }

  double _combinedScore({
    required String userText,
    required _Profile profile,
    required double embeddingScore,
    required bool useEmbedding,
  }) {
    final keywordScore = _keywordScore(userText, profile);
    if (!useEmbedding) {
      return keywordScore;
    }
    return embeddingScore * 0.7 + keywordScore * 0.3;
  }

  double _keywordScore(String userText, _Profile profile) {
    final text = userText.toLowerCase();
    final wantsSpicy =
        text.contains('매운') || text.contains('매콤') || text.contains('맵');
    final wantsSweet =
        text.contains('달콤') || text.contains('단맛') || text.contains('달달');
    final wantsMeat = text.contains('고기') ||
        text.contains('페퍼로니') ||
        text.contains('베이컨') ||
        text.contains('육');
    final wantsVeggie = text.contains('채식') ||
        text.contains('야채') ||
        text.contains('채소') ||
        text.contains('버섯');
    final wantsCheese = text.contains('치즈');
    final wantsLight =
        text.contains('담백') || text.contains('가벼') || text.contains('깔끔');

    var score = 0.0;
    if (wantsSpicy && profile.tags.contains(_TasteTag.spicy)) score += 1;
    if (wantsSweet && profile.tags.contains(_TasteTag.sweet)) score += 1;
    if (wantsMeat && profile.tags.contains(_TasteTag.meat)) score += 1;
    if (wantsVeggie && profile.tags.contains(_TasteTag.veggie)) score += 1;
    if (wantsCheese && profile.tags.contains(_TasteTag.cheese)) score += 1;
    if (wantsLight && profile.tags.contains(_TasteTag.light)) score += 1;
    for (final topping in profile.toppings) {
      if (text.contains(topping.toLowerCase())) {
        score += 0.5;
      }
    }

    final maxScore = max(1, profile.tags.length);
    return score / maxScore;
  }

  List<_Profile> _rankProfiles(
    String userText,
    List<_ScoredProfile> scored,
  ) {
    final hash = _hashText(userText);
    final maxScore = scored.map((s) => s.score).fold(0.0, max);
    if (maxScore == 0) {
      final profiles = _profiles;
      final start = hash % profiles.length;
      final ordered = List<_Profile>.generate(
        profiles.length,
        (i) => profiles[(start + i) % profiles.length],
      );
      return ordered;
    }
    scored.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      final aTie = _hashText('${a.profile.title}-$hash');
      final bTie = _hashText('${b.profile.title}-$hash');
      return aTie.compareTo(bTie);
    });
    return scored.map((s) => s.profile).toList();
  }

  int _hashText(String text) {
    var hash = 0;
    for (final codeUnit in text.codeUnits) {
      hash = 0x1fffffff & (hash + codeUnit);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= (hash >> 6);
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  bool _containsHangul(String text) {
    return RegExp(r'[가-힣]').hasMatch(text);
  }

  bool _isSmallTalk(String text) {
    final lower = text.toLowerCase();
    final keywords = [
      '안녕',
      '하이',
      '반가',
      '고마워',
      '감사',
      '뭐해',
      '뭐해?',
      '어때',
      '오늘',
      '날씨',
      '배고',
      '점심',
      '저녁',
      '추천',
      '대화',
      '심심',
    ];
    final pizzaKeywords = [
      '토핑',
      '피자',
      '치즈',
      '페퍼로니',
      '베이컨',
      '버섯',
      '할라피뇨',
      '파인애플',
      '고구마',
      '크러스트',
      '도우',
    ];
    final hasPizza = pizzaKeywords.any((k) => lower.contains(k));
    if (hasPizza) return false;
    return keywords.any((k) => lower.contains(k));
  }

  String _buildSmallTalkReply(String text) {
    final replies = [
      '안녕하세요! 오늘 기분은 어떠세요? 원하시면 피자 토핑도 추천해 드릴게요.',
      '반가워요! 잠깐 쉬는 중인가요? 토핑 취향도 알려주시면 좋아요.',
      '오늘도 수고했어요. 가볍게 피자 추천 받아볼까요?',
      '저는 잘 지내고 있어요. 원하면 토핑 추천으로 바로 이어갈게요.',
      '좋은 하루예요! 오늘은 어떤 맛이 끌리나요?',
    ];
    final index = _hashText(text) % replies.length;
    return replies[index];
  }

  String _buildDynamicReplyFromKeywords(String userText) {
  final prefs = _Preference.fromText(userText);
  final random = Random(_hashText(userText));
  final buffer = StringBuffer();

  final combo = _buildCombo(prefs, Random(random.nextInt(1 << 30)));
  buffer.writeln(
    '1) ${combo.title}: ${combo.toppings.join("/")}/${combo.dough}/${combo.crust} - ${combo.reason}',
  );
  buffer.writeln('더 원하는 맛(매운맛/달콤함/고기/채식 등)이 있나요?');
  return buffer.toString();
  }

  _Combo _buildCombo(_Preference prefs, Random random) {
    final toppings = <String>[];
    if (prefs.wantsMeat) {
      toppings.addAll(['페퍼로니', '베이컨']);
    }
    if (prefs.wantsVeggie) {
      toppings.addAll(['버섯', '양파', '올리브']);
    }
    if (prefs.wantsSpicy) {
      toppings.add('할라피뇨');
    }
    if (prefs.wantsSweet) {
      toppings.add('파인애플');
    }
    if (prefs.wantsCheese) {
      toppings.add('치즈 추가');
    }

    final allToppings = [
      '페퍼로니',
      '베이컨',
      '버섯',
      '양파',
      '올리브',
      '파인애플',
      '할라피뇨',
      '치즈 추가',
    ];
    toppings.shuffle(random);
    while (toppings.length < 2) {
      final candidate = allToppings[random.nextInt(allToppings.length)];
      if (!toppings.contains(candidate)) toppings.add(candidate);
    }
    while (toppings.length > 4) {
      toppings.removeLast();
    }
    if (toppings.length < 4 && random.nextBool()) {
      final candidate = allToppings[random.nextInt(allToppings.length)];
      if (!toppings.contains(candidate)) toppings.add(candidate);
    }

    final dough = _pickDough(prefs, random);
    final crust = _pickCrust(prefs, random);
    final reason = _buildReason(prefs);
    final title = _buildTitle(prefs, random);

    return _Combo(
      title: title,
      toppings: toppings,
      dough: dough,
      crust: crust,
      reason: reason,
    );
  }

  String _pickDough(_Preference prefs, Random random) {
    if (prefs.wantsCheese && random.nextBool()) {
      return random.nextBool() ? '치즈 크러스트' : '치즈 바이트';
    }
    if (prefs.wantsSweet && random.nextBool()) {
      return '고구마 크러스트';
    }
    if (prefs.wantsLight) {
      return '씬 크러스트';
    }
    return random.nextBool() ? '오리지널' : '씬 크러스트';
  }

  String _pickCrust(_Preference prefs, Random random) {
    if (prefs.wantsCheese && random.nextBool()) {
      return random.nextBool() ? '치즈 크러스트' : '치즈 바이트';
    }
    if (prefs.wantsSweet && random.nextBool()) {
      return '고구마 크러스트';
    }
    if (prefs.wantsSpicy && random.nextBool()) {
      return '갈릭 크러스트';
    }
    return random.nextBool() ? '기본 크러스트' : '갈릭 크러스트';
  }

  String _buildReason(_Preference prefs) {
    if (prefs.wantsSpicy && prefs.wantsMeat) {
      return '매콤한 고기 풍미가 확 살아나는 조합이에요.';
    }
    if (prefs.wantsSweet) {
      return '달콤함과 짭짤함의 밸런스를 살렸어요.';
    }
    if (prefs.wantsVeggie) {
      return '가볍고 산뜻하게 즐기기 좋아요.';
    }
    if (prefs.wantsCheese) {
      return '치즈 풍미를 진하게 느낄 수 있어요.';
    }
    return '호불호 적은 밸런스 조합이에요.';
  }

  String _buildTitle(_Preference prefs, Random random) {
    if (prefs.wantsSpicy) return '파이어 킥';
    if (prefs.wantsSweet) return '스윗 밸런스';
    if (prefs.wantsVeggie) return '그린 라이트';
    if (prefs.wantsCheese) return '치즈 펀치';
    final titles = ['클래식', '하모니', '올라운드', '데일리'];
    return titles[random.nextInt(titles.length)];
  }

  String _buildRuleBasedReply(String userText) {
    final text = userText.toLowerCase();
    final wantsSpicy = text.contains('매운') || text.contains('매콤');
    final wantsSweet = text.contains('달콤') || text.contains('단맛');
    final wantsMeat = text.contains('고기') ||
        text.contains('페퍼로니') ||
        text.contains('베이컨');
    final wantsVeggie = text.contains('채식') ||
        text.contains('야채') ||
        text.contains('버섯');
    final wantsCheese = text.contains('치즈');

    final combo1Toppings = <String>[
      if (wantsMeat) '페퍼로니',
      if (wantsMeat) '베이컨',
      if (!wantsMeat) '버섯',
      '양파',
      if (wantsSpicy) '할라피뇨',
      if (wantsSweet) '파인애플',
      if (wantsCheese) '치즈 추가',
    ].take(4).toList();

    final combo2Toppings = <String>[
      if (wantsVeggie) '버섯',
      '양파',
      '올리브',
      if (wantsSweet) '파인애플',
      if (wantsSpicy) '할라피뇨',
      if (wantsCheese) '치즈 추가',
    ].take(4).toList();

    final combo3Toppings = <String>[
      '페퍼로니',
      '올리브',
      if (wantsSpicy) '할라피뇨',
      if (wantsCheese) '치즈 추가',
    ].take(4).toList();

    final buffer = StringBuffer();
    buffer.writeln(
      '1) 불맛 밸런스: ${combo1Toppings.join("/")}/오리지널/기본 크러스트 - 풍미 균형을 맞춘 조합이에요.',
    );
    buffer.writeln('더 원하는 맛(매운맛/달콤함/고기/채식 등)이 있나요?');
    return buffer.toString();
  }
}

class _Tokenizer {
  _Tokenizer({
    required this.vocab,
    required this.unkId,
    required this.clsId,
    required this.sepId,
    required this.padId,
    required this.maxLength,
    required this.lowercase,
  });

  final Map<String, int> vocab;
  final int unkId;
  final int clsId;
  final int sepId;
  final int padId;
  final int maxLength;
  final bool lowercase;

  factory _Tokenizer.fromJson(Map<String, dynamic> json) {
    final model = json['model'] as Map<String, dynamic>;
    final vocabRaw = model['vocab'] as Map<String, dynamic>;
    final vocab = vocabRaw.map((key, value) => MapEntry(key, value as int));

    final addedTokens = (json['added_tokens'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    int _findTokenId(String token, int fallback) {
      final match = addedTokens.firstWhere(
        (t) => t['content'] == token,
        orElse: () => const {},
      );
      if (match.isNotEmpty) {
        return match['id'] as int? ?? fallback;
      }
      return vocab[token] ?? fallback;
    }

    final padding = json['padding'] as Map<String, dynamic>? ?? {};
    final truncation = json['truncation'] as Map<String, dynamic>? ?? {};
    final padId = padding['pad_id'] as int? ?? vocab['[PAD]'] ?? 0;
    final maxLength = truncation['max_length'] as int? ?? 128;
    final normalizer = json['normalizer'] as Map<String, dynamic>? ?? {};
    final lowercase = normalizer['lowercase'] as bool? ?? true;

    return _Tokenizer(
      vocab: vocab,
      unkId: _findTokenId('[UNK]', 100),
      clsId: _findTokenId('[CLS]', 101),
      sepId: _findTokenId('[SEP]', 102),
      padId: padId,
      maxLength: maxLength,
      lowercase: lowercase,
    );
  }

  _Encoding encode(String text) {
    final cleaned = _normalize(text);
    final basicTokens = _basicTokenize(cleaned);
    final wordPieces = <String>[];
    for (final token in basicTokens) {
      wordPieces.addAll(_wordPieceTokenize(token));
    }

    final ids = <int>[clsId];
    var unkCount = 0;
    for (final piece in wordPieces) {
      if (piece == '[UNK]') {
        unkCount += 1;
      }
      ids.add(vocab[piece] ?? unkId);
      if (ids.length >= maxLength - 1) {
        break;
      }
    }
    ids.add(sepId);

    final attentionMask = List<int>.filled(ids.length, 1);
    if (ids.length < maxLength) {
      final padCount = maxLength - ids.length;
      ids.addAll(List<int>.filled(padCount, padId));
      attentionMask.addAll(List<int>.filled(padCount, 0));
    } else if (ids.length > maxLength) {
      ids.removeRange(maxLength, ids.length);
      attentionMask.removeRange(maxLength, attentionMask.length);
    }

    return _Encoding(
      inputIds: ids,
      attentionMask: attentionMask,
      unkCount: unkCount,
      tokenCount: wordPieces.length,
    );
  }

  String _normalize(String text) {
    var output = text.trim();
    if (lowercase) {
      output = output.toLowerCase();
    }
    output = output.replaceAll(RegExp(r'\s+'), ' ');
    return output;
  }

  List<String> _basicTokenize(String text) {
    if (text.isEmpty) return [];
    final regex = RegExp(r"[A-Za-z0-9]+|[^A-Za-z0-9\\s]+");
    return regex.allMatches(text).map((m) => m.group(0)!).toList();
  }

  List<String> _wordPieceTokenize(String token) {
    if (vocab.containsKey(token)) {
      return [token];
    }
    final chars = token.split('');
    final pieces = <String>[];
    var start = 0;
    while (start < chars.length) {
      var end = chars.length;
      String? current;
      while (start < end) {
        final sub = chars.sublist(start, end).join('');
        final candidate = start == 0 ? sub : '##$sub';
        if (vocab.containsKey(candidate)) {
          current = candidate;
          break;
        }
        end -= 1;
      }
      if (current == null) {
        return ['[UNK]'];
      }
      pieces.add(current);
      start = end;
    }
    return pieces;
  }
}

class _Encoding {
  const _Encoding({
    required this.inputIds,
    required this.attentionMask,
    required this.unkCount,
    required this.tokenCount,
  });

  final List<int> inputIds;
  final List<int> attentionMask;
  final int unkCount;
  final int tokenCount;
}

class _EmbeddingResult {
  const _EmbeddingResult({
    required this.encoding,
    required this.vector,
  });

  final _Encoding encoding;
  final List<double> vector;

  const _EmbeddingResult.empty()
      : encoding = const _Encoding(
          inputIds: [],
          attentionMask: [],
          unkCount: 0,
          tokenCount: 0,
        ),
        vector = const [];
}

enum _TasteTag {
  spicy,
  sweet,
  meat,
  veggie,
  cheese,
  light,
}

class _Profile {
  const _Profile({
    required this.title,
    required this.toppings,
    required this.dough,
    required this.crust,
    required this.reason,
    required this.prompt,
    required this.tags,
  });

  final String title;
  final List<String> toppings;
  final String dough;
  final String crust;
  final String reason;
  final String prompt;
  final Set<_TasteTag> tags;
}

class _ProfileEmbedding {
  const _ProfileEmbedding({
    required this.profile,
    required this.embedding,
  });

  final _Profile profile;
  final List<double> embedding;
}

class _ScoredProfile {
  const _ScoredProfile({
    required this.profile,
    required this.score,
  });

  final _Profile profile;
  final double score;
}

class _Preference {
  const _Preference({
    required this.wantsSpicy,
    required this.wantsSweet,
    required this.wantsMeat,
    required this.wantsVeggie,
    required this.wantsCheese,
    required this.wantsLight,
  });

  final bool wantsSpicy;
  final bool wantsSweet;
  final bool wantsMeat;
  final bool wantsVeggie;
  final bool wantsCheese;
  final bool wantsLight;

  factory _Preference.fromText(String text) {
    final lower = text.toLowerCase();
    return _Preference(
      wantsSpicy: lower.contains('매운') ||
          lower.contains('매콤') ||
          lower.contains('맵'),
      wantsSweet: lower.contains('달콤') ||
          lower.contains('단맛') ||
          lower.contains('달달'),
      wantsMeat: lower.contains('고기') ||
          lower.contains('페퍼로니') ||
          lower.contains('베이컨') ||
          lower.contains('육'),
      wantsVeggie: lower.contains('채식') ||
          lower.contains('야채') ||
          lower.contains('채소') ||
          lower.contains('버섯'),
      wantsCheese: lower.contains('치즈'),
      wantsLight: lower.contains('담백') ||
          lower.contains('가벼') ||
          lower.contains('깔끔'),
    );
  }
}

class _Combo {
  const _Combo({
    required this.title,
    required this.toppings,
    required this.dough,
    required this.crust,
    required this.reason,
  });

  final String title;
  final List<String> toppings;
  final String dough;
  final String crust;
  final String reason;
}

const List<_Profile> _profiles = [
  _Profile(
    title: '파이어 클래식',
    toppings: ['페퍼로니', '할라피뇨', '양파', '올리브'],
    dough: '오리지널',
    crust: '갈릭 크러스트',
    reason: '매콤한 풍미와 향을 살린 조합이에요.',
    prompt: '매콤하고 알싸한 맛을 좋아하고 고기 토핑 선호',
    tags: {_TasteTag.spicy, _TasteTag.meat},
  ),
  _Profile(
    title: '스윗 트로피칼',
    toppings: ['파인애플', '베이컨', '양파', '치즈 추가'],
    dough: '씬 크러스트',
    crust: '기본 크러스트',
    reason: '달콤함과 짭짤함의 균형이 좋아요.',
    prompt: '달콤한 맛과 과일향을 좋아함',
    tags: {_TasteTag.sweet, _TasteTag.meat},
  ),
  _Profile(
    title: '미트 러버',
    toppings: ['페퍼로니', '베이컨', '치즈 추가', '양파'],
    dough: '치즈 크러스트',
    crust: '치즈 크러스트',
    reason: '진한 고기 풍미를 강조했어요.',
    prompt: '고기 토핑을 많이 원하고 든든한 맛을 좋아함',
    tags: {_TasteTag.meat, _TasteTag.cheese},
  ),
  _Profile(
    title: '베지 라이트',
    toppings: ['버섯', '양파', '올리브', '파인애플'],
    dough: '씬 크러스트',
    crust: '기본 크러스트',
    reason: '가볍고 담백한 채소 중심 조합이에요.',
    prompt: '채식 위주, 깔끔하고 가벼운 맛 선호',
    tags: {_TasteTag.veggie, _TasteTag.light, _TasteTag.sweet},
  ),
  _Profile(
    title: '치즈 펀치',
    toppings: ['치즈 추가', '페퍼로니', '버섯', '양파'],
    dough: '치즈 바이트',
    crust: '치즈 바이트',
    reason: '치즈 풍미를 확 끌어올렸어요.',
    prompt: '치즈를 좋아하고 고소한 맛 선호',
    tags: {_TasteTag.cheese, _TasteTag.meat},
  ),
  _Profile(
    title: '올라운드 밸런스',
    toppings: ['페퍼로니', '버섯', '양파', '올리브'],
    dough: '오리지널',
    crust: '기본 크러스트',
    reason: '호불호 적은 클래식한 균형 조합이에요.',
    prompt: '특별한 취향 없이 균형 잡힌 맛을 원함',
    tags: {_TasteTag.meat, _TasteTag.light},
  ),
];
