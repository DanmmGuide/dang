import 'package:flutter/material.dart';
import 'common_frame.dart';
import 'pages/home/home_page.dart';
import 'pages/board/board_page.dart';
import 'pages/guide/breed_select_page.dart';
import 'pages/content/mbti_page.dart';
import 'pages/my_page/my_page.dart';
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
        fontFamily: 'Epilogue',
      ),

      // 앱 처음 켰을 때는 StartPage부터
      home: const StartPage(),

      // (선택) /root 네임드 라우트로도 쓸 수 있게 해두기
      // 필요 없으면 그냥 안 써도 됨
    );
  }
}
class RootScreen extends StatefulWidget {
  /// 로그인한 유저 id (안 넣으면 1 사용)
  final int userId;

  /// 바텀 탭 처음 인덱스 (안 넣으면 0)
  final int initialIndex;

  const RootScreen({
    super.key,
    required this.userId,       // ✅ 기본값: 1
    this.initialIndex = 0, // ✅ 기본값: 0
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}


class _RootScreenState extends State<RootScreen> {
  late int _currentIndex;
  bool _isMyPageEditing = false;

  @override
  void initState() {
    super.initState();
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
      userId: widget.userId,
    );
  }

  Widget _buildBodyForIndex(int index) {
    switch (index) {
      case 0:
        return const HomePageClean();
      case 1:
        return BoardPage(
            userId: widget.userId
        );
      case 2:
        return const BreedSelectPage();
      case 3:
        return const MbtiPage();
      case 4:
        return MyPage(
          userId: widget.userId,   // ✅ 여기서 userId 전달
          onEditingChanged: (isEditing) {
            setState(() {
              _isMyPageEditing = isEditing;
            });
          },
        );
      default:
        return const HomePageClean();
    }
  }
}
