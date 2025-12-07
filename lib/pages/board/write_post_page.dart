// lib/pages/board/write_post_page.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'post.dart';

class WritePostPage extends StatefulWidget {
  const WritePostPage({super.key});

  @override
  State<WritePostPage> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // ✅ 서버 주소 (게시판 API prefix까지만)
  static const String _baseUrl = 'http://10.0.2.2:5000/api';

  // 여러 장 이미지 (최대 10장)
  List<XFile> _images = [];

  // SharedPreferences 키
  static const String _draftTitleKey = 'draft_title';
  static const String _draftContentKey = 'draft_content';
  static const String _draftImagePathsKey = 'draft_image_paths';

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// 임시저장 불러오기 (불러온 뒤 바로 삭제 = 한 번만 복원)
  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();

    final title = prefs.getString(_draftTitleKey) ?? '';
    final content = prefs.getString(_draftContentKey) ?? '';
    final imagePaths = prefs.getStringList(_draftImagePathsKey) ?? [];

    setState(() {
      _titleController.text = title;
      _contentController.text = content;
      _images = imagePaths.map((p) => XFile(p)).toList();
    });

    await prefs.remove(_draftTitleKey);
    await prefs.remove(_draftContentKey);
    await prefs.remove(_draftImagePathsKey);
  }

  /// 이미지 여러 장 선택 (최대 10장)
  Future<void> _pickImages() async {
    final remain = 10 - _images.length;
    if (remain <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지는 최대 10장까지 첨부할 수 있어요.')),
      );
      return;
    }

    final picked = await _picker.pickMultiImage();
    if (picked.isEmpty) return;

    setState(() {
      _images.addAll(picked.take(remain));
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _saveTemp() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_draftTitleKey, _titleController.text);
    await prefs.setString(_draftContentKey, _contentController.text);
    await prefs.setStringList(
      _draftImagePathsKey,
      _images.map((e) => e.path).toList(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('임시 저장되었습니다.')),
    );
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftTitleKey);
    await prefs.remove(_draftContentKey);
    await prefs.remove(_draftImagePathsKey);
  }

  bool _hasEditing() {
    return _titleController.text.trim().isNotEmpty ||
        _contentController.text.trim().isNotEmpty ||
        _images.isNotEmpty;
  }

  Future<bool> _onWillPop() async {
    if (!_hasEditing()) {
      return true;
    }

    final result = await _showLeaveDialog();
    return result ?? false;
  }

  Future<bool?> _showLeaveDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('작성 중인 글이 있습니다.'),
          content: const Text(
            '페이지를 나가시겠습니까?\n'
                '\n임시저장 후 나가기 또는 작성취소를 선택할 수 있어요.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // 계속 작성
              },
              child: const Text('계속 작성'),
            ),
            TextButton(
              onPressed: () async {
                await _clearDraft();           // 작성 취소
                Navigator.pop(context, true);
              },
              child: const Text(
                '작성 취소',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _saveTemp();             // 임시저장
                Navigator.pop(context, true);
              },
              child: const Text('임시저장'),
            ),
          ],
        );
      },
    );
  }

  /// ✅ 글 생성 + (이미지 있으면) 이미지 업로드
  Future<void> _upload() async {
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

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 1; // 임시: 1

    try {
      // 🔥 글 생성: POST /api/posts
      final uri = Uri.parse('$_baseUrl/posts');

      final body = <String, dynamic>{
        'user_id': userId,
        'title': title,
        'content': content,
      };

      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (resp.statusCode != 201) {
        throw Exception('status: ${resp.statusCode}, body: ${resp.body}');
      }

      final Map<String, dynamic> json = jsonDecode(resp.body);
      if (json['ok'] != true) {
        throw Exception('서버 ok=false: ${resp.body}');
      }

      final Map<String, dynamic> createdPost =
      json['post'] as Map<String, dynamic>;
      final int postId = createdPost['id'] as int;

      // 🔥 이미지가 있다면 추가로 업로드
      if (_images.isNotEmpty) {
        await _uploadImages(postId);
      }

      await _clearDraft();

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('업로드 실패: $e')),
      );
    }
  }

  /// ✅ 이미지 업로드: POST /api/posts/<postId>/images
  Future<void> _uploadImages(int postId) async {
    final uri = Uri.parse('$_baseUrl/posts/$postId/images');
    final request = http.MultipartRequest('POST', uri);

    // 🔥 Flask 쪽에서 request.files.getlist("images") 로 받으니까
    //    필드 이름은 꼭 "images" 여야 함.
    for (final xfile in _images) {
      final file = File(xfile.path);
      if (!file.existsSync()) continue;

      request.files.add(
        await http.MultipartFile.fromPath('images', file.path),
      );
    }

    final streamedResp = await request.send();
    final resp = await http.Response.fromStream(streamedResp);

    if (resp.statusCode != 201) {
      throw Exception(
          '이미지 업로드 실패: ${resp.statusCode}, body: ${resp.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF0E8DD),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              final canPop = await _onWillPop();
              if (canPop && mounted) {
                Navigator.pop(context);
              }
            },
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
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
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
                  width: 260,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFD0C1AE)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: _pickImages,
                    child: _images.isEmpty
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
                        : Stack(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.all(8),
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            final img = _images[index];
                            return Stack(
                              children: [
                                Container(
                                  margin:
                                  const EdgeInsets.only(right: 8),
                                  width: 120,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image:
                                      FileImage(File(img.path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _removeImage(index),
                                    child: Container(
                                      decoration:
                                      const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black54,
                                      ),
                                      padding:
                                      const EdgeInsets.all(2),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_images.length}/10',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    onPressed: _upload, // ✅ 서버 업로드
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
      ),
    );
  }
}
