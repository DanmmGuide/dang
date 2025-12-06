// breed_detail_page.dart
import 'package:flutter/material.dart';
import 'breed_item.dart';

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
    // 서버에서 온 DogBreed 원본 데이터 (ko/en 둘 다 가지고 있음)
    final dog = breed.breed;

    // 한국어 우선, 없으면 영어로 fallback
    final lifeSpan =
        dog.lifeSpanKo ?? dog.lifeSpanEn ?? '정보 없음';
    final temperament =
        dog.temperamentKo ?? dog.temperamentEn ?? '정보 없음';
    final origin =
        dog.originKo ?? dog.originEn ?? '정보 없음';
    final bredFor =
        dog.bredForKo ?? dog.bredForEn ?? '정보 없음';
    final group =
        dog.breedGroupKo ?? dog.breedGroupEn ?? '정보 없음';
    final weight = dog.weightKg ?? '정보 없음';
    final height = dog.heightCm ?? '정보 없음';

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
            // ───────── 대표 이미지 ─────────
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: breed.imageUrl != null
                  ? Image.network(
                breed.imageUrl!,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
              )
                  : _buildImagePlaceholder(),
            ),

            const SizedBox(height: 16),

            // 영어 이름 있으면 서브타이틀로 보여주기 (옵션)
            if (dog.nameEn.isNotEmpty)
              Center(
                child: Text(
                  dog.nameEn,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 14,
                    fontFamily: 'Lexend',
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // ───────── 기본 정보 섹션 ─────────
            buildSectionTitle("기본 정보"),
            const SizedBox(height: 6),
            buildSectionContent(
              '품종 그룹: $group\n'
                  '원산지: $origin\n'
                  '체중(kg): $weight\n'
                  '체고(cm): $height',
            ),

            const SizedBox(height: 20),

            // ───────── 성격 / 기질 ─────────
            buildSectionTitle("성격 / 기질"),
            const SizedBox(height: 6),
            buildSectionContent(temperament),

            const SizedBox(height: 20),

            // ───────── 사역 목적(원래 무엇을 위해 길러졌는지) ─────────
            buildSectionTitle("원래 역할 / 사역 목적"),
            const SizedBox(height: 6),
            buildSectionContent(bredFor),

            const SizedBox(height: 20),

            // ───────── 평균 수명 ─────────
            buildSectionTitle("평균 수명"),
            const SizedBox(height: 6),
            buildSectionContent(lifeSpan),

            const SizedBox(height: 20),

            // ───────── 환경 적합성 (앱에서 정한 로직 기반) ─────────
            buildSectionTitle("환경 적합성"),
            const SizedBox(height: 6),
            buildSectionContent(
              _buildEnvironmentText(
                isApartmentFriendly: breed.isApartmentFriendly,
                size: breed.size,
              ),
            ),

            const SizedBox(height: 20),

            // ───────── 활동량 / 산책 ─────────
            buildSectionTitle("활동량 / 산책 필요 시간"),
            const SizedBox(height: 6),
            buildSectionContent(
              _buildActivityText(breed.activityLevel),
            ),

            const SizedBox(height: 20),

            // ───────── 훈련 난이도 ─────────
            buildSectionTitle("훈련 난이도"),
            const SizedBox(height: 6),
            buildSectionContent(
              _buildTrainingText(
                isBeginnerFriendly: breed.isBeginnerFriendly,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이미지 없거나 에러났을 때 대체 위젯
  Widget _buildImagePlaceholder() {
    return Container(
      height: 240,
      width: double.infinity,
      color: Colors.brown.withOpacity(0.2),
      child: const Center(
        child: Icon(
          Icons.pets,
          size: 48,
        ),
      ),
    );
  }

  // 활동량에 따라 문구 다르게
  String _buildActivityText(String activityLevel) {
    switch (activityLevel) {
      case '낮음':
        return '활동량이 낮은 편이라 짧은 산책과 실내 놀이로도 충분해요.';
      case '높음':
        return '활동량이 높은 편이라 하루 1시간 이상, 충분한 산책과 놀이가 필요해요.';
      case '보통':
      default:
        return '하루 30분~1시간 정도의 산책과 적당한 놀이가 필요해요.';
    }
  }

  // 초보자/아파트 여부 기준으로 훈련 난이도 설명
  String _buildTrainingText({required bool isBeginnerFriendly}) {
    if (isBeginnerFriendly) {
      return '비교적 훈련 난이도가 낮아 초보 보호자도 충분히 함께할 수 있어요.';
    } else {
      return '훈련 난이도가 다소 높은 편이라, 경험 있는 보호자나 꾸준한 훈련이 필요해요.';
    }
  }

  // 아파트 적합 + 크기 기준 환경 설명
  String _buildEnvironmentText({
    required bool isApartmentFriendly,
    required String size,
  }) {
    final buffer = StringBuffer();

    if (isApartmentFriendly) {
      buffer.write('아파트/실내 환경에서도 잘 적응하는 편이에요.\n');
    } else {
      buffer.write('넓은 마당이나 야외 활동이 많은 환경이 더 잘 맞을 수 있어요.\n');
    }

    buffer.write('크기: $size');

    return buffer.toString();
  }
}
