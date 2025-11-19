import 'package:flutter/material.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget
{
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0E8DD),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '회원가입',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 402),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // [사용자 정보]
                  const Text(
                    '[사용자 정보]',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const InfoChip(
                    label: '아이디',
                    value: '혀누',   // TODO: 실제 값으로 교체
                  ),

                  const SizedBox(height: 24),

                  // [반려동물 정보]
                  const Text(
                    '[반려동물 정보]',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const InfoChip(
                    label: '반려동물 이름',
                    value: '코코',   // TODO: 실제 값으로 교체
                  ),
                  const SizedBox(height: 8),
                  const InfoChip(
                    label: '종',
                    value: '랙돌',   // TODO: 실제 값으로 교체
                  ),
                  const SizedBox(height: 8),
                  const InfoChip(
                    label: '생년월일',
                    value: '2024.02.15.',  // TODO: 실제 값으로 교체
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: const [
                      Expanded(
                        child: InfoChip(
                          label: '성별',
                          value: '수컷', // TODO
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: InfoChip(
                          label: '중성화',
                          value: 'O',   // TODO
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: const [
                      Expanded(
                        child: InfoChip(
                          label: '몸무게',
                          value: '7.5 kg', // TODO
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: InfoChip(
                          label: '기타',
                          value: '-',       // TODO
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // 확인 버튼
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
                      onPressed: ()
                      {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          color: Color(0xFFFCF9F7),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 라벨 | 값 형태의 공통 Chip 위젯
class InfoChip extends StatelessWidget
{
  final String label;
  final String value;

  const InfoChip({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context)
  {
    return Container(
      height: 47,
      decoration: BoxDecoration(
        color: const Color(0xFFF2EDE8),
        borderRadius: BorderRadius.circular(80.5),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            '|',
            style: TextStyle(
              color: Color(0xFF897260),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
