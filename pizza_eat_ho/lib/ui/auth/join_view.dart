import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'auth_viewmodel.dart';

const Color _creamBackground = Color(0xFFF8F4EF);
const Color _accentRed = Color(0xFFB01222);
const Color _deepRed = Color(0xFF8F0F1F);
const Color _ink = Color(0xFF1B1615);

class JoinView extends StatefulWidget {
  const JoinView({super.key});

  @override
  State<JoinView> createState() => _JoinViewState();
}

class _JoinViewState extends State<JoinView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _localError;
  bool _isCheckingId = false;
  bool? _isIdAvailable;
  String? _idCheckMessage;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final isLoading = authViewModel.isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _creamBackground,
      body: Stack(
        children: [
          Positioned(
            top: -60.h,
            right: -90.w,
            child: Container(
              width: 180.w,
              height: 1200.w,
              decoration: BoxDecoration(
                color: _accentRed.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -90.h,
            left: -60.w,
            child: Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                color: _deepRed.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(height: 150.h),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icon.png',
                          height: 440.h,
                        ),
                        Transform.translate(
                          offset: Offset(0, -12.h),
                          child: Text('회원가입하고 다양한 혜택을 받아보세요',
                            style: TextStyle(
                              fontSize: 30.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text('회원가입',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: _ink,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 28.sp),
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      prefixIcon: const Icon(Icons.tag_faces_outlined),
                      filled: true,
                      fillColor: const Color(0xFFFCFAF8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide:
                            const BorderSide(color: _accentRed, width: 2),
                      ),
                    ),
                    onChanged: (_) {
                      if (_localError != null) {
                        setState(() => _localError = null);
                      }
                    },
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _idController,
                          style: TextStyle(fontSize: 28.sp),
                          decoration: InputDecoration(
                            labelText: '아이디',
                            labelStyle: TextStyle(color: Colors.grey.shade700),
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: const Color(0xFFFCFAF8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide:
                                  const BorderSide(color: _accentRed, width: 2),
                            ),
                          ),
                          onChanged: (_) {
                            if (_localError != null) {
                              setState(() => _localError = null);
                            }
                            if (_idCheckMessage != null || _isIdAvailable != null) {
                              setState(() {
                                _idCheckMessage = null;
                                _isIdAvailable = null;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      SizedBox(
                        height: 130.h,
                        child: ElevatedButton(
                          onPressed: _isCheckingId
                              ? null
                              : () async {
                                  final id = _idController.text.trim();
                                  if (id.isEmpty) {
                                    setState(() {
                                      _idCheckMessage = '아이디를 입력해주세요.';
                                      _isIdAvailable = false;
                                    });
                                    return;
                                  }
                                  setState(() => _isCheckingId = true);
                                  final available =
                                      await authViewModel.checkUserId(id);
                                  if (!mounted) return;
                                  setState(() {
                                    _isCheckingId = false;
                                    _isIdAvailable = available;
                                    _idCheckMessage = available
                                        ? '사용 가능한 아이디입니다.'
                                        : '이미 사용중인 아이디입니다.';
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accentRed,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: _isCheckingId
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  '중복체크',
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  if (_idCheckMessage != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      _idCheckMessage!,
                      style: TextStyle(
                        color: _isIdAvailable == true
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontSize: 26.sp,
                      ),
                    ),
                  ],
                  SizedBox(height: 50.h),
                  TextField(
                    controller: _pwController,
                    obscureText: true,
                    style: TextStyle(fontSize: 28.sp),
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: const Color(0xFFFCFAF8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide:
                            const BorderSide(color: _accentRed, width: 2),
                      ),
                    ),
                    onChanged: (_) {
                      if (_localError != null) {
                        setState(() => _localError = null);
                      }
                    },
                  ),
                  if (_localError != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      _localError!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 26.sp,
                      ),
                    ),
                  ],
                  if (_localError == null && authViewModel.errorMessage != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      authViewModel.errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 26.sp,
                      ),
                    ),
                  ],
                  SizedBox(height: 100.h),
                  SizedBox(
                    height: 100.h,
                    child: Opacity(
                      opacity: isLoading ? 0.7 : 1,
                      child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_accentRed, _deepRed],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30.r),
                            onTap: isLoading
                                ? null
                                : () async {
                                    if (_nameController.text.trim().isEmpty ||
                                        _idController.text.trim().isEmpty ||
                                        _pwController.text.trim().isEmpty) {
                                      setState(() {
                                        _localError = '모든 항목을 입력해주세요';
                                      });
                                      return;
                                    }
                                    if (_isIdAvailable != true) {
                                      setState(() {
                                        _localError = '아이디 중복 확인을 해주세요.';
                                      });
                                      return;
                                    }
                                    final success = await authViewModel.signup(
                                      id: _idController.text.trim(),
                                      pw: _pwController.text.trim(),
                                      name: _nameController.text.trim(),
                                    );
                                    if (success && context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                            child: Center(
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      '가입하기',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 36.sp,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이미 계정이 있나요?',
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: _accentRed,
                        ),
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 36.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
