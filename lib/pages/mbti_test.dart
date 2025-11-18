// lib/pages/content/MBTI_test.dart

import 'package:flutter/material.dart';

// 1. 질문 데이터 모델 정의
class QuizQuestion {
  final String question;
  final String answer1Text;
  final String answer1Value;
  final String answer1Image;
  final String answer2Text;
  final String answer2Value;
  final String answer2Image;

  QuizQuestion({
    required this.question,
    required this.answer1Text,
    required this.answer1Value,
    required this.answer1Image,
    required this.answer2Text,
    required this.answer2Value,
    required this.answer2Image,
  });
}

class MBTITestPage extends StatefulWidget {
  final VoidCallback onTestFinished;
  final VoidCallback onBackPressed;

  const MBTITestPage({
    super.key,
    required this.onTestFinished,
    required this.onBackPressed,
  });

  @override
  State<MBTITestPage> createState() => _MBTITestPageState();
}

class _MBTITestPageState extends State<MBTITestPage> {
  int _currentQuestionIndex = 0;
  final List<String> _userAnswers = [];

  // 2. 스토리형 질문 10개 데이터 리스트
  final List<QuizQuestion> _questions = [
    // --- 아침 (E vs I) ---
    QuizQuestion(
      question: '햇살이 비치는 아침! 눈을 뜬 댕댕이는?',
      answer1Text: '침대로 뛰어올라 주인을 핥으며 깨운다.',
      answer1Value: 'E',
      answer1Image: 'assets/mbti_test_1.jpg',
      answer2Text: '주인이 일어날 때까지 조용히 기다린다.',
      answer2Value: 'I',
      answer2Image: 'assets/mbti_test_2.jpg',
    ),

    // --- 산책 준비 (J vs P) ---
    QuizQuestion(
      question: '"산책 갈까?" 목줄을 꺼내 들자...',
      answer1Text: '현관 앞에서 빙글빙글! 빨리 나가자고 난리다.',
      answer1Value: 'P',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '익숙한 듯 얌전히 앉아서 채워주길 기다린다.',
      answer2Value: 'J',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 산책 중 만남 (E vs I) ---
    QuizQuestion(
      question: '산책 중 저기서 다른 강아지 친구가 다가온다!',
      answer1Text: '"안녕! 놀자!" 꼬리 흔들며 먼저 다가간다.',
      answer1Value: 'E',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '주인 뒤로 숨거나 못 본 척 지나간다.',
      answer2Value: 'I',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 산책 탐색 (S vs N) ---
    QuizQuestion(
      question: '길가에 처음 보는 낯선 물건이 떨어져 있다.',
      answer1Text: '일단 코부터 박고 냄새를 맡아본다.',
      answer1Value: 'S',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '멀리서 "저게 뭐지?" 하며 눈으로 관찰한다.',
      answer2Value: 'N',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 돌발 상황 (J vs P) ---
    QuizQuestion(
      question: '오늘은 매일 가던 길이 아니라 다른 길로 가보자.',
      answer1Text: '"왜 이리로 가?" 버티며 원래 길로 가자고 한다.',
      answer1Value: 'J',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '"오! 새로운 모험이다!" 신나서 앞장선다.',
      answer2Value: 'P',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 집으로 복귀 (T vs F) ---
    QuizQuestion(
      question: '집에 왔는데 주인이 발을 닦아주려다 실수로 아프게 했다.',
      answer1Text: '"깨갱!" 하고 엄살 부리며 위로를 바란다.',
      answer1Value: 'F',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '잠깐 놀랐지만 금방 털고 아무렇지 않게 행동한다.',
      answer2Value: 'T',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 휴식 시간 (S vs N) ---
    QuizQuestion(
      question: '휴식 중 주인이 간식을 몰래 숨기는 걸 목격했다!',
      answer1Text: '냄새를 따라 킁킁거리며 끝까지 찾아낸다.',
      answer1Value: 'S',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '주인의 눈치를 살피며 "주면 안 돼?" 텔레파시를 보낸다.',
      answer2Value: 'N',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 감정 교류 (T vs F) ---
    QuizQuestion(
      question: '주인이 슬픈 영화를 보며 울고 있다.',
      answer1Text: '다가와서 눈물을 핥아주거나 품에 파고든다.',
      answer1Value: 'F',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '멀뚱히 쳐다보다가 자기 장난감을 가지고 논다.',
      answer2Value: 'T',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 저녁 식사 (J vs P) ---
    QuizQuestion(
      question: '밥 먹을 시간이 되었다.',
      answer1Text: '배꼽시계 정확하다. 밥그릇을 치며 재촉한다.',
      answer1Value: 'J',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '주면 먹고 아니면 말고, 느긋하게 기다린다.',
      answer2Value: 'P',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 취침 (E vs I) ---
    QuizQuestion(
      question: '모두가 잠든 밤, 댕댕이의 잠버릇은?',
      answer1Text: '배를 까뒤집고 대자로 뻗어서 잔다.',
      answer1Value: 'E',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '몸을 동그랗게 말고 구석이나 자기 집에서 잔다.',
      answer2Value: 'I',
      answer2Image: 'assets/cat_image.png',
    ),
  ];

  // 3. 답변 선택 시 로직 (다음 질문으로)
  void _handleAnswer(String selectedValue) {
    setState(() {
      _userAnswers.add(selectedValue);
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        widget.onTestFinished();
      }
    });
  }

  // 4. 뒤로 가기 로직 (이전 질문으로)
  void _handleBack() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _userAnswers.removeLast();
      });
    } else {
      widget.onBackPressed();
    }
  }

  // 5. 화면 빌드 (build 메소드)
  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    const Color buttonColor = Colors.white;
    const Color borderColor = Color(0xFFE0E0E0);
    const Color backgroundColor = Color(0xFFF0E8DD);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          'MBTI 검사',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),
      ),
      body: Container(
        color: backgroundColor,
        width: double.infinity,
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상단 라벨
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: const Text('강아지 MBTI 검사'),
              ),
              const SizedBox(height: 20),

              // 진행 상황
              Text(
                '${_currentQuestionIndex + 1} / ${_questions.length}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 15),

              // 질문 텍스트
              Text(
                currentQuestion.question,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // 답변 1
              _buildAnswerOption(
                context: context,
                imagePath: currentQuestion.answer1Image,
                text: currentQuestion.answer1Text,
                onTap: () => _handleAnswer(currentQuestion.answer1Value),
              ),
              const SizedBox(height: 20),

              const Text('VS',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // 답변 2
              _buildAnswerOption(
                context: context,
                imagePath: currentQuestion.answer2Image,
                text: currentQuestion.answer2Text,
                onTap: () => _handleAnswer(currentQuestion.answer2Value),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 버튼 디자인 위젯 (수정됨: BoxFit.contain)
  Widget _buildAnswerOption({
    required BuildContext context,
    required String imagePath,
    required String text,
    required VoidCallback onTap,
  }) {
    const Color buttonColor = Colors.white;
    const Color borderColor = Color(0xFFE0E0E0);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain, // 👈 cover -> contain으로 변경
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child:
                const Icon(Icons.image_not_supported, color: Colors.grey),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Material(
          color: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: borderColor),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onTap,
            child: Container(
              height: 55,
              alignment: Alignment.center,
              child: Text(
                text,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }
}