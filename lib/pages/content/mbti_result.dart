import 'package:flutter/material.dart';

class MBTIResultPage extends StatelessWidget {
  final VoidCallback onRestartPressed;
  final VoidCallback onBackPressed;
  final String finalResult;

  const MBTIResultPage({
    super.key,
    required this.onRestartPressed,
    required this.onBackPressed,
    required this.finalResult,
  });

  // 16가지 MBTI 데이터 저장소
  static const Map<String, Map<String, dynamic>> mbtiInfo = {
    'ISTJ': {
      'title': '빈틈없는 원칙주의자\n모범생 강아지',
      'features': [
        '산책할 때 늘 가던 길로 가는 것을 편안해해요.',
        '낯선 사람이나 친구에게는 신중하게 다가가요.',
        '배변 훈련이나 규칙을 한 번 배우면 잘 지켜요.',
        '책임감이 강하고 주인바라기 성향이 있어요.',
      ],
    },
    'ISFJ': {
      'title': '다정한 수호자\n천사표 강아지',
      'features': [
        '주인의 감정을 잘 읽고 위로해줘요.',
        '가족에게 헌신적이고 애교가 많아요.',
        '낯선 환경에서는 겁을 먹을 수 있어요.',
        '싸움을 싫어하고 평화를 사랑해요.',
      ],
    },
    'INFJ': {
      'title': '통찰력 있는 선지자\n영혼 있는 강아지',
      'features': [
        '조용하지만 주인을 깊이 신뢰해요.',
        '눈치가 빠르고 분위기를 잘 파악해요.',
        '혼자만의 시간을 즐기기도 해요.',
        '훈련 습득력이 빠르고 똑똑해요.',
      ],
    },
    'INTJ': {
      'title': '용의주도한 전략가\n독립적인 강아지',
      'features': [
        '자립심이 강하고 혼자서도 잘 놀아요.',
        '새로운 장난감이나 놀이에 호기심이 많아요.',
        '주인에게 의존하기보다 동등한 관계를 원해요.',
        '똑똑해서 가끔 주인을 속이기도 해요.',
      ],
    },
    'ISTP': {
      'title': '만능 재주꾼\n쿨한 강아지',
      'features': [
        '호기심이 많고 이것저것 탐색하는 걸 좋아해요.',
        '과한 스킨십보다는 적당한 거리를 좋아해요.',
        '상황 적응력이 뛰어나고 침착해요.',
        '자유로운 영혼이라 구속받는 걸 싫어해요.',
      ],
    },
    'ISFP': {
      'title': '호기심 많은 예술가\n순둥이 강아지',
      'features': [
        '온화하고 다정하며 싸움을 피해요.',
        '소리나 냄새 등 감각적인 것에 예민해요.',
        '주인 껌딱지라 늘 옆에 있고 싶어해요.',
        '낯선 사람에게도 금방 마음을 열어요.',
      ],
    },
    'INFP': {
      'title': '열정적인 중재자\n감성 강아지',
      'features': [
        '겁이 많고 소심하지만 주인에게는 다정해요.',
        '주인의 기분에 따라 같이 슬퍼하거나 기뻐해요.',
        '상상력이 풍부해서 혼자서도 잘 놀아요.',
        '칭찬을 받으면 세상에서 제일 행복해해요.',
      ],
    },
    'INTP': {
      'title': '논리적인 사색가\n멍 때리는 강아지',
      'features': [
        '가끔 멍하니 생각에 잠겨 있을 때가 많아요.',
        '독립적이라 혼자 두어도 스트레스를 덜 받아요.',
        '새로운 문제 해결 놀이를 좋아해요.',
        '애교가 많지는 않지만 은근히 챙겨줘요.',
      ],
    },
    'ESTP': {
      'title': '모험을 즐기는 사업가\n에너지 뿜뿜 강아지',
      'features': [
        '활동량이 엄청나고 지치지 않아요.',
        '새로운 친구나 환경에 거침없이 다가가요.',
        '장난치는 것을 좋아하고 사고뭉치일 수 있어요.',
        '간식이나 보상을 주면 훈련 효과가 좋아요.',
      ],
    },
    'ESFP': {
      'title': '자유로운 영혼의 연예인\n핵인싸 강아지',
      'features': [
        '어딜 가나 주목받는 것을 좋아해요.',
        '사람이나 다른 강아지 친구들을 너무 좋아해요.',
        '지루한 것을 못 참고 항상 놀고 싶어해요.',
        '애교가 철철 넘치는 사랑둥이예요.',
      ],
    },
    'ENFP': {
      'title': '재기발랄한 활동가\n해피바이러스 강아지',
      'features': [
        '항상 꼬리를 흔들며 기분이 좋아 보여요.',
        '호기심 대장이라 산책할 때 이곳저곳 참견해요.',
        '감정 표현이 확실하고 솔직해요.',
        '친구를 너무 좋아해서 금방 친해져요.',
      ],
    },
    'ENTP': {
      'title': '뜨거운 논쟁을 즐기는 변론가\n장난꾸러기 강아지',
      'features': [
        '머리가 비상하게 좋아서 잔머리를 잘 굴려요.',
        '주인과 장난치고 겨루는 놀이를 좋아해요.',
        '새로운 것에 대한 두려움이 없어요.',
        '가끔 고집을 피우지만 미워할 수 없어요.',
      ],
    },
    'ESTJ': {
      'title': '엄격한 관리자\n보스 기질 강아지',
      'features': [
        '자기 영역에 대한 욕심과 보호 본능이 강해요.',
        '규칙적인 생활 패턴을 좋아해요.',
        '주인을 지키려는 충성심이 대단해요.',
        '다른 강아지들 사이에서 리더 역할을 해요.',
      ],
    },
    'ESFJ': {
      'title': '사교적인 외교관\n친절한 강아지',
      'features': [
        '분위기 메이커라 모두에게 사랑받아요.',
        '주인의 칭찬과 관심을 먹고 살아요.',
        '눈치가 빨라서 주인이 뭘 원하는지 알아요.',
        '가족 간의 화목함을 중요하게 생각해요.',
      ],
    },
    'ENFJ': {
      'title': '정의로운 사회운동가\n리더쉽 강아지',
      'features': [
        '카리스마가 있고 무리를 이끄는 걸 좋아해요.',
        '공감 능력이 뛰어나서 위로를 잘 해줘요.',
        '책임감이 강하고 훈련을 잘 따라와요.',
        '사람을 너무 좋아해서 분리불안이 올 수 있어요.',
      ],
    },
    'ENTJ': {
      'title': '대담한 통솔자\n대장님 강아지',
      'features': [
        '자기 주장이 확실하고 고집이 있어요.',
        '똑똑해서 어려운 훈련도 척척 해내요.',
        '활동적이고 에너지 넘치는 놀이를 원해요.',
        '주인과 함께 무언가를 성취하는 걸 좋아해요.',
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFED6D11);
    const Color backgroundColor = Color(0xFFF0E8DD);
    const Color textColor = Color(0xFF1C110C);

    // 1. 전달받은 MBTI로 데이터 찾기 (없으면 ISTJ 기본값)
    final String mbtiKey = finalResult.toUpperCase();
    final Map<String, dynamic> data = mbtiInfo[mbtiKey] ?? mbtiInfo['ISTJ']!;

    final String resultTitle = data['title'];
    final List<String> features = data['features'];
    // 이미지 파일명은 MBTI 결과와 같다고 가정 (예: ISTJ.JPG)
    final String imagePath = 'assets/$mbtiKey.JPG';

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

              // 2. 결과 제목 (데이터 연동)
              Text(
                resultTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),

              // 3. MBTI 유형 (데이터 연동)
              Text(
                mbtiKey,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: accentColor.withOpacity(0.6),
                  letterSpacing: 1.5,
                ),
              ),

              const Spacer(flex: 1),

              // 4. 결과 이미지 (파일명 연동)
              Expanded(
                flex: 12,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          const SizedBox(height: 10),
                          Text('$mbtiKey.JPG 없음', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const Spacer(flex: 1),

              // 5. 결과 특징 박스 (데이터 연동)
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
                    fontSize: 16,
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