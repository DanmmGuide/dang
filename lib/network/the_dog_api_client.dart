import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dog_breed.dart';

class TheDogApiClient {
  /// 에뮬레이터 기준 PC의 Flask 서버 주소
  /// (PC에서 Flask가 5000포트로 뜨고 있을 때)
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  const TheDogApiClient();

  /// Flask 서버에서 번역까지 된 견종 리스트 가져오기
  ///
  /// 실제 호출되는 URL 예시:
  ///   GET /api/dogs/breeds?limit=20&translate=true
  Future<List<DogBreed>> fetchBreeds({
    int limit = 50,
    bool translate = true,
  }) async {
    final uri = Uri.parse('$baseUrl/dogs/breeds').replace(
      queryParameters: {
        'limit': '$limit',
        'translate': translate.toString(), // "true" / "false"
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load breeds from Flask server: '
            '${response.statusCode} ${response.body}',
      );
    }

    // Flask 응답 구조:
    // {
    //   "ok": true,
    //   "count": ...,
    //   "breeds": [ {...}, {...}, ... ]
    // }
    final Map<String, dynamic> jsonMap =
    jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> breedsJson =
    (jsonMap['breeds'] as List<dynamic>? ?? <dynamic>[]);

    return breedsJson
        .map((e) => DogBreed.fromFlaskJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 특정 품종 상세 정보 (지금 Flask에는 /dogs/breeds/<id> 라우트가 없어서 일단 보류)
  ///
  /// 나중에 Flask에
  ///   GET /api/dogs/breeds/<id>
  /// 같은 엔드포인트를 만들면 여기서 붙이면 됨.
  Future<DogBreed> fetchBreedDetail(int breedId) async {
    throw UnimplementedError(
      'Flask 서버에 /api/dogs/breeds/<id> 엔드포인트가 아직 없습니다.',
    );
  }
}

