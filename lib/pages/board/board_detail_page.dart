// lib/pages/board/board_detail_page.dart
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'post.dart';

class BoardDetailPage extends StatefulWidget {
  final PostItem post;

  const BoardDetailPage({super.key, required this.post});

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  // ✅ Flask 서버 주소
  static const String _baseUrl = 'http://10.0.2.2:5000/api';

  late bool isLiked;
  final TextEditingController _commentController = TextEditingController();

  // PostItem 안의 댓글 리스트를 그대로 사용
  List<CommentItem> get _comments => widget.post.commentItems;

  // 이미지 페이지 인덱스 (슬라이더 indicator용)
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    isLiked = false; // 나중에 로그인/서버 붙이면 유저별 좋아요 여부로 세팅
    _loadComments(); // ✅ 디테일 들어오면 서버에서 댓글 불러오기
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// ✅ 서버에서 댓글 목록 불러오기
  Future<void> _loadComments() async {
    if (widget.post.id == null) return; // id 없으면 서버 댓글 없음

    try {
      final uri = Uri.parse('$_baseUrl/posts/${widget.post.id}/comments');
      final resp = await http.get(uri);

      if (resp.statusCode != 200) {
        throw Exception(
            'status: ${resp.statusCode}, body: ${resp.body}');
      }

      final Map<String, dynamic> data =
      jsonDecode(resp.body) as Map<String, dynamic>;
      final List<dynamic> list = data['comments'] as List<dynamic>;

      final comments = list
          .map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {
        widget.post.commentItems
          ..clear()
          ..addAll(comments);
        widget.post.comments = comments.length;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글을 불러오는 중 오류가 발생했어요: $e')),
      );
    }
  }

  /// ✅ 좋아요 토글 → 서버에 반영
  Future<void> _toggleLike() async {
    // id 없으면(이상한 경우) 로컬만 변경
    if (widget.post.id == null) {
      setState(() {
        isLiked = !isLiked;
        widget.post.likes += isLiked ? 1 : -1;
        if (widget.post.likes < 0) widget.post.likes = 0;
      });
      return;
    }

    final oldLiked = isLiked;
    final oldLikes = widget.post.likes;

    // 🔁 낙관적 업데이트 (UI 먼저 반영)
    setState(() {
      isLiked = !isLiked;
      widget.post.likes += isLiked ? 1 : -1;
      if (widget.post.likes < 0) widget.post.likes = 0;
    });

    final delta = isLiked ? 1 : -1;

    try {
      final uri = Uri.parse('$_baseUrl/posts/${widget.post.id}/like');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'delta': delta}),
      );

      if (resp.statusCode != 200) {
        throw Exception(
            'status: ${resp.statusCode}, body: ${resp.body}');
      }

      final Map<String, dynamic> data =
      jsonDecode(resp.body) as Map<String, dynamic>;
      final newLike = (data['like_count'] ?? widget.post.likes) as int;

      setState(() {
        widget.post.likes = newLike;
      });
    } catch (e) {
      // 🚨 실패하면 원래 상태로 롤백
      setState(() {
        isLiked = oldLiked;
        widget.post.likes = oldLikes;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요 처리에 실패했어요: $e')),
      );
    }
  }

  /// ✅ 댓글 작성 → 서버에 저장
  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    // TODO: 나중에 실제 로그인된 유저 이름으로 교체
    const currentUserName = '정우';

    // id 없으면(아직 서버에 없는 글) 로컬에만 추가
    if (widget.post.id == null) {
      setState(() {
        _comments.add(
          CommentItem(
            userName: currentUserName,
            content: text,
          ),
        );
        widget.post.comments = _comments.length;
        _commentController.clear();
      });
      return;
    }

    try {
      final uri = Uri.parse('$_baseUrl/posts/${widget.post.id}/comments');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'author_name': currentUserName,
          'content': text,
        }),
      );

      if (resp.statusCode != 201) {
        throw Exception(
            'status: ${resp.statusCode}, body: ${resp.body}');
      }

      // 입력창 비우기
      _commentController.clear();

      // ✅ 서버 기준으로 최신 댓글 목록 다시 불러오기
      await _loadComments();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글 작성에 실패했어요: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF0E8DD);
    final hasImages = widget.post.imagePaths.isNotEmpty;
    final contentText = widget.post.content ??
        '여기에 실제 게시글 내용이 들어갈 예정입니다.\n'
            '현재는 서버 연동 전이라 예시 텍스트만 보여주고 있어요.';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.brown,
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          '게시판',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              widget.post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            // 🔹 이미지 슬라이더 (여러 장)
            if (hasImages) ...[
              SizedBox(
                height: 240,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: widget.post.imagePaths.length,
                      onPageChanged: (idx) {
                        setState(() {
                          _currentImageIndex = idx;
                        });
                      },
                      itemBuilder: (context, index) {
                        final path = widget.post.imagePaths[index];
                        final file = File(path);

                        if (!file.existsSync()) {
                          // 파일이 없어졌을 경우 대비
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                '이미지를 불러올 수 없습니다.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        }

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            file,
                            width: double.infinity,
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    if (widget.post.imagePaths.length > 1)
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.post.imagePaths.length,
                                (i) {
                              final isActive = i == _currentImageIndex;
                              return Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 3),
                                width: isActive ? 8 : 6,
                                height: isActive ? 8 : 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 🔹 본문 내용
            Text(
              contentText,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),

            // 좋아요만 표시
            Row(
              children: [
                IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 22,
                    color: const Color(0xFF8F7A64),
                  ),
                ),
                Text('${widget.post.likes}'),
              ],
            ),

            const Divider(height: 32),

            Row(
              children: [
                const Text(
                  '댓글',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${_comments.length}', // 👈 댓글 개수
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8F7A64),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 댓글 리스트
            Expanded(
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final c = _comments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF7F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xFF8F7A64),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(c.content),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 댓글 입력창
            SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addComment,
                    icon: const Icon(Icons.create),
                    color: const Color(0xFF8F7A64),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

