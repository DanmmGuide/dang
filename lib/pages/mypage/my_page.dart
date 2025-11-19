// lib/pages/mypage/my_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? _profileImagePath;

  Future<void> _pickImage() async {
    // TODO: 나중에 image_picker로 교체
    /*
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
    }
    */

    // 임시 테스트용
    setState(() {
      _profileImagePath = 'assets/cat_mypage.png';
    });
  }

  ImageProvider? _buildProfileImage() {
    if (_profileImagePath == null) return null;
    if (_profileImagePath!.startsWith('assets/')) {
      return AssetImage(_profileImagePath!);
    }
    return FileImage(File(_profileImagePath!));
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF0E8DD);

    // ❗ 여기서 Scaffold, CommonFrame 절대 X
    return Container(
      color: backgroundColor,
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // 프로필 사진
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _profileImagePath == null
                      ? Colors.white
                      : const Color(0xFFF5EDE1),
                  image: _buildProfileImage() != null
                      ? DecorationImage(
                    image: _buildProfileImage()!,
                    fit: BoxFit.cover,
                  )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _profileImagePath == null
                    ? const Icon(Icons.camera_alt,
                    size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              '<코코>',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C110C),
              ),
            ),
            const SizedBox(height: 20),

            _buildInfoGroup(
              title: '[사용자 정보]',
              children: [
                _buildInfoBox('보호자 이름', '혀누'),
              ],
            ),
            const SizedBox(height: 20),

            _buildInfoGroup(
              title: '[반려동물 정보]',
              children: [
                _buildInfoBox('반려동물 이름', '코코'),
                _buildInfoBox('종', '랙돌'),
                _buildInfoBox('생년월일', '2024.02.15.'),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox('성별', '남', isHalf: true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoBox('중성화', 'O', isHalf: true),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox('몸무게', '7.5 kg', isHalf: true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInfoBox('-', '-', isHalf: true),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C110C),
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildInfoBox(String label, String value, {bool isHalf = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EDE1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Text(
              '$label |',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1C110C),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1C110C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
