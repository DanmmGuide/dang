import 'package:flutter/material.dart';
import 'test1/home_page.dart';
import 'test1/board/board_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePageClean(),   // 홈
        '/board': (context) => const BoardPage(),  // 게시판
      },
      theme: ThemeData(
        useMaterial3: false,
      ),
    );
  }
}

