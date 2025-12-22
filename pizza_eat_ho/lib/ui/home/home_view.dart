import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/data/model/user.dart';
import 'package:pizzaeatho/data/repository/user_repository.dart';
import 'package:pizzaeatho/util/beacon_service.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:pizzaeatho/util/openai_chat_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _controller = PageController();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  int _currentPage = 0;
  Timer? _timer;
  BeaconService? _beaconService;
  bool _dialogOpen = false;
  bool _isSending = false;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      role: 'assistant',
      content: '안녕하세요! 피자 토핑 추천이 필요하신가요?\n알레르기나 선호하는 맛을 알려주세요.',
    ),
  ];

  final banners = List.generate(
    6,
    (index) => Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: SizedBox(
        height: 500.h,
        child: Center(
          child: Text("Page $index", style: TextStyle(color: Colors.indigo)),
        ),
      ),
    ),
  );

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _currentPage = (_currentPage + 1) % banners.length;

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });

    _beaconService = BeaconService(
      uuid: 'e2c56db5-dffb-48d2-b060-d0f5a71096e0',
      major: 40011,
      minor: 45369,
      enterDistanceMeters: 3.0,
      onEnter: () {
        _showBeaconDialog('피짜잇호에 오신 것을 환영합니다!');
      },
      onExit: () {
        _showBeaconDialog('다음에 또 이용해주세요!');
      },
    );
    _beaconService?.start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _beaconService?.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  void _showBeaconDialog(String message) {
    if (!mounted || _dialogOpen) return;
    _dialogOpen = true;
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    ).then((_) {
      if (mounted) {
        _dialogOpen = false;
      }
    });
  }

  Future<void> _sendChatMessage() async {
    final apiKey = const String.fromEnvironment('OPENAI_API_KEY');
    if (apiKey.isEmpty) {
      _showBeaconDialog('OPENAI_API_KEY가 설정되지 않았습니다.');
      return;
    }

    final text = _chatController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(_ChatMessage(role: 'user', content: text));
      _chatController.clear();
      _isSending = true;
    });

    final service = OpenAiChatService(apiKey: apiKey);
    final promptMessages = _buildPromptMessages();

    try {
      final reply = await service.sendMessage(messages: promptMessages);
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(role: 'assistant', content: reply));
      });
      _scrollChatToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(const _ChatMessage(
          role: 'assistant',
          content: '잠시 후 다시 시도해주세요.',
        ));
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  List<Map<String, String>> _buildPromptMessages() {
    const systemPrompt =
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
        '1) 조합명: 토핑/도우/크러스트 — 이유 한 줄\n'
        '2) 조합명: ...\n'
        '3) 조합명: ...\n'
        '마지막 줄: “더 원하는 맛(매운맛/달콤함/고기/채식 등)이 있나요?”';

    final messages = <Map<String, String>>[
      {'role': 'system', 'content': systemPrompt},
    ];

    for (final msg in _messages) {
      messages.add({'role': msg.role, 'content': msg.content});
    }

    return messages;
  }

  void _scrollChatToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_chatScrollController.hasClients) return;
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pizza잇호!', style: TextStyle(color: Colors.white)),
        backgroundColor: redBackground,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/shoppingcart");
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: redBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: .center,
                      children: [
                        SizedBox(
                          height: 500.h,
                          child: ClipRRect(
                            borderRadius: .circular(30.r),
                            child: PageView.builder(
                              controller: _controller,
                              onPageChanged: (index) {
                                _currentPage = index;
                              },
                              itemBuilder: (_, index) {
                                return banners[index % banners.length];
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: SmoothPageIndicator(
                            controller: _controller,
                            count: banners.length,
                            effect: ScrollingDotsEffect(
                              activeDotColor: redBackground,
                              activeStrokeWidth: 2.6,
                              activeDotScale: 1.3,
                              maxVisibleDots: 5,
                              radius: 8,
                              spacing: 10,
                              dotHeight: 12,
                              dotWidth: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60.h),
                    ValueListenableBuilder<UserLoginResponseDto?>(
                      valueListenable: UserRepository.currentUser,
                      builder: (context, user, _) {
                        final isLoggedIn = user != null;
                        return InkWell(
                          onTap: () {
                            if (isLoggedIn) {
                              UserRepository().logout();
                            } else {
                              Navigator.pushNamed(context, "/login");
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: redBackground,
                              border:
                                  Border.all(color: Colors.white, width: 4.w),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            width: double.infinity,
                            height: 250.h,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  Icon(
                                    Icons.power_settings_new_outlined,
                                    color: Colors.white,
                                    size: 100.w,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    isLoggedIn ? "LOG OUT" : "LOG IN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 80.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isLoggedIn) ...[
                                    SizedBox(width: 20.w),
                                    Flexible(
                                      child: Text(
                                        "${user.name}님",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 30.h),
                    _buildChatSection(),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 70.h,
              width: 300.w,
              decoration: BoxDecoration(
                color: redBackground,
                borderRadius: .circular(100.r),
              ),
              child: Center(
                child:
                    Text("최근 주문 내역", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 600.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (_, index) {
                  return Container(
                    width: 300.w,
                    margin: index == 9
                        ? EdgeInsets.symmetric(horizontal: 8.0)
                        : EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 300.w,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: .circular(30.r),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text("피자 $index"),
                        SizedBox(height: 20.h),
                        Text("가격: 3000원"),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 70.h,
              width: 300.w,
              decoration: BoxDecoration(
                color: redBackground,
                borderRadius: .circular(100.r),
              ),
              child: Center(
                child: Text("인기 메뉴", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 600.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (_, index) {
                  return Container(
                    width: 300.w,
                    margin: index == 9
                        ? EdgeInsets.symmetric(horizontal: 8.0)
                        : EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 300.w,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: .circular(30.r),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text("피자 $index"),
                        SizedBox(height: 20.h),
                        Text("가격: 3000원"),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI 토핑 추천',
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
              color: redBackground,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 380.h,
            child: ListView.builder(
              controller: _chatScrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg.role == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: 700.w),
                    decoration: BoxDecoration(
                      color: isUser ? redBackground : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      msg.content,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 32.sp,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: const InputDecoration(
                    hintText: '원하는 토핑 취향을 말해주세요.',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _sendChatMessage(),
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _sendChatMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redBackground,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('보내기'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.role,
    required this.content,
  });

  final String role;
  final String content;
}
