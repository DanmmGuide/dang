import 'package:flutter/material.dart';
import '../app_bottom_nav.dart';
import 'board_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'post.dart';

class WritePostPage extends StatefulWidget {
  const WritePostPage({super.key});

  @override
  State<WritePostPage> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImageFile;
  static const String _draftTitleKey = 'draft_title';
  static const String _draftContentKey = 'draft_content';
  static const String _draftImagePathKey = 'draft_image_path';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();

    final title = prefs.getString(_draftTitleKey) ?? '';
    final content = prefs.getString(_draftContentKey) ?? '';
    final imagePath = prefs.getString(_draftImagePathKey);

    setState(() {
      _titleController.text = title;
      _contentController.text = content;
      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (file.existsSync()) {
          _selectedImageFile = file;
        }
      }
    });
  }



  Future<void> _saveTemp() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_draftTitleKey, _titleController.text);
    await prefs.setString(_draftContentKey, _contentController.text);

    if (_selectedImageFile != null) {
      await prefs.setString(_draftImagePathKey, _selectedImageFile!.path);
    } else {
      await prefs.remove(_draftImagePathKey);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('임시 저장되었습니다.')),
    );
  }


  void _upload() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요.')),
      );
      return;
    }
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용을 입력해주세요.')),
      );
      return;
    }

    // 지금은 내용/이미지는 아직 안 쓰고, 제목만 PostItem에 넣어서 되돌려줌
    final newPost = PostItem(
      title: title,
      likes: 0,
      comments: 0,
    );

    Navigator.pop(context, newPost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF0E8DD),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '게시판 글쓰기',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 입력
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '제목을 입력하세요.',
                filled: true,
                fillColor: const Color(0xFFF5EDE2),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFD0C1AE)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFD0C1AE)),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // 이미지 선택 박스
            Center(
              child: Container(
                width: 220,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFD0C1AE)),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: _pickImage,  // ← 여기서 갤러리 열기
                  child: _selectedImageFile == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt_outlined,
                          size: 32, color: Color(0xFF8F7A64)),
                      SizedBox(height: 8),
                      Text(
                        '이미지를 선택해주세요\n(최소 1장, 최대 10장)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8F7A64),
                        ),
                      ),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      _selectedImageFile!,
                      width: 220,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // 내용 입력
            const Text(
              '내용을 입력하세요.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5B4937),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EDE2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD0C1AE)),
              ),
              child: TextField(

                controller: _contentController,
                maxLines: 10,
                minLines: 5,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  hintText: '내용을 입력해주세요.',
                  hintStyle: TextStyle(
                    color: Color(0xFFB6A795),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 버튼들 (임시저장 / 업로드)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side:
                    const BorderSide(color: Color(0xFFD0C1AE)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color(0xFFF5EDE2),
                  ),
                  onPressed: _saveTemp,
                  child: const Text(
                    '임시저장',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5B4937),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F7A64),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _upload,
                  child: const Text(
                    '업로드',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // 글쓰기 화면에도 하단 네비 그대로 보여주기 (선택은 게시판)
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onItemSelected: (index) {
          if (index == 1) return; // 이미 게시판 계열 화면
          if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
                  (route) => false,
            );
          }
        },
      ),
    );
  }
}
