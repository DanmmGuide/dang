// lib/pages/content/MBTI_start.dart

import 'package:flutter/material.dart';

class MBTIStartPage extends StatelessWidget {
  final VoidCallback? onStartPressed;

  const MBTIStartPage({
    super.key,
    required this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFED6D11);
    const Color backgroundColor = Color(0xFFF0E8DD);
    const Color textColor = Color(0xFF1C110C);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // 1. 상단 여백
              const Spacer(flex: 1),

              // 2. 상단 타이틀 영역
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: accentColor.withOpacity(0.3)),
                    ),
                    child: const Text(
                      '#멍BTI #성격분석 #도파민',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12, // 14 -> 12
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '우리 강아지는\n어떤 성격일까?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24, // 28 -> 24
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      height: 1.3,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '10가지 질문으로 알아보는 반려견 성격 유형',
                    style: TextStyle(
                      fontSize: 14, // 16 -> 14
                      color: textColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // 3. 메인 이미지 영역
              Expanded(
                flex: 8,
                child: Image.asset(
                  'assets/start.jpg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),

              const Spacer(flex: 1),

              // 4. 하단 버튼 영역
              ElevatedButton(
                onPressed: onStartPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56), // 높이 약간 줄임 (60 -> 56)
                  elevation: 5,
                  shadowColor: accentColor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '테스트 시작하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),

              // 5. 하단 여백
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}