import 'package:flutter/material.dart';
import 'MBTI_start.dart';
import 'MBTI_test.dart';

class MbtiPage extends StatelessWidget {
  const MbtiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MBTIStartPage(
      onStartPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MBTITestPage(
              onTestFinished: () {},

              onBackPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }
}