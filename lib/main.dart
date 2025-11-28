import 'package:flutter/material.dart';
import 'common_frame.dart';
import 'pages/home/home_page.dart';
import 'pages/board/board_page.dart';
import 'pages/guide/breed_select_page.dart';
import 'pages/content/mbti_page.dart';
import 'pages/mypage/my_page.dart';
import 'pages/auth/start_page.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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

class RootScreen extends StatefulWidget {
  final int initialIndex; // 1. 변수 추가

  const RootScreen({
    super.key,
    this.initialIndex = 0, // 2. 생성자에서 받기 (기본값 0)
  });

  @override
  State<RootScreen> createState() {
    return _RootScreenState();
  }
}

class _RootScreenState extends State<RootScreen> {
  late int _currentIndex; // 3. late 키워드 (initState에서 초기화)
  bool _isMyPageEditing = false;

  @override
  void initState() {
    super.initState();
    // 4. 전달받은 initialIndex로 시작 탭 설정
    // (설정 페이지에서 마이페이지(4)로 보내면 4번 탭이 열림)
    _currentIndex = widget.initialIndex;
  }

  void _onTapNav(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = _buildBodyForIndex(_currentIndex);

    return CommonFrame(
      currentIndex: _currentIndex,
      onTapNav: _onTapNav,
      body: body,
      hideBottomNav: _currentIndex == 4 && _isMyPageEditing,
      showBackButton: _currentIndex == 4 && _isMyPageEditing,
    );
  }

  Widget _buildBodyForIndex(int index) {
    switch (index) {
      case 0:
        return const HomePageClean();
      case 1:
        return const BoardPage();
      case 2:
        return const BreedSelectPage();
      case 3:
        return const MbtiPage();
      case 4:
        return MyPage(
          onEditingChanged: (isEditing) {
            setState(() {
              _isMyPageEditing = isEditing; // 수정 모드 반영
            });
          },
        );
      default:
        return const HomePageClean();
    }
  }
}