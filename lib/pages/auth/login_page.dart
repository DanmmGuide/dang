import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';              // RootScreen
import '../../network/api_config.dart';
import 'info_input_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool _obscurePw = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  // 로그인 이후, my_page 존재 여부에 따라 분기
  Future<void> _routeAfterLogin(int userId) async {
    final dio = Dio(
      BaseOptions(baseUrl: ApiConfig.baseUrl),
    );

    try {
      final res = await dio.get("/my_page/$userId");
      final data = res.data;

      final bool hasProfile =
          data != null &&
              (
                  (data["guardian_name"]?.toString().isNotEmpty ?? false) ||
                      (data["pet_name"]?.toString().isNotEmpty ?? false)
              );

      if (!mounted) return;

      if (hasProfile) {
        // 이미 프로필 있음 → 메인으로
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RootScreen(userId: userId),
          ),
        );
      } else {
        // 프로필 비어있음 → 최초 정보 입력
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => InfoInputPage(userId: userId),
          ),
        );
      }
    } on DioException catch (e) {
      if (!mounted) return;

      // 프로필 아예 없으면 404로 내려오는 경우 → 최초 정보 입력
      if (e.response?.statusCode == 404) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => InfoInputPage(userId: userId),
          ),
        );
      } else {
        debugPrint("프로필 확인 오류: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("프로필 확인 중 오류가 발생했습니다.")),
        );
      }
    }
  }

  Future<void> _onLoginPressed() async {
    if (_isLoading) return;

    final username = _idController.text.trim();
    final password = _pwController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디와 비밀번호를 입력해주세요.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/users/login');

      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (resp.statusCode != 200) {
        try {
          final Map<String, dynamic> json = jsonDecode(resp.body);
          final msg =
              json['error']?.toString() ?? '로그인 실패 (${resp.statusCode})';
          throw Exception(msg);
        } catch (_) {
          throw Exception('로그인 실패 (${resp.statusCode})');
        }
      }

      final Map<String, dynamic> json = jsonDecode(resp.body);

      if (json['ok'] != true) {
        throw Exception(json['error'] ?? '로그인 실패');
      }

      final Map<String, dynamic> user =
      json['user'] as Map<String, dynamic>;

      // 🔥 여기서 userId + username 꺼내기
      final int userId = user['id'] as int;
      final String userName = user['username'] as String;

      // 🔥 SharedPreferences에 로그인 정보 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      await prefs.setString('username', userName);

      if (!mounted) return;

      // ✅ 로그인 성공 후 프로필 유무에 따라 분기
      await _routeAfterLogin(userId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0E8DD),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '로그인',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 402),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. 상단 이미지 영역
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/start.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 2. 텍스트 영역
                const Column(
                  children: [
                    Text(
                      '댕가이드',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '여러분들의 소중한 아이들\n똑똑하게 배워요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 3. 아이디 입력
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '아이디',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _idController,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF2EDE8),
                    hintText: '아이디를 입력하세요',
                    hintStyle:
                    const TextStyle(color: Colors.grey, fontSize: 13),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                      BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                      BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide(
                        color: Color(0xFFED6D11),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 4. 비밀번호 입력
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '비밀번호',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _pwController,
                  obscureText: _obscurePw,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF2EDE8),
                    hintText: '비밀번호를 입력하세요',
                    hintStyle:
                    const TextStyle(color: Colors.grey, fontSize: 13),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePw
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePw = !_obscurePw;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                      BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                      BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide(
                        color: Color(0xFFED6D11),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 5. 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFED6D11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isLoading ? null : _onLoginPressed,
                    child: Text(
                      _isLoading ? '로그인 중...' : '로그인',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


