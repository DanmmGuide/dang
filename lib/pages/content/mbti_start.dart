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
    // 공통 컬러
    const Color accentColor = Color(0xFFED6D11);   // 버튼 강조색
    const Color backgroundColor = Color(0xFFF0E8DD);
    const Color buttonColor = Colors.white;        // 라벨 배경
    const Color borderColor = Color(0xFFE0E0E0);   // 라벨 테두리

    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 60),   // 상단 여백

            // ------ 라벨 (강아지 MBTI 검사) ------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: const Text(
                '강아지 MBTI 검사',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ------ 이미지 (너 버전 크기 & 파일명 반영) ------
            SizedBox(
              height: 220,
              width: 220,
              child: Image.asset(
                'assets/pomeranian.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),

            const Spacer(),  // 버튼을 아래로 밀어내기

            // ------ START 버튼 ------
            ElevatedButton(
              onPressed: onStartPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'START',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            const SizedBox(height: 70),  // 하단 안정적 여백
          ],
        ),
      ),
    );
  }
}
