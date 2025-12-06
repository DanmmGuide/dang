import '../../models/dog_breed.dart';

class BreedItem {
  final DogBreed breed;

  final bool isBeginnerFriendly;
  final bool isApartmentFriendly;
  final String activityLevel;

  /// 한국어 이름(서버 제공), 없으면 null
  final String? nameKo;

  const BreedItem({
    required this.breed,
    required this.isBeginnerFriendly,
    required this.isApartmentFriendly,
    required this.activityLevel,
    this.nameKo,
  });

  /// UI 표시 이름: nameKo → breed.nameKo → breed.nameEn 순서로 fallback
  String get name {
    if (nameKo != null && nameKo!.trim().isNotEmpty) return nameKo!;
    if (breed.nameKo.trim().isNotEmpty) return breed.nameKo;
    return breed.nameEn;
  }

  String? get imageUrl => breed.imageUrl;

  /// weightKg 기준으로 소형/중형/대형 계산
  String get size => _sizeFromWeight(breed.weightKg);

  // ───────── 크기 계산 로직 ─────────
  String _sizeFromWeight(String? weightKg) {
    if (weightKg == null || weightKg.isEmpty) return '정보 없음';

    final parts = weightKg
        .split(RegExp(r'[- ]'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final first = parts.isNotEmpty ? int.tryParse(parts.first) : null;

    if (first == null) return '정보 없음';

    if (first <= 5) return '소형';
    if (first <= 15) return '중형';
    return '대형';
  }

  // ───────── factory 변환 (DogBreed → BreedItem) ─────────
  factory BreedItem.fromDogBreed(DogBreed dog, {String? nameKo}) {
    final size = _staticSizeFromWeight(dog.weightKg);

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

  // static size 계산
  static String _staticSizeFromWeight(String? weightKg) {
    if (weightKg == null || weightKg.isEmpty) return '정보 없음';

    final parts = weightKg
        .split(RegExp(r'[- ]'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final first = parts.isNotEmpty ? int.tryParse(parts.first) : null;

    if (first == null) return '정보 없음';

    if (first <= 5) return '소형';
    if (first <= 15) return '중형';
    return '대형';
  }
}
