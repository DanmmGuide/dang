// lib/pages/content/MBTI_result.dart

import 'package:flutter/material.dart';

class MBTIResultPage extends StatelessWidget {
  final VoidCallback onRestartPressed; // 다시하기
  final VoidCallback onBackPressed;    // 뒤로가기 (테스트 화면으로)

  // 임시 더미 데이터
  final String dogName = '코코';
  final String resultType = 'ISTJ';
  final String summary = '조용하고 안정적인 성격으로, 규칙을 잘 따릅니다.';
  final String feature = '새로운 환경보다는\n익숙한 공간에서\n안정감을 찾습니다.';
  final String recommendation = '정적인 놀이\n안정감 있는 공간';

  const MBTIResultPage({
    super.key,
    required this.onRestartPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFED6D11);
    const Color backgroundColor = Color(0xFFF0E8DD);

    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          children: [
            // 🔙 상단 커스텀 뒤로가기 버튼
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackPressed,
              ),
            ),
            const SizedBox(height: 10),

            // 상단 라벨
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text('강아지 MBTI 검사'),
            ),
            const SizedBox(height: 30),

            // 프로필 원형 이미지
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                image: const DecorationImage(
                  image: AssetImage('assets/dog_result.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              dogName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),

            Text(
              '성격 유형 결과 $resultType',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),

            // 요약 카드
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                summary,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),

            // 특징 / 추천 활동
            Row(
              children: [
                Expanded(
                  child: _buildResultSubSection(
                    title: '특징',
                    content: feature,
                  ),
                ),
                const SizedBox(
                  height: 120,
                  child: VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ),
                Expanded(
                  child: _buildResultSubSection(
                    title: '추천 활동',
                    content: recommendation,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // 다시하기 버튼
            ElevatedButton(
              onPressed: onRestartPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '다시하기',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSubSection({
    required String title,
    required String content,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
