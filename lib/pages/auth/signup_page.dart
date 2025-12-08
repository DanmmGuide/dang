import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;

import '../../network/api_config.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwCheckController = TextEditingController();

  bool _obscurePw = true;
  bool _obscurePwCheck = true;
  bool _isAgreed = false;
  bool _isIdChecked = false;
  bool _isSubmitting = false;

  // ------------------
  // 약관 전문
  // ------------------
  final String _termsOfService = '''
(여기에 약관 내용...)
''';

  final String _privacyPolicy = '''
(여기에 개인정보 처리방침...)
''';

  @override
  void initState() {
    super.initState();
    _idController.addListener(() {
      if (_isIdChecked) {
        setState(() => _isIdChecked = false);
      }
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _pwCheckController.dispose();
    super.dispose();
  }

  // -----------------------
  // 아이디 중복확인 API
  // -----------------------
  Future<void> _checkIdDuplicate() async {
    final username = _idController.text.trim();

    if (username.isEmpty) {
      _showSnack("아이디를 입력해주세요.");
      return;
    }

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/users/check?username=$username');
      final resp = await http.get(uri);

      if (resp.statusCode != 200) {
        throw Exception("status: ${resp.statusCode}");
      }

      final json = jsonDecode(resp.body);
      final exists = json["exists"] as bool;

      if (exists) {
        setState(() => _isIdChecked = false);
        _showSnack("이미 사용 중인 아이디입니다.");
      } else {
        setState(() => _isIdChecked = true);
        _showDialog("사용 가능한 아이디입니다.");
      }
    } catch (e) {
      _showSnack("중복확인 실패: $e");
    }
  }

  // -----------------------
  // 회원가입 API
  // -----------------------
  Future<void> _submitSignup() async {
    if (_idController.text.isEmpty ||
        _pwController.text.isEmpty ||
        _pwCheckController.text.isEmpty) {
      _showSnack("모든 정보를 입력해주세요.");
      return;
    }

    if (!_isIdChecked) {
      _showSnack("아이디 중복확인을 해주세요.");
      return;
    }

    if (_pwController.text != _pwCheckController.text) {
      _showSnack("비밀번호가 일치하지 않습니다.");
      return;
    }

    if (!_isAgreed) {
      _showSnack("약관에 동의해주세요.");
      return;
    }

    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/users/register');

      final resp = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _idController.text.trim(),
          "password": _pwController.text.trim(),
        }),
      );

      if (resp.statusCode == 409) {
        setState(() => _isIdChecked = false);
        _showSnack("이미 존재하는 아이디입니다.");
        return;
      }

      if (resp.statusCode != 201) {
        throw Exception("status: ${resp.statusCode}");
      }

      final json = jsonDecode(resp.body);
      if (json["ok"] != true) {
        throw Exception(json["error"]);
      }

      _showSnack("회원가입이 완료되었습니다!");

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } catch (e) {
      _showSnack("회원가입 실패: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // -----------------------
  // UI 헬퍼
  // -----------------------
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showDialog(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인"),
          )
        ],
      ),
    );
  }

  // -----------------------
  // UI
  // -----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0E8DD),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "회원가입",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "환영합니다!\n간편하게 가입하고\n댕댕이와 함께해요.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),

            // -----------------------
            // 아이디 입력 + 중복확인 버튼
            // -----------------------
            _buildIdWithCheckButton(),
            const SizedBox(height: 20),

            // 비밀번호
            _buildPasswordField(
              label: "비밀번호",
              controller: _pwController,
              obscure: _obscurePw,
              toggle: () => setState(() => _obscurePw = !_obscurePw),
            ),

            const SizedBox(height: 20),

            // 비밀번호 확인
            _buildPasswordField(
              label: "비밀번호 확인",
              controller: _pwCheckController,
              obscure: _obscurePwCheck,
              toggle: () => setState(() => _obscurePwCheck = !_obscurePwCheck),
            ),

            const SizedBox(height: 20),

            // 약관 동의
            _buildAgreement(),

            const SizedBox(height: 30),

            // 가입 버튼
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFED6D11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  "가입 완료",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // 위젯들
  // -----------------------------------------------------------
  Widget _buildIdWithCheckButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "아이디",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _idController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF2EDE8),
                  hintText: "아이디를 입력하세요",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  _isIdChecked ? Colors.grey : const Color(0xFFED6D11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: _checkIdDuplicate,
                child: Text(
                  _isIdChecked ? "완료" : "중복확인",
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF2EDE8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreement() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _isAgreed,
          activeColor: const Color(0xFFED6D11),
          onChanged: (v) => setState(() => _isAgreed = v ?? false),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: "[필수] 서비스 이용약관",
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _showDialog(_termsOfService),
                ),
                const TextSpan(text: " 및 "),
                TextSpan(
                  text: "[필수] 개인정보 처리방침",
                  style: const TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _showDialog(_privacyPolicy),
                ),
                const TextSpan(text: "에 동의합니다."),
              ],
            ),
          ),
        )
      ],
    );
  }
}
