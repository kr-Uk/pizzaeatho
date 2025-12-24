import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pizzaeatho/util/common.dart';
import 'package:pizzaeatho/util/on_device_ai_service.dart';

const Color _snowBackground = Color(0xFFF9F6F1);

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final OnDeviceAiService _aiService = OnDeviceAiService();

  bool _isSending = false;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      role: 'assistant',
      content: '안녕하세요! 피자 토핑 추천이 필요하신가요?\n알레르기나 선호하는 맛을 알려주세요.',
    ),
  ];

  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  Future<void> _sendChatMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(_ChatMessage(role: 'user', content: text));
      _chatController.clear();
      _isSending = true;
    });

    final promptMessages = _buildPromptMessages();

    try {
      final reply = await _aiService.sendMessage(
        messages: promptMessages,
        userText: text,
      );
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
    final messages = <Map<String, String>>[];
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
      backgroundColor: _snowBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('AI 토핑 추천'),
        backgroundColor: redBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MediaQuery.removeViewInsets(
                context: context,
                removeBottom: true,
                child: ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
                        constraints: BoxConstraints(maxWidth: 800.w),
                        decoration: BoxDecoration(
                          color: isUser ? redBackground : Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          msg.content,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 30.sp,
                            height: 1.35,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            AnimatedPadding(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        style: TextStyle(fontSize: 28.sp),
                        decoration: const InputDecoration(
                          hintText: '토핑 취향을 알려주세요.',
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
                      height: 38,
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
              ),
            ),
          ],
        ),
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
