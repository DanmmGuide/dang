// lib/guide/breed_item.dart
class BreedItem {
  final String name;
  final String imagePath; // assets 이미지 경로
  final String size; // '소형', '중형', '대형'
  final bool isBeginnerFriendly; // 초보자에게 좋은지
  final bool isApartmentFriendly; // 아파트 적합 여부
  final String activityLevel; // '낮음', '보통', '높음'

  const BreedItem({
    required this.name,
    required this.imagePath,
    required this.size,
    required this.isBeginnerFriendly,
    required this.isApartmentFriendly,
    required this.activityLevel,
  });
}