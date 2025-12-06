// lib/models/dog_breed.dart
class DogBreed {
  final int id;
  final String nameKo;
  final String nameEn;
  final String? temperamentKo;
  final String? temperamentEn;
  final String? bredForKo;
  final String? bredForEn;
  final String? breedGroupKo;
  final String? breedGroupEn;
  final String? lifeSpanKo;
  final String? lifeSpanEn;
  final String? originKo;
  final String? originEn;
  final String? weightKg;
  final String? heightCm;
  final String? imageUrl;

  DogBreed({
    required this.id,
    required this.nameKo,
    required this.nameEn,
    this.temperamentKo,
    this.temperamentEn,
    this.bredForKo,
    this.bredForEn,
    this.breedGroupKo,
    this.breedGroupEn,
    this.lifeSpanKo,
    this.lifeSpanEn,
    this.originKo,
    this.originEn,
    this.weightKg,
    this.heightCm,
    this.imageUrl,
  });

  factory DogBreed.fromJson(Map<String, dynamic> json) {
    return DogBreed(
      id: json['id'] as int,
      nameEn: json['name_en'] as String? ?? '',
      nameKo: json['name_ko'] as String? ?? json['name_en'] as String? ?? '',
      temperamentEn: json['temperament_en'] as String?,
      temperamentKo: json['temperament_ko'] as String?,
      bredForEn: json['bred_for_en'] as String?,
      bredForKo: json['bred_for_ko'] as String?,
      breedGroupEn: json['breed_group_en'] as String?,
      breedGroupKo: json['breed_group_ko'] as String?,
      lifeSpanEn: json['life_span_en'] as String?,
      lifeSpanKo: json['life_span_ko'] as String?,
      originEn: json['origin_en'] as String?,
      originKo: json['origin_ko'] as String?,
      weightKg: json['weight_kg'] as String?,
      heightCm: json['height_cm'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
