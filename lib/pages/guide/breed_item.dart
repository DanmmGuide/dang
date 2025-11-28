// lib/guide/breed_item.dart  (또는 lib/pages/guide/breed_item.dart)

import '../../models/dog_breed.dart';

/// UI에서 쓰기 좋은 형태로 DogBreed를 감싼 래퍼 모델
class BreedItem {
  final DogBreed breed;

  final bool isBeginnerFriendly;
  final bool isApartmentFriendly;
  final String activityLevel;

  /// 번역된 한국어 이름 (없으면 null)
  final String? nameKo;

  const BreedItem({
    required this.breed,
    required this.isBeginnerFriendly,
    required this.isApartmentFriendly,
    required this.activityLevel,
    this.nameKo,
  });

  /// UI에서 쓸 이름: nameKo가 있으면 한국어, 없으면 영어
  String get name => nameKo ?? breed.name;

  String? get imageUrl => breed.imageUrl;

  String get size => _sizeFromWeight(breed.weightMetric);

  // ───────── UI에서 편하게 쓰려고 만든 getter들 ─────────


  /// TheDogAPI의 weight.metric(예: "3 - 6")을 기준으로 소/중/대형 대충 구분
  String _sizeFromWeight(String? weightMetric) {
    if (weightMetric == null || weightMetric.isEmpty) return '정보 없음';

    // "3 - 6" 같은 문자열에서 앞 숫자만 뽑기
    final parts = weightMetric
        .split(RegExp(r'[- ]'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final first = parts.isNotEmpty ? int.tryParse(parts.first) : null;

    if (first == null) return '정보 없음';

    if (first <= 5) {
      return '소형';
    } else if (first <= 15) {
      return '중형';
    } else {
      return '대형';
    }
  }

  // ───────── DogBreed → BreedItem 자동 변환 팩토리 ─────────

  /// DogBreed 하나를 받아서, 앱에서 쓰기 좋은 BreedItem으로 변환
  factory BreedItem.fromDogBreed(DogBreed dog, {String? nameKo}) {
    final size = _staticSizeFromWeight(dog.weightMetric);

    String activityLevel;
    bool isApartmentFriendly;
    bool isBeginnerFriendly;

    switch (size) {
      case '소형':
        activityLevel = '낮음';
        isApartmentFriendly = true;
        isBeginnerFriendly = true;
        break;
      case '중형':
        activityLevel = '보통';
        isApartmentFriendly = true;
        isBeginnerFriendly = true;
        break;
      case '대형':
        activityLevel = '높음';
        isApartmentFriendly = false;
        isBeginnerFriendly = false;
        break;
      default:
        activityLevel = '보통';
        isApartmentFriendly = true;
        isBeginnerFriendly = true;
    }

    return BreedItem(
      breed: dog,
      isBeginnerFriendly: isBeginnerFriendly,
      isApartmentFriendly: isApartmentFriendly,
      activityLevel: activityLevel,
      nameKo: nameKo,
    );
  }

  /// static 버전: factory에서 쓰려고 분리한 크기 계산 함수
  static String _staticSizeFromWeight(String? weightMetric) {
    if (weightMetric == null || weightMetric.isEmpty) return '정보 없음';

    final parts = weightMetric
        .split(RegExp(r'[- ]'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final first = parts.isNotEmpty ? int.tryParse(parts.first) : null;

    if (first == null) return '정보 없음';

    if (first <= 5) {
      return '소형';
    } else if (first <= 15) {
      return '중형';
    } else {
      return '대형';
    }
  }
}