// lib/network/the_dog_api_client.dart

import '../models/dog_breed.dart';

/// TheDogAPI 통신 전용 클라이언트 (현재는 '틀'만 있음)
class TheDogApiClient {
  static const String baseUrl = 'https://api.thedogapi.com/v1';

  /// TODO: 실제 API 키 주입
  final String apiKey;

  const TheDogApiClient({required this.apiKey});

  /// 모든 품종 리스트 가져오기
  /// 실제 구현은 나중에 http 패키지 붙일 때 작성
  Future<List<DogBreed>> fetchBreeds() async {
    // TODO: http.get('$baseUrl/breeds') 구현
    throw UnimplementedError('fetchBreeds() 아직 구현 안 됨');
  }

  /// 특정 품종 상세 정보 가져오기 (옵션)
  Future<DogBreed> fetchBreedDetail(int breedId) async {
    // TODO: http.get('$baseUrl/breeds/$breedId') 구현
    throw UnimplementedError('fetchBreedDetail() 아직 구현 안 됨');
  }
}
