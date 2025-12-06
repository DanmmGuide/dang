// lib/network/dog_breed_api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/dog_breed.dart';
import 'api_config.dart';

class DogBreedApiClient {
  const DogBreedApiClient();

  Future<List<DogBreed>> fetchBreeds() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/breeds');

    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Failed to load breeds: ${resp.statusCode} ${resp.body}');
    }

    final Map<String, dynamic> data =
    jsonDecode(resp.body) as Map<String, dynamic>;

    if (data['ok'] != true) {
      throw Exception('Server error: ${data['error'] ?? 'unknown'}');
    }

    final List<dynamic> list = data['breeds'] as List<dynamic>;

    return list
        .map((e) => DogBreed.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DogBreed> fetchBreedDetail(int id) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/breeds/$id');

    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Failed to load breed detail: ${resp.statusCode}');
    }

    final Map<String, dynamic> data =
    jsonDecode(resp.body) as Map<String, dynamic>;

    if (data['ok'] != true) {
      throw Exception('Server error: ${data['error'] ?? 'unknown'}');
    }

    return DogBreed.fromJson(data['breed'] as Map<String, dynamic>);
  }
}
