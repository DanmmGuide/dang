// lib/pages/mbti_page.dart

import 'package:flutter/material.dart';
import 'MBTI_start.dart';   // 1. 시작 화면
import 'MBTI_test.dart';    // 2. 테스트 화면
import 'MBTI_result.dart'; // 3. 결과 화면

// 1️⃣ '콘텐츠' 탭의 본체 (CommonFrame 안에 들어감)
//    - 평소엔 '시작 화면'만 보여줌
//    - 'START' 버튼을 누르면 Navigator.push로 2️⃣번을 띄움
class MbtiPage extends StatelessWidget {
  const MbtiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 'START' 버튼을 눌렀을 때 실행될 함수
    void _startTest() {
      // Navigator.push로 새 화면(MBTITestFlow)을 띄움
      // 이 화면은 CommonFrame을 벗어난 '상세 페이지'임
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MBTITestFlow(),
        ),
      );
    }

    // ⚠️ 중요: 여기서는 Scaffold/AppBar 없음 (CommonFrame 사용)
    // '시작' 페이지만 보여줌
    return MBTIStartPage(
      onStartPressed: _startTest, // 👈 'START' 누르면 _startTest 함수 실행
    );
  }
}


// 2️⃣ MBTI 테스트 흐름(Test <-> Result)을 관리하는
//    별도의 '풀스크린 상세 페이지' (CommonFrame 밖에 있음)
//    (board_detail_page.dart와 같은 원리)
class MBTITestFlow extends StatefulWidget {
  const MBTITestFlow({super.key});

  @override
  State<MBTITestFlow> createState() => _MBTITestFlowState();
}

class _MBTITestFlowState extends State<MBTITestFlow> {
  // 현재 상태가 'test'인지 'result'인지 기억
  String _currentStep = 'test';

  // 테스트 화면 -> '결과' 화면으로
  void _finishTest() {
    setState(() {
      _currentStep = 'result';
    });
  }

  // 결과 화면 -> '테스트' 화면으로 (뒤로가기)
  void _backToTest() {
    setState(() {
      _currentStep = 'test';
    });
  }

  // 결과 화면 -> '시작' 화면으로 (다시하기)
  void _restart() {
    // 'MBTITestFlow' 페이지 자체를 닫고
    // 뒤에 있던 1️⃣번(MbtiPage)으로 돌아감
    Navigator.of(context).pop();
  }

  // 테스트 화면 -> '시작' 화면으로 (뒤로가기)
  void _backToStart() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStep == 'result') {
      // 3. '결과' 상태면, 결과 페이지 빌드
      return MBTIResultPage(
        onRestartPressed: _restart,    // '다시하기' 누르면 1️⃣번(MbtiPage)으로
        onBackPressed: _backToTest,   // '뒤로가기' 누르면 2️⃣번(Test)으로
      );
    } else {
      // 2. '테스트' 상태면, 테스트 페이지 빌드
      return MBTITestPage(
        onTestFinished: _finishTest,  // '답변' 누르면 3️⃣번(Result)으로
        onBackPressed: _backToStart, // '뒤로가기' 누르면 1️⃣번(MbtiPage)으로
      );
    }
  }
}