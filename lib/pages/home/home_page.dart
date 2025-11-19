// lib/pages/home/home_page.dart

import 'package:flutter/material.dart';

class HomePageClean extends StatelessWidget {
  const HomePageClean({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0E8DD),  // 공통 배경색
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ⭐ 상단 이미지 + 텍스트
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        'assets/chocolate.jpg',
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '포메라니안',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF161411),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '사실 강아지에게 초콜릿은 위험해요.\n'
                          '대신 강아지 전용 간식을 준비해 주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4C3F35),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 150),

              /// ⭐ 오늘의 반려동물 팁
              const Text(
                '오늘의 반려동물 팁',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF161411),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                height: 200,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EE),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '운동 체크',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF161411),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '매일 30분 이상 산책을 시켜주면\n'
                                '반려견의 스트레스 해소와 건강에 좋아요.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF4C3F35),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/chocolate.jpg',
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
