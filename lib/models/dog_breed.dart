// lib/models/dog_breed.dart
import 'package:flutter/foundation.dart';

@immutable
class DogBreed {
  final int id;
  final String name;
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

  /// 나중에 실제 API 붙일 때 쓸 팩토리
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bred_for': bredFor,
      'breed_group': breedGroup,
      'life_span': lifeSpan,
      'temperament': temperament,
      'origin': origin,
      'weight': {
        'metric': weightMetric,
      },
      'height': {
        'metric': heightMetric,
      },
      'image': {
        'url': imageUrl,
      },
    };
  }
}
