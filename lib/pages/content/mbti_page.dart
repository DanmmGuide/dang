// lib/pages/content/mbti_page.dart

import 'package:flutter/material.dart';
import 'mbti_start.dart';
import 'mbti_test.dart';
import 'mbti_result.dart';

class MbtiPage extends StatefulWidget {
  const MbtiPage({super.key});

  @override
  State<MbtiPage> createState() => _MbtiPageState();
}

class _MbtiPageState extends State<MbtiPage> {
  // start / test / result
  String _currentStep = 'start';
  List<String> _answers = [];

  void _goToStart() {
    setState(() {
      _currentStep = 'start';
      _answers = [];      // 다시 할 때는 답변도 리셋
    });
  }

  void _goToTest() {
    setState(() {
      _currentStep = 'test';
    });
  }

  void _goToResult() {
    setState(() {
      _currentStep = 'result';
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentStep) {
      case 'test':
      // mbti_test.dart 에서 생성자 이렇게 되어 있어야 함:
      // MBTITestPage({
      //   required this.onTestFinished,
      //   required this.onBackPressed,
      // });
        return MBTITestPage(
          onTestFinished: _goToResult, // 마지막 문제까지 풀면 결과 화면으로
          onBackPressed: _goToStart,   // 1번 문제에서 뒤로가기 → start 화면
        );

      case 'result':
      // mbti_result.dart 에서 생성자:
      // MBTIResultPage({
      //   required this.onRestartPressed,
      //   required this.onBackPressed,
      // });
        return MBTIResultPage(
          onRestartPressed: _goToStart, // "다시하기" → start 화면
          onBackPressed: _goToTest,     // 결과 화면에서 뒤로가기 → test 화면
        );

      case 'start':
      default:
        return MBTIStartPage(
          onStartPressed: _goToTest,    // START 버튼 → test 화면
        );
    }
  }
}
