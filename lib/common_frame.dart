import 'package:flutter/material.dart';
import 'pages/settings_page.dart';

class CommonFrame extends StatelessWidget {
  final Widget body;                // 가운데 내용
  final int currentIndex;           // 현재 선택된 탭 인덱스
  final ValueChanged<int> onTapNav; // 탭 눌렀을 때 콜백

  const CommonFrame({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTapNav,
  });

  @override
  Widget build(BuildContext context) {
    final String title = _titleForIndex(currentIndex);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
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

      // 🔻 AppBottomNav를 여기 안으로 합친 부분
      bottomNavigationBar: Container(
        height: 75,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFF4F2EF), width: 1),
          ),
        ),
        padding: const EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
          bottom: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              index: 0,
              label: '홈',
              icon: Icons.home,
            ),
            _buildNavItem(
              index: 1,
              label: '게시판',
              icon: Icons.list,
            ),
            _buildNavItem(
              index: 2,
              label: '가이드',
              icon: Icons.book_outlined,
            ),
            _buildNavItem(
              index: 3,
              label: '콘텐츠',
              icon: Icons.collections_outlined,
            ),
            _buildNavItem(
              index: 4,
              label: '마이페이지',
              icon: Icons.person_outline,
            ),
          ],
        ),
      ),
    );
  }

  // 개별 탭 아이템
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

  // 탭 인덱스에 따른 상단 타이틀
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
