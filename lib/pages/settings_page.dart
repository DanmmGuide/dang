import 'package:flutter/material.dart';



class SettingsPage extends StatelessWidget
{
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    // 여기서는 CommonFrame을 안 쓰고, 독립 화면으로 구성
    // (이미 AppBar에 설정 버튼으로 들어왔고, AppBar는 CommonFrame 쪽에서 있음)
    // 만약 완전 별도의 화면(AppBar 포함)으로 만들고 싶으면 Scaffold+AppBar 써도 됨.

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 402,
            height: 874,
            child: _SettingsContent(),
          ),
        ),
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return Container(
      height: 897,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 402,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 844),
                    child: Container(
                      width: 402,
                      height: 874,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(color: Color(0xFFF0E8DD)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 상단 설정 텍스트 영역 (피그마 상단바 일부)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              top: 16,
                              left: 16,
                              right: 16,
                              bottom: 8,
                            ),
                            child: const Text(
                              '설정',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // 나머지 공간
                          Container(
                            width: double.infinity,
                            height: 728,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 가운데 실제 설정 카드들
          Positioned.fill(
            child: Container(
              width: 402,
              height: 874,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 89),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 알림 받기
                  Container(
                    width: 346,
                    height: 50,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF2EDE8),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: Colors.black.withValues(alpha: 0.20),
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Positioned(
                          left: 21,
                          top: 13,
                          child: Text(
                            '알림 받기',
                            style: TextStyle(
                              color: Color(0xFF1C110C),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 16,
                          top: 9,
                          child: Container(
                            width: 56,
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0x7FD0D0D0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x38000000),
                                        blurRadius: 1,
                                        offset: Offset(0, 1),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 33),

                  // 서비스 문의 버튼
                  _SettingsButton(label: '서비스 문의'),
                  const SizedBox(height: 33),

                  // 로그아웃 버튼
                  _SettingsButton(label: '로그아웃'),
                  const SizedBox(height: 33),

                  // 회원 탈퇴 버튼
                  _SettingsButton(label: '회원 탈퇴'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget
{
  final String label;

  const _SettingsButton({super.key, required this.label});

  @override
  Widget build(BuildContext context)
  {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 84, maxWidth: 480),
      child: Container(
        width: 175,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFF2EDE8),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black.withValues(alpha: 0.20),
            ),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1C120D),
              fontSize: 16,
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}