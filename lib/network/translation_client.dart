// lib/network/translation_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationClient {
  final String baseUrl; // 예: http://192.168.0.10:5000

  const TranslationClient({required this.baseUrl});

  Future<Map<String, String>> translateNames(List<String> names) async {
    if (names.isEmpty) return {};

    final uri = Uri.parse('$baseUrl/translate_names');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'names': names}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        '번역 서버 오류: ${response.statusCode} ${response.body}',
      );
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    final List<dynamic> items = json['items'] as List<dynamic>;

    final Map<String, String> map = {};
    for (final item in items) {
      final obj = item as Map<String, dynamic>;
      map[obj['en'] as String] = obj['ko'] as String;
    }

    return map;
  }
}

