// lib/pages/MBTI_result.dart

import 'package:flutter/material.dart';

class MBTIResultPage extends StatelessWidget {
  final VoidCallback onRestartPressed;
  final VoidCallback onBackPressed;

  // ... (데이터 변수들은 동일)
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
    // 👇 1. 공통 버튼 색상 (start_page.dart 참고)
    const Color accentColor = Color(0xFFED6D11);
    // 👇 2. 공통 배경색 (home_page.dart 등 참고)
    const Color backgroundColor = Color(0xFFF0E8DD);

    return Scaffold(
      backgroundColor: backgroundColor, // 👈 3. 배경색 적용
      appBar: AppBar(
        backgroundColor: backgroundColor, // 👈 4. AppBar 배경색도 통일
        elevation: 0,
        foregroundColor: Colors.black, // (아이콘 색상)

        // 👇 5. 제목을 '콘텐츠'(탭이름) -> '페이지 이름'으로 변경
        title: const Text(
          'MBTI 검사 결과',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,

        // '뒤로 가기' (결과 -> 테스트) 버튼은 유지
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackPressed,
        ),

        // 👇 6. [제거됨] CommonFrame에 이미 있으므로 중복되는 설정 버튼 제거
        // actions: [ ... ],
      ),
      body: Container(
        color: backgroundColor, // 👈 7. 본문 배경색 적용
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ... (UI 코드 - '검사 버튼', '사진', '결과', '특징' 등)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white, // (이전 화면 버튼)
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text('강아지 MBTI 검사'),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  image: const DecorationImage(
                    // TODO: 'assets/dog_result.png' 등록 필요
                    image: AssetImage('assets/dog_result.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(dogName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text('성격 유형 결과 $resultType',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, // (내용 카드)
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05), blurRadius: 5)
                    ],
                  ),
                  child: Text(summary,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildResultSubSection(
                          title: '특징', content: feature),
                    ),
                    const SizedBox(
                      height: 120, // Divider 높이 조절
                      child: VerticalDivider(color: Colors.grey, thickness: 1),
                    ),
                    Expanded(
                      child: _buildResultSubSection(
                          title: '추천 활동', content: recommendation),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // '다시하기' 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ElevatedButton(
                  onPressed: onRestartPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor, // 👈 8. 버튼 색상 적용
                    minimumSize: const Size(double.infinity, 65),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('다시하기',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // ... (_buildResultSubSection 함수는 동일)
  Widget _buildResultSubSection(
      {required String title, required String content}) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Text(content,
            style: const TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center),
      ],
    );
  }
}