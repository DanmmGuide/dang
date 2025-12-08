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
  // 약관 전문 (기존 유지)
  // ------------------
  final String _termsOfService = '''
제1조 (목적)
본 약관은 '댕가이드'(이하 "회사")가 제공하는 서비스의 이용조건 및 절차, 이용자와 회사의 권리, 의무, 책임사항 및 기타 필요한 사항을 규정함을 목적으로 합니다.

제2조 (용어의 정의)
1. "서비스"란 회원이 모바일 단말기를 이용하여 반려동물의 정보를 기록하고, 정보를 공유하며, 커뮤니티 활동을 할 수 있는 제반 서비스를 의미합니다.
2. "회원"이란 본 약관에 동의하고 가입 절차를 마친 자로서, 회사가 제공하는 서비스를 이용할 수 있는 자를 말합니다.
3. "아이디(ID)"란 회원의 식별과 서비스 이용을 위하여 회원이 정하고 회사가 승인하는 문자와 숫자의 조합을 의미합니다.
4. "비밀번호"란 회원이 부여받은 아이디와 일치되는 회원임을 확인하고 비밀보호를 위해 회원 자신이 정한 문자 또는 숫자의 조합을 의미합니다.

제3조 (약관의 효력 및 변경)
1. 본 약관은 서비스를 이용하고자 하는 모든 회원에게 효력을 발생합니다.
2. 회사는 필요한 경우 관련 법령을 위배하지 않는 범위 내에서 본 약관을 변경할 수 있으며, 변경된 약관은 서비스 내 공지사항을 통해 공지함으로써 효력이 발생합니다.

제4조 (회원가입)
1. 이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 본 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청합니다.
2. 회사는 다음 각 호에 해당하는 경우 회원가입을 승낙하지 않거나 유보할 수 있습니다.
  - 실명이 아니거나 타인의 명의를 이용한 경우
  - 허위 정보를 기재하거나, 회사가 제시하는 내용을 기재하지 않은 경우
  - 이용자의 귀책사유로 인하여 승인이 불가능하거나 기타 규정한 제반 사항을 위반하며 신청하는 경우

제5조 (회원의 의무)
1. 회원은 관계법령, 본 약관의 규정, 이용안내 및 서비스와 관련하여 공지한 주의사항, 회사가 통지하는 사항 등을 준수해야 하며, 기타 회사의 업무에 방해되는 행위를 하여서는 안 됩니다.
2. 회원은 자신의 아이디와 비밀번호를 유지 관리할 책임이 있으며, 이를 제3자에게 양도하거나 대여해서는 안 됩니다. 만약 자신의 아이디가 부정하게 사용된 경우, 즉시 회사에 통보하고 회사의 안내에 따라야 합니다.

제6조 (서비스의 제공 및 변경)
1. 회사는 회원에게 아래와 같은 서비스를 제공합니다.
  - 반려동물 프로필 관리 서비스
  - 반려동물 관련 정보 제공 서비스
  - 커뮤니티(게시판) 서비스
  - 기타 회사가 추가 개발하거나 제휴 계약 등을 통해 회원에게 제공하는 일체의 서비스
2. 회사는 운영상, 기술상의 필요에 따라 제공하고 있는 전부 또는 일부 서비스를 변경할 수 있습니다.

제7조 (계약 해지 및 이용 제한)
1. 회원은 언제든지 서비스 내 "회원 탈퇴" 기능을 통해 이용계약 해지 신청을 할 수 있으며, 회사는 관련 법령 등이 정하는 바에 따라 이를 즉시 처리하여야 합니다.
2. 회원이 계약을 해지할 경우, 관련 법령 및 개인정보처리방침에 따라 회사가 회원정보를 보유하는 경우를 제외하고는 해지 즉시 회원의 모든 데이터는 소멸됩니다.
''';

  final String _privacyPolicy = '''
1. 개인정보의 수집 및 이용 목적
'댕가이드'는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.
- 회원 가입 의사 확인, 회원 식별/인증, 회원자격 유지/관리
- 서비스 부정이용 방지, 각종 고지/통지, 고충처리
- 반려동물 맞춤형 콘텐츠 및 정보 제공

2. 수집하는 개인정보의 항목
회사는 회원가입, 고객상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.
가. 필수항목: 아이디, 비밀번호
나. 선택항목(서비스 이용 중 수집): 반려동물 정보(이름, 견종, 생년월일, 성별, 중성화 여부, 몸무게 등)
다. 서비스 이용 과정에서 자동 수집 정보: 접속 로그, 접속 IP 정보, 쿠키, 기기정보, 서비스 이용 기록

3. 개인정보의 보유 및 이용 기간
이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.
- 보존 항목: 아이디, 서비스 이용기록
- 보존 근거: 서비스 이용의 혼선 방지, 부정이용 방지
- 보존 기간: 회원 탈퇴 후 3개월

4. 개인정보의 파기절차 및 방법
회사는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.
- 파기절차: 이용자가 회원가입 등을 위해 입력한 정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조) 일정 기간 저장된 후 파기됩니다.
- 파기방법: 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.

5. 이용자 및 법정대리인의 권리와 그 행사방법
이용자는 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며 가입해지를 요청할 수 있습니다. 이용자의 개인정보 조회/수정을 위해서는 '개인정보변경'(또는 '회원정보수정' 등)을, 가입해지(동의철회)를 위해서는 "회원탈퇴"를 클릭하여 본인 확인 절차를 거치신 후 직접 열람, 정정 또는 탈퇴가 가능합니다.
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
  // 아이디 중복확인 API (기존 유지)
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
  // 회원가입 API (기존 유지)
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
        MaterialPageRoute(builder: (_) => const LoginPage()),
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
    const Color backgroundColor = Color(0xFFF0E8DD); // 베이지 배경
    const Color buttonColor = Color(0xFFED6D11); // 주황색

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "환영합니다!\n간편하게 가입하고\n댕댕이와 함께해요.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.4,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),

            // -----------------------
            // 아이디 입력 + 중복확인 버튼
            // -----------------------
            _buildIdWithCheckButton(buttonColor),
            const SizedBox(height: 20),

            // 비밀번호
            _buildPasswordField(
              label: "비밀번호",
              hint: "비밀번호를 입력하세요",
              controller: _pwController,
              obscure: _obscurePw,
              toggle: () => setState(() => _obscurePw = !_obscurePw),
            ),

            const SizedBox(height: 20),

            // 비밀번호 확인
            _buildPasswordField(
              label: "비밀번호 확인",
              hint: "비밀번호를 한번 더 입력하세요",
              controller: _pwCheckController,
              obscure: _obscurePwCheck,
              toggle: () => setState(() => _obscurePwCheck = !_obscurePwCheck),
            ),

            const SizedBox(height: 24),

            // 약관 동의
            _buildAgreement(),

            const SizedBox(height: 40),

            // 가입 버튼
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "가입 완료",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // 위젯들 (디자인 수정됨, 힌트 왼쪽 정렬 추가)
  // -----------------------------------------------------------
  Widget _buildIdWithCheckButton(Color buttonColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "아이디",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _idController,
                  textAlign: TextAlign.start, // 👈 힌트 텍스트 왼쪽 정렬
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF2EDE8), // 연한 회색 배경
                    hintText: "아이디를 입력하세요",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: buttonColor),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 50,
              width: 100, // 버튼 너비 고정
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isIdChecked ? Colors.grey : buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                onPressed: _checkIdDuplicate,
                child: Text(
                  _isIdChecked ? "완료" : "중복확인",
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
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
    required String hint,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            obscureText: obscure,
            textAlign: TextAlign.start, // 👈 힌트 텍스트 왼쪽 정렬
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF2EDE8),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Color(0xFFED6D11)),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: toggle,
              ),
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
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _isAgreed,
            activeColor: const Color(0xFFED6D11),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide(color: Colors.black.withOpacity(0.5)),
            onChanged: (v) => setState(() => _isAgreed = v ?? false),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2), // 텍스트 높이 보정
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.4),
                children: [
                  TextSpan(
                    text: "[필수] 서비스 이용약관",
                    style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showDialog(_termsOfService),
                  ),
                  const TextSpan(text: " 및 "),
                  TextSpan(
                    text: "[필수] 개인정보 처리방침",
                    style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _showDialog(_privacyPolicy),
                  ),
                  const TextSpan(text: "에\n동의합니다."),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}