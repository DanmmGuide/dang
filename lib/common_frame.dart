import 'package:flutter/material.dart';
import 'pages/settings/settings_page.dart';

class CommonFrame extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTapNav;
  final bool showBackButton;
  final bool hideBottomNav;

  final String? title;
  final bool showSettingsIcon;

  const CommonFrame({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTapNav,
    this.showBackButton = false,
    this.hideBottomNav = false,
    this.title,
    this.showSettingsIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final String displayTitle = title ?? _titleForIndex(currentIndex);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,

        leading: showBackButton
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.maybePop(context),
        )
            : null,

        title: Text(
          displayTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          if (showSettingsIcon)
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsPage(),
                  ),
                );
              },
            ),
        ],
      ),

      body: body,

      bottomNavigationBar: hideBottomNav ? null : _buildBottomNav(),
    );
  }

  // 🔻 BottomNav 분리
  Widget _buildBottomNav() {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        // color: Colors.white, // ❌ 제거됨 (아래 Material로 이동)
        border: Border(
          top: BorderSide(color: Color(0xFFF4F2EF), width: 1),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 16,
            right: 16,
            bottom: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(index: 0, label: '홈', icon: Icons.home),
              _buildNavItem(index: 1, label: '게시판', icon: Icons.list),
              _buildNavItem(index: 2, label: '가이드', icon: Icons.book_outlined),
              _buildNavItem(index: 3, label: '콘텐츠', icon: Icons.collections_outlined),
              _buildNavItem(index: 4, label: '마이페이지', icon: Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final bool selected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTapNav(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected
                  ? const Color(0xFF161411)
                  : const Color(0xFF897260),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Epilogue',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected
                    ? const Color(0xFF161411)
                    : const Color(0xFF897260),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return '홈';
      case 1:
        return '게시판';
      case 2:
        return '가이드';
      case 3:
        return '콘텐츠';
      case 4:
        return '마이페이지';
      default:
        return '댕가이드';
    }
  }
}