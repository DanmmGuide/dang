// lib/start_page.dart
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 402,
            height: 874,
            child: _StartPageContent(),
          ),
        ),
      ),
    );
  }
}

class _StartPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402,
      height: 874,
      decoration: const BoxDecoration(color: Color(0xFFFCF9F7)),
      child: Column(
        children: [
          // -----------------------
          // 상단 배경 이미지 + 문구
          // -----------------------
          Container(
            width: 402,
            height: 598,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://placehold.co/402x598"),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 121,
                  top: 506,
                  child: Text(
                    '댕가이드',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.28),
                      fontSize: 16,
                    ),
                  ),
                ),
                Positioned(
                  left: 87,
                  top: 550,
                  child: Text(
                    '여러분들의 소중한 아이들\n똑똑하게 배워요',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // -----------------------
          // 로그인 & 회원가입 버튼
          // -----------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // 로그인 버튼
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFED6D11),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // 회원가입 버튼
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignupPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFF2EDE8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
