// lib/pages/guide/widgets/breed_guide_card.dart

import 'package:flutter/material.dart';
import '../../../models/dog_breed.dart';

class BreedGuideCard extends StatelessWidget {
  final DogBreed breed;

  const BreedGuideCard({
    super.key,
    required this.breed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF7EADA),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 (이미지 URL이 있을 때만 사용)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: breed.imageUrl != null
                  ? Image.network(
                breed.imageUrl!,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 72,
                height: 72,
                color: Colors.brown.withOpacity(0.2),
                child: const Icon(Icons.pets),
              ),
            ),
            const SizedBox(width: 12),
            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (breed.breedGroup != null)
                    Text(
                      breed.breedGroup!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.brown,
                      ),
                    ),
                  if (breed.lifeSpan != null)
                    Text(
                      '수명: ${breed.lifeSpan}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  if (breed.temperament != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      breed.temperament!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
