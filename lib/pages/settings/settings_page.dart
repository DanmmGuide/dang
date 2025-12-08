import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_frame.dart';
import '../auth/start_page.dart';
import '../../main.dart';

import '../../network/user_api_client.dart';    // 🔥 회원탈퇴 API


class SettingsPage extends StatefulWidget {
  /// 현재 로그인한 유저의 ID
  final int userId;

  const SettingsPage({
    super.key,
    required this.userId,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _userApiClient = const UserApiClient();   // 🔥 회원탈퇴 API
  final TextEditingController _pwController = TextEditingController();

  bool _isWithdrawing = false;

  @override
  void dispose() {
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonFrame(
      title: '설정',
      showBackButton: true,
      showSettingsIcon: false,
      currentIndex: 4,
      onTapNav: (index) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => RootScreen(
              userId: widget.userId,
              initialIndex: index,
            ),
          ),
              (route) => false,
        );
      },
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
          // 로그아웃 버튼
          _buildSettingButton(
            label: '로그아웃',
            onPressed: () => _showLogoutDialog(context),
          ),

          const SizedBox(height: 16),

          // 회원 탈퇴 버튼
          _buildSettingButton(
            label: _isWithdrawing ? '탈퇴 처리 중...' : '회원 탈퇴',
            onPressed: _isWithdrawing ? null : () => _showWithdrawDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton({
    required String label,
    required VoidCallback? onPressed,
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
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C110C),
          ),
        ),
      ),
    );
  }

  // ==============================
  //  🔥  로그아웃 다이얼로그
  // ==============================
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

  // ==============================
  //  🔥  회원탈퇴 다이얼로그
  // ==============================
  void _showWithdrawDialog(BuildContext context) {
    _pwController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '탈퇴 시 계정 정보와 저장된\n반려동물 데이터, 게시글 등이 모두 삭제되며\n복구가 불가능합니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C110C),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // 비밀번호 재입력
                TextField(
                  controller: _pwController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호 재입력',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('돌아가기'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEE6F7E),
                        ),
                        onPressed: () async {
                          Navigator.of(ctx).pop();
                          await _handleWithdraw();
                        },
                        child: const Text(
                          '회원탈퇴',
                          style: TextStyle(
                            color: Color(0xFF1C110C),
                            fontWeight: FontWeight.w700,
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
      },
    );
  }

  // ==============================
  //  🔥 실제 회원탈퇴 처리 로직
  // ==============================
  Future<void> _handleWithdraw() async {
    final password = _pwController.text.trim();
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호를 입력해 주세요.')),
      );
      return;
    }

    // username은 로그인 시 SharedPreferences에 저장되어 있다고 가정
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username == null || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 정보를 찾을 수 없습니다.')),
      );
      return;
    }

    setState(() => _isWithdrawing = true);

    try {
      // 🔥 서버에 탈퇴 요청 (POST /users/delete)
      await _userApiClient.deleteUser(
        username: username,
        password: password,
      );

      if (!mounted) return;

      // 로컬 로그인 정보 삭제
      await prefs.remove('username');
      await prefs.remove('user_id');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원탈퇴가 완료되었습니다.')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const StartPage()),
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원탈퇴에 실패했습니다. 다시 시도해주세요.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isWithdrawing = false);
      }
    }
  }

  // ==============================
  //  🔥 다이얼로그 UI 공통
  // ==============================
  Widget _buildConfirmDialog(
      BuildContext context, {
        required String title,
        required String confirmText,
        required VoidCallback onConfirm,
        double fontSize = 15,
      }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C110C),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('돌아가기'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEE6F7E),
                    ),
                    onPressed: onConfirm,
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        color: Color(0xFF1C110C),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
