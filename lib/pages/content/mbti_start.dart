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
    const Color buttonColor = Colors.white;
    const Color borderColor = Color(0xFFE0E0E0);

    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 60),

            // 상단 라벨
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: const Text(
                '강아지 MBTI 검사',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 40),

            // 이미지
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset(
                'assets/start.jpg', // 너가 쓰는 이미지로 유지
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),

            const Spacer(),

            // START 버튼
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

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
