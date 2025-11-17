import 'package:flutter/material.dart';
import 'package:example0527/common_frame.dart';

class ContentPage extends StatelessWidget
{
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const Center(
      child: Text(
        '콘텐츠 화면',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}