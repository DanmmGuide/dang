import 'package:flutter/material.dart';

// 1. 질문 데이터 모델 (이미지 2개)
class QuizQuestion {
  final String question;
  final String imageLeft;
  final String imageRight;
  final String answer1Text;
  final String answer1Value;
  final String answer2Text;
  final String answer2Value;

  QuizQuestion({
    required this.question,
    required this.imageLeft,
    required this.imageRight,
    required this.answer1Text,
    required this.answer1Value,
    required this.answer2Text,
    required this.answer2Value,
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

  // 2. 질문 리스트
  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: '햇살이 비치는 아침!\n눈을 뜬 댕댕이는?',
      imageLeft: 'assets/mbti_test_1_left.jpg',
      imageRight: 'assets/mbti_test_1_right.jpg',
      answer1Text: '침대로 뛰어올라 주인을 핥으며 깨운다.',
      answer1Value: 'E',
      answer2Text: '주인이 일어날 때까지 조용히 기다린다.',
      answer2Value: 'I',
    ),
    QuizQuestion(
      question: '"산책 갈까?"\n목줄을 꺼내 들자...',
      imageLeft: 'assets/pomeranian.png',
      imageRight: 'assets/cat_image.png',
      answer1Text: '현관 앞에서 빙글빙글! 빨리 나가자고 난리다.',
      answer1Value: 'P',
      answer2Text: '익숙한 듯 얌전히 앉아서 채워주길 기다린다.',
      answer2Value: 'J',
    ),
    QuizQuestion(
      question: '산책 중 저기서\n다른 강아지 친구가 다가온다!',
      imageLeft: 'assets/cat_image.png',
      imageRight: 'assets/pomeranian.png',
      answer1Text: '"안녕! 놀자!" 꼬리 흔들며 먼저 다가간다.',
      answer1Value: 'E',
      answer2Text: '주인 뒤로 숨거나 못 본 척 지나간다.',
      answer2Value: 'I',
    ),
    QuizQuestion(
      question: '길가에 처음 보는\n낯선 물건이 떨어져 있다.',
      imageLeft: 'assets/pomeranian.png',
      imageRight: 'assets/cat_image.png',
      answer1Text: '일단 코부터 박고 냄새를 맡아본다.',
      answer1Value: 'S',
      answer2Text: '멀리서 "저게 뭐지?" 하며 눈으로 관찰한다.',
      answer2Value: 'N',
    ),
    QuizQuestion(
      question: '오늘은 매일 가던 길이 아니라\n다른 길로 가보자.',
      imageLeft: 'assets/cat_image.png',
      imageRight: 'assets/pomeranian.png',
      answer1Text: '"왜 이리로 가?" 버티며 원래 길로 가자고 한다.',
      answer1Value: 'J',
      answer2Text: '"오! 새로운 모험이다!" 신나서 앞장선다.',
      answer2Value: 'P',
    ),
    QuizQuestion(
      question: '집에 왔는데 주인이\n발을 닦아주려다 실수로 아프게 했다.',
      imageLeft: 'assets/pomeranian.png',
      imageRight: 'assets/cat_image.png',
      answer1Text: '"깨갱!" 하고 엄살 부리며 위로를 바란다.',
      answer1Value: 'F',
      answer2Text: '잠깐 놀랐지만 금방 털고 아무렇지 않게 행동한다.',
      answer2Value: 'T',
    ),
    QuizQuestion(
      question: '휴식 중 주인이\n간식을 몰래 숨기는 걸 목격했다!',
      imageLeft: 'assets/cat_image.png',
      imageRight: 'assets/pomeranian.png',
      answer1Text: '냄새를 따라 킁킁거리며 끝까지 찾아낸다.',
      answer1Value: 'S',
      answer2Text: '주인의 눈치를 살피며 "주면 안 돼?" 텔레파시를 보낸다.',
      answer2Value: 'N',
    ),
    QuizQuestion(
      question: '주인이 슬픈 영화를 보며 울고 있다.',
      imageLeft: 'assets/pomeranian.png',
      imageRight: 'assets/cat_image.png',
      answer1Text: '다가와서 눈물을 핥아주거나 품에 파고든다.',
      answer1Value: 'F',
      answer2Text: '멀뚱히 쳐다보다가 자기 장난감을 가지고 논다.',
      answer2Value: 'T',
    ),
    QuizQuestion(
      question: '밥 먹을 시간이 되었다.',
      imageLeft: 'assets/cat_image.png',
      imageRight: 'assets/pomeranian.png',
      answer1Text: '배꼽시계 정확하다. 밥그릇을 치며 재촉한다.',
      answer1Value: 'J',
      answer2Text: '주면 먹고 아니면 말고, 느긋하게 기다린다.',
      answer2Value: 'P',
    ),
    QuizQuestion(
      question: '모두가 잠든 밤, 댕댕이의 잠버릇은?',
      imageLeft: 'assets/pomeranian.png',
      imageRight: 'assets/cat_image.png',
      answer1Text: '배를 까뒤집고 대자로 뻗어서 잔다.',
      answer1Value: 'E',
      answer2Text: '몸을 동그랗게 말고 구석이나 자기 집에서 잔다.',
      answer2Value: 'I',
    ),
  ];

  void _handleAnswer(String selectedValue) {
    if (_currentQuestionIndex >= _questions.length) return;

    setState(() {
      _userAnswers.add(selectedValue);
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        widget.onTestFinished();
      }
    });
  }

  void _handleBack() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        if (_userAnswers.isNotEmpty) {
          _userAnswers.removeLast();
        }
      });
    } else {
      widget.onBackPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF0E8DD);
    const horizontalPadding = 24.0;

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: const Center(
          child: Text('질문 데이터가 없습니다.'),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. 상단 뒤로가기
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: _handleBack,
                  padding: const EdgeInsets.all(8.0),
                  constraints:
                  const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ),
              const SizedBox(height: 10),

              // 2. 진행 상황
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_currentQuestionIndex + 1} / ${_questions.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFED6D11),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 3. 진행바
              Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor:
                    (_currentQuestionIndex + 1) / _questions.length,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFED6D11),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 4. 질문 텍스트
              Align(
                alignment: Alignment.center,
                child: Text(
                  currentQuestion.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1C110C),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // 5. 상황 이미지
              Row(
                children: [
                  // 왼쪽 이미지
                  Expanded(
                    child: _buildSideImage(currentQuestion.imageLeft),
                  ),
                  const SizedBox(width: 15),
                  // 오른쪽 이미지
                  Expanded(
                    child: _buildSideImage(currentQuestion.imageRight),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 6. 답변 버튼 1
              _buildAnswerButton(
                text: currentQuestion.answer1Text,
                onTap: () => _handleAnswer(currentQuestion.answer1Value),
              ),
              const SizedBox(height: 20),

              // 7. 답변 버튼 2
              _buildAnswerButton(
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

  // 이미지 위젯 (공통)
  Widget _buildSideImage(String imagePath) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }

  // 답변 버튼 위젯
  Widget _buildAnswerButton({
    required String text,
    required VoidCallback onTap,
  }) {
    const Color buttonColor = Colors.white;
    const Color borderColor = Color(0xFFED6D11);

    return Material(
      color: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 2.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C110C),
              height: 1.2,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}