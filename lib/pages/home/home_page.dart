// lib/pages/home/home_page.dart

import 'dart:math';
import 'package:flutter/material.dart';

class HomePageClean extends StatefulWidget {
  const HomePageClean({super.key});

  @override
  State<HomePageClean> createState() => _HomePageCleanState();
}

class _HomePageCleanState extends State<HomePageClean> {
  // 🔹 홈 화면에 쓸 데이터 세트
  final List<_HomeContent> _items = [
    _HomeContent(
      imagePath: 'assets/chocolate.jpg',
      mainTitle: '포메라니안',
      mainDescription:
      '사실 강아지에게 초콜릿은 위험해요.\n대신 강아지 전용 간식을 준비해 주세요.',
      tipTitle: '운동 체크',
      tipDescription:
      '매일 30분 이상 산책을 시켜주면\n반려견의 스트레스 해소와 건강에 좋아요.',
    ),
    // ✅ 여기부터 네가 추가한 사진/문구로 2~11까지 채우면 됨
    _HomeContent(
      imagePath: 'assets/choco1.jpg',
      mainTitle: '피부 관리',
      mainDescription: '잦은 빗질은 피부 건강에 좋아요.\n엉키기 전에 풀어주는 게 중요해요.',
      tipTitle: '피부 관리',
      tipDescription: '주 1~2회 빗질과 귀 청소를 해주면\n피부 질환을 예방하는 데 도움이 돼요.',
    ),
    _HomeContent(
      imagePath: 'assets/choco2.jpg',
      mainTitle: '물 많이 마시기',
      mainDescription: '강아지도 수분 섭취가 부족하면 피곤함을 느껴요.',
      tipTitle: '수분관리',
      tipDescription: '물을 여러 군데 두면 자연스럽게 물을 더 많이 마셔요..',
    ),
    _HomeContent(
      imagePath: 'assets/choco3.jpg',
      mainTitle: '산책 전 체크',
      mainDescription: '리드줄, 배변봉투, 충분한 간식 챙겼나요?',
      tipTitle: '산책 준비',
      tipDescription: '산책 전 짧게 몸풀기 스트레칭을 해주면 관절 부상을 줄여줘요.',
    ),
    _HomeContent(
      imagePath: 'assets/choco4.jpg',
      mainTitle: '간식은 적당히',
      mainDescription: '간식의 칼로리는 의외로 높아요!',
      tipTitle: '간식 관리',
      tipDescription: '하루 식사량의 10% 이내로 조절하는 것이 좋아요.',
    ),
    _HomeContent(
      imagePath: 'assets/choco5.jpg',
      mainTitle: '귀 관리하기',
      mainDescription: '귀 안이 붉거나 냄새가 나면 관리가 필요해요.',
      tipTitle: '귀 청소',
      tipDescription: '주 1회 전용 이어클리너로 부드럽게 닦아주세요.',
    ),
    _HomeContent(
      imagePath: 'assets/choco6.jpg',
      mainTitle: '발톱 깎기',
      mainDescription: '발톱이 너무 길면 관절에 무리가 가요.',
      tipTitle: '발톱 관리',
      tipDescription: '걷는 소리가 ‘딱딱’ 나면 발톱 손질이 필요한 신호예요.',
    ),
    _HomeContent(
      imagePath: 'assets/choco7.jpg',
      mainTitle: '칫솔질 연습',
      mainDescription: '치석은 생각보다 빨리 쌓여요.',
      tipTitle: '치아 건강',
      tipDescription: '하루 1번, 최소 주 3회 칫솔질을 하면 구취가 크게 줄어요.',
    ),
    _HomeContent(
      imagePath: 'assets/choco8.jpg',
      mainTitle: '실내 놀이',
      mainDescription: '비 오는 날에도 충분한 활동은 필요해요.',
      tipTitle: '두뇌 자극',
      tipDescription: '터그놀이나 간식 숨기기 놀이는 스트레스 해소에 좋아요.',
    ),
    _HomeContent(
      imagePath: 'assets/choco9.jpg',
      mainTitle: '사회성 키우기',
      mainDescription: '강아지에게 다양한 경험은 중요해요.',
      tipTitle: '사회화',
      tipDescription: '엘리베이터, 버스정류장 등 낯선 환경을 천천히 경험시켜주세요.',
    ),
    _HomeContent(
      imagePath: 'assets/choco10.jpg',
      mainTitle: '체온 관리',
      mainDescription: '겨울엔 산책 시간이 조금 짧아도 괜찮아요.',
      tipTitle: '보온',
      tipDescription: '추위에 약한 소형견은 가벼운 옷이나 방석이 필수예요.',
    ),
    _HomeContent(
      imagePath: 'assets/choco11.jpg',
      mainTitle: '더위 조심',
      mainDescription: '여름 낮 산책은 화상 위험이 있어요.',
      tipTitle: '온도 관리',
      tipDescription: '아스팔트 온도는 손등으로 5초 만져보고 판단해요.',
    ),



  ];

  late _HomeContent _selected;

  @override
  void initState() {
    super.initState();

    // 🔹 화면 들어올 때마다 랜덤 선택
    final random = Random();
    _selected = _items[random.nextInt(_items.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0E8DD), // 공통 배경색
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ⭐ 상단 이미지 + 텍스트
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        _selected.imagePath,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selected.mainTitle,
                      style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF161411),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selected.mainDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4C3F35),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 150),

              /// ⭐ 오늘의 반려동물 팁
              const Text(
                '오늘의 반려동물 팁',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF161411),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                height: 200,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EE),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selected.tipTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF161411),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _selected.tipDescription,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF4C3F35),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        _selected.imagePath,
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 🔹 홈 화면용 데이터 모델 (화면 밖에서만 쓰는 private 클래스)
class _HomeContent {
  final String imagePath;
  final String mainTitle;
  final String mainDescription;
  final String tipTitle;
  final String tipDescription;

  const _HomeContent({
    required this.imagePath,
    required this.mainTitle,
    required this.mainDescription,
    required this.tipTitle,
    required this.tipDescription,
  });
}

