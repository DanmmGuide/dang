import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const InfoInputPage(),
      ),
    );
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
            // fontFamily 제거됨
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
                            child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
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
                        // fontFamily 제거됨
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
                        // fontFamily 제거됨
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
                      // fontFamily 제거됨
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _idController,
                  style: const TextStyle(fontSize: 14), // fontFamily 제거됨
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF2EDE8),
                    hintText: '아이디를 입력하세요',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13), // fontFamily 제거됨
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Color(0xFFED6D11), width: 2),
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
                      // fontFamily 제거됨
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _pwController,
                  obscureText: _obscurePw,
                  style: const TextStyle(fontSize: 14), // fontFamily 제거됨
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF2EDE8),
                    hintText: '비밀번호를 입력하세요',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13), // fontFamily 제거됨
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePw ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _obscurePw = !_obscurePw;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: Color(0xFFED6D11), width: 2),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    onPressed: _onLoginPressed,
                    child: const Text(
                      '로그인',
                      style: TextStyle(
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