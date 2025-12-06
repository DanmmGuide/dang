// lib/network/board_api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../pages/board/post.dart';

class BoardApiClient {
  // 에뮬레이터 → PC 플라스크 서버 주소
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  const BoardApiClient();

  Future<List<PostItem>> fetchPosts() async {
    final uri = Uri.parse('$baseUrl/posts');
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('게시글 목록 불러오기 실패: ${resp.statusCode} ${resp.body}');
    }

    final List<dynamic> jsonList = jsonDecode(resp.body) as List<dynamic>;
    return jsonList
        .map((e) => PostItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createPost(PostItem post, int userId) async {
    final uri = Uri.parse('$baseUrl/posts');

    final body = {
      'user_id': userId,
      'title': post.title,
      'content': post.content ?? '',
    };

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (resp.statusCode != 201) {
      throw Exception('status: ${resp.statusCode}, body: ${resp.body}');
    }
  }
}
