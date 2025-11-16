import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;                 // 현재 선택된 탭
  final ValueChanged<int> onItemSelected; // 탭 눌렀을 때 콜백

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _NavItem(
            label: '홈',
            icon: Icons.home,
            selected: currentIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          _NavItem(
            label: '게시판',
            icon: Icons.list,
            selected: currentIndex == 1,
            onTap: () => onItemSelected(1),
          ),
          _NavItem(
            label: '가이드',
            icon: Icons.book_outlined,
            selected: currentIndex == 2,
            onTap: () => onItemSelected(2),
          ),
          _NavItem(
            label: '콘텐츠',
            icon: Icons.play_circle_outline,
            selected: currentIndex == 3,
            onTap: () => onItemSelected(3),
          ),
          _NavItem(
            label: '마이페이지',
            icon: Icons.person_outline,
            selected: currentIndex == 4,
            onTap: () => onItemSelected(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color:
              selected ? const Color(0xFF161411) : const Color(0xFF897260),
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
}

