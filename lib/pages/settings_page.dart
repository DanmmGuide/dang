import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'inquiry_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF0E8DD);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      // (Center 위젯은 삭제된 상태 유지)
      body: SingleChildScrollView(
        child: SizedBox(
          width: 402,
          height: 874,
          child: _SettingsContent(),
        ),
      ),
    );
  }
}

class _SettingsContent extends StatefulWidget {
  @override
  State<_SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<_SettingsContent> {
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 897,
      child: Stack(
        children: [
          Positioned(
            // ... (배경 부분, 원본과 동일) ...
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
                          Container(
                            width: double.infinity,
                            height: 728 + 53, // (공간 채우기)
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
              // 👇 1. [수정] vertical: 89 -> 30 으로 상단 여백을 대폭 줄임
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
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
                          color: Colors.black.withOpacity(0.20),
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Transform.scale(
                              scale: 0.9,
                              child: CupertinoSwitch(
                                value: _notificationsEnabled,
                                onChanged: (bool value) {
                                  setState(() {
                                    _notificationsEnabled = value;
                                  });
                                },
                                activeColor: Colors.amber, // (노란색)
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 33),

                  // 서비스 문의 버튼
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const InquiryPage(),
                        ),
                      );
                    },
                    child: const _SettingsButton(label: '서비스 문의'),
                  ),
                  const SizedBox(height: 33),

                  // 로그아웃 버튼
                  const _SettingsButton(label: '로그아웃'),
                  const SizedBox(height: 33),

                  // 회원 탈퇴 버튼
                  const _SettingsButton(label: '회원 탈퇴'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String label;

  const _SettingsButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 84, maxWidth: 480),
      child: Container(
        width: 175,
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 12), // (글자 잘림 수정됨)
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFF2EDE8),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.20),
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