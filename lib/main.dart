// lib/main.dart
import 'package:flutter/material.dart';
import 'common_frame.dart';
import 'test1/home_page.dart';
import 'test1/board/board_page.dart';
import 'pages/guide_page.dart';
import 'pages/content_page.dart';
import 'pages/my_page.dart';
import 'start_page.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: '댕가이드',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      // 앱 처음 켰을 때는 StartPage부터
      home: const StartPage(),

      // RootScreen을 라우트로 등록해둔다.
      routes: {
        '/root': (context) => const RootScreen(),
      },
    );
  }
}

class RootScreen extends StatefulWidget
{
  const RootScreen({super.key});

  @override
  State<RootScreen> createState()
  {
    return _RootScreenState();
  }
}

class _RootScreenState extends State<RootScreen>
{
  int _currentIndex = 0;

  void _onTapNav(int index)
  {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    final Widget body = _buildBodyForIndex(_currentIndex);

    return CommonFrame(
      currentIndex: _currentIndex,
      onTapNav: _onTapNav,
      body: body,
    );
  }

  Widget _buildBodyForIndex(int index)
  {
    switch (index)
    {
      case 0:
        return const HomePageClean();
      case 1:
        return const BoardPage();
      case 2:
        return const GuidePage();
      case 3:
        return const ContentPage();
      case 4:
        return const MyPage();
      default:
        return const HomePageClean();
    }
  }
}


