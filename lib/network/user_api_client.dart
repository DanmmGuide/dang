import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class UserApiClient {
  final String baseUrl = ApiConfig.baseUrl;

  const UserApiClient();

  /// 회원탈퇴: username + password 로 인증해서 삭제
  Future<void> deleteUser({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/users/delete');

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception("회원탈퇴 실패: ${resp.statusCode} ${resp.body}");
    }

    final json = jsonDecode(resp.body);
    if (json == null || json['ok'] != true) {
      throw Exception("회원탈퇴 실패: 응답 오류 $json");
    }
  }
}
