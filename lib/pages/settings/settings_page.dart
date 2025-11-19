// lib/pages/settings/settings_page.dart

import 'package:flutter/material.dart';
import '../../common_frame.dart';
import '../auth/start_page.dart';
import 'inquiry_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _alarmOn = false;

  @override
  Widget build(BuildContext context) {
    // ✔ SettingsPage는 RootScreen 안에 포함되지 않는 "독립 페이지"므로 CommonFrame 직접 사용 OK
    return CommonFrame(
      showBackButton: true,
      currentIndex: -1,  // 탭 선택 없음
      onTapNav: (_) {},
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: const Color(0xFFF0E8DD),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 402),
            child: _buildCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EDE1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '설정',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C110C),
            ),
          ),
          const SizedBox(height: 24),

          _buildNotificationSwitch(),
          const SizedBox(height: 30),

          _buildSettingButton(
            label: '서비스 문의',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InquiryPage()),
              );
            },
          ),
          const SizedBox(height: 16),

          _buildSettingButton(
            label: '로그아웃',
            onPressed: () => _showLogoutDialog(context),
          ),
          const SizedBox(height: 16),

          _buildSettingButton(
            label: '회원 탈퇴',
            onPressed: () => _showWithdrawDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EDE8),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '알림 받기',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C110C),
            ),
          ),
          Switch(
            value: _alarmOn,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFED6D11),
            onChanged: (value) => setState(() => _alarmOn = value),
          ),
        ],
      ),
    );
  }

  // 버튼 공통
  Widget _buildSettingButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF2EDE8),
          side: BorderSide(color: Colors.black.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C110C),
          ),
        ),
      ),
    );
  }

  // --- 공통 다이얼로그 ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return _buildConfirmDialog(
          ctx,
          title: '정말 로그아웃 하시겠습니까?',
          confirmText: '로그아웃',
          onConfirm: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const StartPage()),
                  (route) => false,
            );
          },
        );
      },
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return _buildConfirmDialog(
          ctx,
          title: '정말 회원탈퇴 하시겠습니까?',
          confirmText: '회원탈퇴',
          onConfirm: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const StartPage()),
                  (route) => false,
            );
          },
        );
      },
    );
  }

  Widget _buildConfirmDialog(
      BuildContext context, {
        required String title,
        required String confirmText,
        required VoidCallback onConfirm,
      }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C110C),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2EDE8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      '돌아가기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C110C),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEE6F7E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onConfirm,
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C110C),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
