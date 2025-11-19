// lib/repositories/dog_repository.dart

import '../models/dog_breed.dart';
import '../network/TheDogAPI_client.dart';

/// 가이드/다른 페이지에서 사용할 Dog 데이터 저장소 (중간 레이어)
class DogRepository {
  final TheDogApiClient apiClient;

  const DogRepository({required this.apiClient});

  /// 품종 리스트 가져오기
  Future<List<DogBreed>> getAllBreeds() {
    // 나중에 캐시, 로컬 저장소, 필터 등 붙일 수 있게 중간 레이어로 둠
    return apiClient.fetchBreeds();
  }

  Future<DogBreed> getBreedById(int id) {
    return apiClient.fetchBreedDetail(id);
  }
}
