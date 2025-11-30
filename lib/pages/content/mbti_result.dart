import 'package:flutter/material.dart';

class MBTIResultPage extends StatelessWidget {
  final VoidCallback onRestartPressed;
  final VoidCallback onBackPressed;

  final String resultType = 'ISTJ';
  final String resultTitle = '빈틈없는 원칙주의자\n모범생 강아지';

  final List<String> features = const [
    '산책할 때 늘 가던 길로 가는 것을 편안해해요.',
    '낯선 사람이나 친구에게는 신중하게 다가가요.',
    '배변 훈련이나 규칙을 한 번 배우면 잘 지켜요.',
    '책임감이 강하고 주인바라기 성향이 있어요.',
  ];

  const MBTIResultPage({
    super.key,
    required this.onRestartPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFED6D11);
    const Color backgroundColor = Color(0xFFF0E8DD);
    const Color textColor = Color(0xFF1C110C);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // 1. 상단 뒤로가기 버튼
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: textColor),
                  onPressed: onBackPressed,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),

              const Spacer(flex: 1),

              // 2. 결과 제목
              Text(
                resultTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16, // 🔥 14에서 16으로 변경
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),

              // 3. MBTI 유형
              Text(
                resultType,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: accentColor.withOpacity(0.6),
                  letterSpacing: 1.5,
                ),
              ),

              const Spacer(flex: 1),

              // 4. 결과 이미지 (비율 유지)
              Expanded(
                flex: 12,
                child: Image.asset(
                  'assets/start.jpg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),

              const Spacer(flex: 1),

              // 5. 결과 특징 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < features.length; i++) ...[
                      _buildFeatureItem(features[i], accentColor),
                      if (i < features.length - 1) const SizedBox(height: 6),
                    ],
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // 6. 다시하기 버튼
              ElevatedButton(
                onPressed: onRestartPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '다시하기',
                  style: TextStyle(
                    fontSize: 16, // 🔥 15에서 16으로 변경
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, Color dotColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A4A4A),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}