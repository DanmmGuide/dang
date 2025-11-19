// breed_detail_page.dart
import 'package:flutter/material.dart';
import 'breed_item.dart';
import 'breed_select_page.dart';

class BreedDetailPage extends StatelessWidget {
  final BreedItem breed;

  const BreedDetailPage({super.key, required this.breed});

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF111C0C),
        fontSize: 18,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(
        color: Color(0xFF111C0C),
        fontSize: 16,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0E8DD),
        elevation: 0,
        title: Text('${breed.name} 가이드'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                breed.imagePath,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            buildSectionTitle("털 관리"),
            const SizedBox(height: 6),
            buildSectionContent("정기적인 브러싱 및 관리 필요"),

            const SizedBox(height: 20),

            buildSectionTitle("산책 필요 시간"),
            const SizedBox(height: 6),
            buildSectionContent("하루 약 1시간 이상"),

            const SizedBox(height: 20),

            buildSectionTitle("훈련 난이도"),
            const SizedBox(height: 6),
            buildSectionContent("훈련 난이도는 보통 수준"),

            const SizedBox(height: 20),

            buildSectionTitle("평균 수명"),
            const SizedBox(height: 6),
            buildSectionContent("약 12–15년"),

            const SizedBox(height: 20),

            buildSectionTitle("환경 적합성"),
            const SizedBox(height: 6),
            buildSectionContent("아파트 적응 가능, 실내 생활 적합"),
          ],
        ),
      ),
    );
  }
}
