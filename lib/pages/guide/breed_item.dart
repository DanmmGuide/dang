// lib/guide/breed_item.dart  (또는 lib/pages/guide/breed_item.dart)

import '../../models/dog_breed.dart';

/// UI에서 쓰기 좋은 형태로 DogBreed를 감싼 래퍼 모델
class BreedItem {
  /// TheDogAPI에서 받아온 원본 품종 데이터
  final DogBreed breed;

  /// 초보자에게 좋은 품종인지
  final bool isBeginnerFriendly;

  /// 아파트에서 키우기 적합한지
  final bool isApartmentFriendly;

  /// 활동량: '낮음', '보통', '높음'
  final String activityLevel;

  const BreedItem({
    required this.breed,
    required this.isBeginnerFriendly,
    required this.isApartmentFriendly,
    required this.activityLevel,
  });

  // ───────── UI에서 편하게 쓰려고 만든 getter들 ─────────

  /// 품종 이름
  String get name => breed.name;

  /// 이미지 URL (없으면 null)
  String? get imageUrl => breed.imageUrl;

  /// 크기: '소형', '중형', '대형' (weightMetric 기준 대충 나눔)
  String get size => _sizeFromWeight(breed.weightMetric);

  /// TheDogAPI의 weight.metric(예: "3 - 6")을 기준으로 소/중/대형 대충 구분
  String _sizeFromWeight(String? weightMetric) {
    if (weightMetric == null || weightMetric.isEmpty) return '정보 없음';

    // 예: "3 - 6" → "3" → 3kg
    final first = int.tryParse(
      weightMetric.split(RegExp(r'[- ]')).first,
    );

    if (first == null) return '정보 없음';

    if (first <= 5) {
      return '소형';
    }
    else if (first > 5 && first <= 15) {
      return '중형';
    }
    else{
      return '대형';
    }
  }
}
