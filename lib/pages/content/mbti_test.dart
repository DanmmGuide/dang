// lib/pages/content/MBTI_test.dart

import 'package:flutter/material.dart';

// 1. 질문 데이터 모델 정의
class QuizQuestion {
  final String question;
  final String answer1Text;
  final String answer1Value;  // MBTI 축(E/I/S/N/T/F/J/P)
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

  // 2. 질문 20개 리스트 (E/I, S/N, T/F, J/P 각각 5문항)
  final List<QuizQuestion> _questions = [
    // --- 1. E vs I ---
    QuizQuestion(
      question: '산책 중 낯선 친구를 만났을 때?',
      answer1Text: '먼저 다가가서 냄새를 맡고 인사한다.',
      answer1Value: 'E',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '주인 뒤로 숨거나 무시하고 지나간다.',
      answer2Value: 'I',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '애견 카페나 운동장에 갔을 때?',
      answer1Text: '친구들과 뛰어노느라 정신없다.',
      answer1Value: 'E',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '내 옆에만 붙어 있거나 구석에 있다.',
      answer2Value: 'I',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '집에 손님이 찾아왔을 때?',
      answer1Text: '격하게 반기며 꼬리가 떨어져라 흔든다.',
      answer1Value: 'E',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '방으로 들어가서 나오지 않거나 짖는다.',
      answer2Value: 'I',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '평소 집에서의 모습은?',
      answer1Text: '계속 놀아달라고 장난감을 물고 온다.',
      answer1Value: 'E',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '대부분의 시간을 자기 자리에서 조용히 잔다.',
      answer2Value: 'I',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '산책 갈까? 라는 말에 반응은?',
      answer1Text: '현관으로 달려나가며 빙글빙글 돈다.',
      answer1Value: 'E',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '귀만 쫑긋하거나 천천히 일어난다.',
      answer2Value: 'I',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 2. S vs N ---
    QuizQuestion(
      question: '새로운 장난감을 주었을 때?',
      answer1Text: '일단 물고 뜯고 맛보며 탐색한다.',
      answer1Value: 'S',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '이게 뭐지? 하며 조심스럽게 관찰한다.',
      answer2Value: 'N',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '산책할 때 주로 하는 행동은?',
      answer1Text: '땅바닥 냄새를 맡느라 앞으로 못 간다.',
      answer1Value: 'S',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '주변 풍경을 두리번거리며 걷는다.',
      answer2Value: 'N',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '간식을 숨겨두는 노즈워크를 할 때?',
      answer1Text: '코를 박고 끝까지 찾아내서 먹는다.',
      answer1Value: 'S',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '몇 번 찾다가 못 찾으면 포기하거나 쳐다본다.',
      answer2Value: 'N',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '거울을 봤을 때 반응은?',
      answer1Text: '별 관심 없이 그냥 지나친다.',
      answer1Value: 'S',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '다른 강아지인 줄 알고 짖거나 갸우뚱한다.',
      answer2Value: 'N',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '훈련을 배울 때 습득 속도는?',
      answer1Text: '간식만 있으면 "앉아, 엎드려" 바로 마스터!',
      answer1Value: 'S',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '눈치가 빨라 주인의 의도를 금방 파악한다.',
      answer2Value: 'N',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 3. T vs F ---
    QuizQuestion(
      question: '혼내거나 꾸중을 들었을 때?',
      answer1Text: '억울하다는 듯이 짖거나 하품하며 딴청 피운다.',
      answer1Value: 'T',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '세상 잃은 표정으로 풀이 죽어 눈치를 본다.',
      answer2Value: 'F',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '내가 슬퍼서 울고 있을 때?',
      answer1Text: '멀뚱히 쳐다보거나 자기 할 일을 한다.',
      answer1Value: 'T',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '다가와서 눈물을 핥거나 옆에 가만히 있는다.',
      answer2Value: 'F',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '스킨십(뽀뽀, 포옹)을 할 때?',
      answer1Text: '귀찮아하며 피하거나 으르렁댄다.',
      answer1Value: 'T',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '가만히 즐기거나 더 해달라고 파고든다.',
      answer2Value: 'F',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '다른 강아지를 예뻐할 때 반응은?',
      answer1Text: '별 관심 없다. "나랑 무슨 상관?"',
      answer1Value: 'T',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '질투 폭발! 사이를 비집고 들어온다.',
      answer2Value: 'F',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '원하는 것이 있을 때?',
      answer1Text: '짖거나 앞발로 툭툭 치며 명확히 요구한다.',
      answer1Value: 'T',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '그윽한 눈빛으로 텔레파시를 보낸다.',
      answer2Value: 'F',
      answer2Image: 'assets/cat_image.png',
    ),

    // --- 4. J vs P ---
    QuizQuestion(
      question: '밥 먹는 시간 배꼽시계는?',
      answer1Text: '칼같다. 1분만 늦어도 밥달라고 난리난다.',
      answer1Value: 'J',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '주면 먹고 안 주면 말고, 크게 신경 안 쓴다.',
      answer2Value: 'P',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '잠자는 장소는?',
      answer1Text: '항상 자기 방석이나 지정된 위치에서 잔다.',
      answer1Value: 'J',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '현관, 소파, 침대 밑 등 매번 바뀐다.',
      answer2Value: 'P',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '산책 경로를 바꿨을 때?',
      answer1Text: '가던 길로 가자고 고집을 부린다.',
      answer1Value: 'J',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '새로운 길도 신나게 잘 따라온다.',
      answer2Value: 'P',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '배변 습관은?',
      answer1Text: '패드 정중앙이나 항상 싸는 곳에만 싼다.',
      answer1Value: 'J',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '가끔 조준 실패하거나 기분 따라 실수를 한다.',
      answer2Value: 'P',
      answer2Image: 'assets/cat_image.png',
    ),
    QuizQuestion(
      question: '평소 깔끔함의 정도는?',
      answer1Text: '물 웅덩이나 진흙은 피해서 걷는다.',
      answer1Value: 'J',
      answer1Image: 'assets/pomeranian.png',
      answer2Text: '비 오는 날 뒹구는 게 최고다.',
      answer2Value: 'P',
      answer2Image: 'assets/cat_image.png',
    ),
  ];

  // 3. 답변 선택 시 로직 (다음 질문으로 이동)
  void _handleAnswer(String selectedValue) {
    setState(() {
      _userAnswers.add(selectedValue);

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // TODO: 나중에 여기서 _userAnswers로 MBTI 계산 가능
        widget.onTestFinished(); // MBTITestFlow에서 Result 화면으로 전환
      }
    });
  }

  // 4. 뒤로 가기 로직 (이전 질문 or 시작 화면)
  void _handleBack() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        if (_userAnswers.isNotEmpty) {
          _userAnswers.removeLast();
        }
      });
    } else {
      // 첫 번째 문제에서 뒤로 가면 시작 화면으로
      widget.onBackPressed();
    }
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상단 라벨
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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

              const Text(
                'VS',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

  // 5. 답변 카드 + 버튼 UI
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
        // 이미지
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: 200,
            fit: BoxFit.contain, // 이미지 깨짐 방지
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),

        // 텍스트 버튼
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
