// lib/models/dog_breed.dart
import 'package:flutter/foundation.dart';

@immutable
class DogBreed {
  final int id;
  final String name;           // UI에 쓸 이름 (한글 우선)
  final String? bredFor;
  final String? breedGroup;
  final String? lifeSpan;
  final String? temperament;
  final String? origin;
  final String? weightMetric;
  final String? heightMetric;
  final String? imageUrl;

  const DogBreed({
    required this.id,
    required this.name,
    this.bredFor,
    this.breedGroup,
    this.lifeSpan,
    this.temperament,
    this.origin,
    this.weightMetric,
    this.heightMetric,
    this.imageUrl,
  });

  /// (예전) TheDogAPI 원본 JSON용
  factory DogBreed.fromJson(Map<String, dynamic> json) {
    final weight = json['weight'] as Map<String, dynamic>?;
    final height = json['height'] as Map<String, dynamic>?;
    final image = json['image'] as Map<String, dynamic>?;

    return DogBreed(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: json['name'] ?? '',
      bredFor: json['bred_for'],
      breedGroup: json['breed_group'],
      lifeSpan: json['life_span'],
      temperament: json['temperament'],
      origin: json['origin'],
      weightMetric: weight?['metric'],
      heightMetric: height?['metric'],
      imageUrl: image?['url'],
    );
  }

  /// ✅ (새로운) Flask 서버 응답용
  factory DogBreed.fromFlaskJson(Map<String, dynamic> json) {
    return DogBreed(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      // 한글 이름이 있으면 먼저 쓰고, 없으면 영어 이름 사용
      name: (json['name_ko'] as String?) ??
          (json['name_en'] as String?) ??
          '',
      bredFor: json['bred_for_ko'] as String? ??
          json['bred_for_en'] as String?,
      breedGroup: json['breed_group_ko'] as String? ??
          json['breed_group_en'] as String?,
      lifeSpan: json['life_span_ko'] as String? ??
          json['life_span_en'] as String?,
      temperament: json['temperament_ko'] as String? ??
          json['temperament_en'] as String?,
      origin:
      json['origin_ko'] as String? ?? json['origin_en'] as String?,
      weightMetric: json['weight_kg'] as String?,
      heightMetric: json['height_cm'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
