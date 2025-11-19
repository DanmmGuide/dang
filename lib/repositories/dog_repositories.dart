// lib/repositories/dog_repository.dart

import '../models/dog_breed.dart';
import '../network/the_dog_api_client.dart';
import '../database/dog_breed_dao.dart';

class DogRepository {
  final TheDogApiClient apiClient;
  final DogBreedDao dao;

  DogRepository({
    required this.apiClient,
    required this.dao,
  });

  /// 기본 전략:
  /// 1) 로컬 DB에서 먼저 읽어서 화면에 보여주고
  /// 2) 필요하면 API로 최신 데이터 받아서 DB 갱신
  Future<List<DogBreed>> getBreeds({bool forceRefresh = false}) async {
    final local = await dao.getAllBreeds();

    if (local.isNotEmpty && !forceRefresh) {
      // 로컬 데이터 우선 반환
      // (원하면 여기서 _refreshInBackground() 돌릴 수도 있음)
      return local;
    }

    // 로컬에 없거나 강제 리프레시일 때: API 호출
    final remote = await apiClient.fetchBreeds();
    await dao.replaceAll(remote);
    return remote;
  }

  /// 강제로 최신 데이터만 받고 싶을 때 호출
  Future<List<DogBreed>> refreshBreeds() => getBreeds(forceRefresh: true);
}
