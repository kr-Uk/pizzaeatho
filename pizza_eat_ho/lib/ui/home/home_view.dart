import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/ui/auth/auth_viewmodel.dart';
import 'package:pizzaeatho/ui/home/home_viewmodel.dart';
import 'package:pizzaeatho/util/beacon_service.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:pizzaeatho/util/openai_chat_service.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../order/order_history_detail_page.dart';

const Color _christmasGreen = Color(0xFF0F6B3E);
const Color _snowBackground = Color(0xFFF9F6F1);

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  late final AnimationController _snowController;
  late final List<_Snowflake> _flakes;

  int _currentPage = 0;
  Timer? _timer;
  BeaconService? _beaconService;
  bool _dialogOpen = false;
  bool _isSending = false;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      role: 'assistant',
      content: '안녕하세요! 피짜잇호에서 일하고 있는 AI호잇짜입니다!',
    ),
  ];

  final List<String> bannerImages = [
    "assets/banner.png",
    "assets/event1.png",
    "assets/event3.png",
    "assets/event2.png",
  ];

  @override
  void initState() {
    super.initState();

    _snowController =
        AnimationController(vsync: this, duration: const Duration(seconds: 12))
          ..repeat();
    final random = Random();
    _flakes = List.generate(80, (_) {
      return _Snowflake(
        baseX: random.nextDouble(),
        baseY: random.nextDouble(),
        radius: 1.5 + random.nextDouble() * 2.5,
        speed: 1.0 + random.nextDouble() * 2.0,
        drift: (random.nextDouble() - 0.5) * 0.4,
      );
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _currentPage = (_currentPage + 1) % bannerImages.length;

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
    _snowController.dispose();
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
        '너는 “피짜잇호”의 직원인 AI다. 반드시 한국어로 답한다.\n'
        '아래는 매장에서 제공 가능한 옵션 목록이다.\n\n'
        '[토핑]\n'
        '- 페퍼로니(1200), 베이컨(1300), 버섯(800), 양파(600), 올리브(700), 파인애플(900), 할라피뇨(700), 치즈 추가(1500)\n\n'
        '[도우]\n'
        '- 오리지널(0), 씬 크러스트(0), 치즈 크러스트(2000), 고구마 크러스트(2000), 치즈 바이트(2500)\n\n'
        '[크러스트]\n'
        '- 기본 크러스트(0), 치즈 크러스트(3000), 고구마 크러스트(3000), 갈릭 크러스트(2500), 치즈 바이트(3500)\n\n'
        '사용자와 그냥 잘 의사소통 하면 된다.';

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
    final authViewModel = context.watch<AuthViewModel>();
    final homeViewModel = context.watch<HomeViewModel>();

    final user = authViewModel.user;
    bool isLoggedIn = authViewModel.isLoggedIn;
    final BASE_URL = "http://${IP_PORT}/imgs/pizza/";
    final orderList = homeViewModel.orderHistory;
    final orderListCount = orderList.length;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 6, right: 20),
          child: Image.asset(
            'assets/icon.png',
            height: 80,
          ),
        ),
        backgroundColor: const Color(0xFFB91D2A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/on_device_ai");
            },
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/store");
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/shoppingcart");
            },
          ),
        ],
      ),
      backgroundColor: _snowBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFB91D2A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: .center,
                      children: [
                        SizedBox(
                          height: 600.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.r),
                            child: PageView.builder(
                              controller: _controller,
                              onPageChanged: (index) {
                                _currentPage = index;
                              },
                              itemBuilder: (_, index) {
                                final pageIndex = index % bannerImages.length;
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            bannerImages[pageIndex],
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.1),
                                            BlendMode.darken,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 16.w,
                                      bottom: 16.h,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.55),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Text(
                                          '${pageIndex + 1}/${bannerImages.length}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: SmoothPageIndicator(
                            controller: _controller,
                            count: bannerImages.length,
                            effect: ScrollingDotsEffect(
                              activeDotColor: Colors.white.withOpacity(0.7),
                              dotColor: Colors.white.withOpacity(0.35),
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

                    SizedBox(height: 64.h),
                    InkWell(
                          onTap: isLoggedIn
                              ? null
                              : () {
                                  Navigator.pushNamed(context, "/login");
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFC31E2E),
                              border:
                                  Border.all(color: Colors.white, width: 2.w),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            width: double.infinity,
                            height: 200.h,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: .center,
                                children: [
                                  if (!isLoggedIn) ...[
                                    Icon(
                                      Icons.power_settings_new_outlined,
                                      color: Colors.white,
                                      size: 100.w,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      "로그인",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 80.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ] else ...[
                                    Flexible(
                                      child: Text(
                                        "${user?.name}님 환영합니다.",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 60.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                    ),
                    SizedBox(height: 64.h),
                    _buildChatSection(),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            _buildSectionTitle("최근 주문 내역", showAccent: false, showAccentLine: true),
            SizedBox(height: 20.h),
            SizedBox(
              height: 620.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orderListCount,
                itemBuilder: (_, index) {
                  final item = orderList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderHistoryDetailPage(orderId: item.orderId),
                        ),
                      );
                    },
                    child: Container(
                      width: 400.w,
                      margin: index == orderListCount-1
                          ? const EdgeInsets.symmetric(horizontal: 12.0)
                          : const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.r),
                                image: DecorationImage(
                                  image: NetworkImage("${BASE_URL}${item.products[0].image}"),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(item.products.length == 1 ? "${item.products[0].name}" : "${item.products[0].name} 외${item.products.length-1}건"),
                          SizedBox(height: 6.h),
                          Text("${item.totalPrice}원"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            _buildSectionTitle("인기 메뉴", showAccent: false, showAccentLine: true),
            SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 600.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          image: DecorationImage(
                            image: AssetImage("assets/best_pizza.png"),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                      Text("치즈덕후를 위한 도우부터 크러스트까지, 한 입마다 치즈가 터지는 궁극의 피자!! 🧀🍕"),
                      Text("도우: 치즈"),
                      Text("크러스트: 스윗 포테이토 크러스트"),
                      Text("토핑: 포테이토, 양파, 버섯, 페퍼로니, 올리브"),
                    ],
                  ),
                ),


              SizedBox(height: 24.h),
            ],
          ),
        ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _snowController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _SnowPainter(_flakes, _snowController.value),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE6E2),
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
          Row(
            children: [
              Container(
                width: 8,
                height: 24,
                decoration: BoxDecoration(
                  color: _christmasGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'AI 호잇짜',
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: redBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 300.h,
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
                      color: isUser ? redBackground : _snowBackground,
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
                  style: TextStyle(fontSize: 28.sp),
                  decoration: const InputDecoration(
                    hintText: '메시지를 입력하세요.',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onSubmitted: (_) => _sendChatMessage(),
                ),
              ),
              SizedBox(width: 12.w),
              SizedBox(
                height: 34,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _sendChatMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redBackground,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: _isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('보내기', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildSectionTitle(
    String title, {
    bool showAccent = true,
    bool showAccentLine = false,
  }) {
    final accentColor = showAccent ? _christmasGreen : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (showAccentLine) ...[
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: _christmasGreen,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: redBackground,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: accentColor, width: 2),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 2,
              color: showAccentLine
                  ? _christmasGreen.withOpacity(0.3)
                  : (showAccent
                      ? _christmasGreen.withOpacity(0.3)
                      : Colors.transparent),
            ),
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

class _Snowflake {
  const _Snowflake({
    required this.baseX,
    required this.baseY,
    required this.radius,
    required this.speed,
    required this.drift,
  });

  final double baseX;
  final double baseY;
  final double radius;
  final double speed;
  final double drift;
}

class _SnowPainter extends CustomPainter {
  _SnowPainter(this.flakes, this.progress);

  final List<_Snowflake> flakes;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final paint = Paint()..color = Colors.white.withOpacity(0.75);
    for (final flake in flakes) {
      final x = (flake.baseX + progress * flake.drift) * size.width % size.width;
      final y = (flake.baseY + progress * flake.speed) * size.height % size.height;
      canvas.drawCircle(Offset(x, y), flake.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SnowPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.flakes != flakes;
  }
}
