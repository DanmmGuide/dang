// lib/pages/board/board_detail_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'post.dart';
import '../../network/api_config.dart';

class BoardDetailPage extends StatefulWidget {
  final PostItem post; // 목록에서 넘어온 간단 정보 (id, title 등)
  final int userId;    // ✅ 현재 로그인한 유저 id

  const BoardDetailPage({
    super.key,
    required this.post,
    required this.userId,
  });

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  // ✅ 서버 주소 (BoardPage, WritePostPage랑 통일)
  final String _baseUrl = ApiConfig.baseUrl;

  late PostItem _post;
  bool _isLoading = true;
  String? _errorMessage;

  // ✅ 좋아요 상태
  bool _isLiking = false;
  bool _likedByMe = false; // 서버에서 liked_by_me 내려주면 사용

  // ✅ 댓글 입력 상태 (팝업 X, 화면 아래 인풋바)
  final TextEditingController _commentController = TextEditingController();
  bool _isSendingComment = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _loadDetail();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    if (_post.id == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 🔥 userId를 쿼리스트링으로 같이 보냄
      final uri = Uri.parse('$_baseUrl/posts/${_post.id}?user_id=${widget.userId}');
      final resp = await http.get(uri);

      if (resp.statusCode != 200) {
        throw Exception('status: ${resp.statusCode}, body: ${resp.body}');
      }

      final Map<String, dynamic> json = jsonDecode(resp.body);
      if (json['ok'] != true) {
        throw Exception('ok=false: ${json['error'] ?? ''}');
      }

      final postJson = json['post'] as Map<String, dynamic>;
      final detailPost = PostItem.fromJson(postJson);

      setState(() {
        _post = detailPost;

        // ✅ 서버에서 내려준 liked_by_me 반영
        if (postJson.containsKey('liked_by_me')) {
          _likedByMe = postJson['liked_by_me'] == true;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = '상세 정보를 불러오는 중 오류가 발생했어요.\n$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  // ------------------ 좋아요 토글 ------------------
  Future<void> _toggleLike() async {
    if (_post.id == null || _isLiking) return;

    setState(() {
      _isLiking = true;
    });

    try {
      final uri = Uri.parse('$_baseUrl/posts/${_post.id}/like');

      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': widget.userId,
        }),
      );

      if (resp.statusCode != 200) {
        throw Exception('status: ${resp.statusCode}, body: ${resp.body}');
      }

      final Map<String, dynamic> json = jsonDecode(resp.body);
      if (json['ok'] != true) {
        throw Exception(json['error'] ?? '좋아요 실패');
      }

      final bool liked = json['liked'] == true;

      setState(() {
        _likedByMe = liked;
        if (liked) {
          _post.likes += 1;
        } else {
          if (_post.likes > 0) _post.likes -= 1;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요 처리 중 오류가 발생했습니다.\n$e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }
    }
  }

  // ------------------ 댓글 전송 ------------------
  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty || _post.id == null || _isSendingComment) return;

    setState(() {
      _isSendingComment = true;
    });

    try {
      final uri = Uri.parse('$_baseUrl/posts/${_post.id}/comments');

      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': widget.userId,
          'content': content,
        }),
      );

      if (resp.statusCode != 201) {
        throw Exception('status: ${resp.statusCode}, body: ${resp.body}');
      }

      final Map<String, dynamic> json = jsonDecode(resp.body);
      if (json['ok'] != true) {
        throw Exception(json['error'] ?? '댓글 등록 실패');
      }

      _commentController.clear();

      // ✅ 댓글 목록/개수 다시 불러오기
      await _loadDetail();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글 등록 중 오류가 발생했습니다.\n$e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSendingComment = false;
        });
      }
    }
  }

  // ------------------ UI ------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0E8DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0E8DD),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          '게시글 상세',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
      // ✅ 팝업 대신 화면 아래에 고정된 댓글 입력바
      bottomNavigationBar: _buildCommentInputBar(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadDetail,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            _post.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3E2F23),
            ),
          ),
          const SizedBox(height: 8),

          // 작성자 / 날짜
          Row(
            children: [
              Text(
                _post.authorName ?? '익명',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8F7A64),
                ),
              ),
              const SizedBox(width: 8),
              const Text('·', style: TextStyle(color: Color(0xFF8F7A64))),
              const SizedBox(width: 8),
              Text(
                _post.createdAt ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB6A795),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ✅ 좋아요 / 댓글 수 (UI는 예전 그대로, 좋아요만 토글 가능)
          Row(
            children: [
              GestureDetector(
                onTap: _isLiking ? null : _toggleLike,
                child: Icon(
                  _likedByMe ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: const Color(0xFF8F7A64),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${_post.likes}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chat_bubble_outline,
                size: 18,
                color: Color(0xFF8F7A64),
              ),
              const SizedBox(width: 4),
              Text(
                '${_post.comments}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 이미지 슬라이드
          if (_post.imagePaths.isNotEmpty) ...[
            SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: _post.imagePaths.length,
                itemBuilder: (context, index) {
                  final url = _post.imagePaths[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, _, __) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // 본문 내용
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF7F0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _post.content ?? '',
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF3E2F23),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 댓글 영역 (옛날 UI 그대로)
          _buildCommentsSection(),
          const SizedBox(height: 80), // 아래 인풋바랑 겹치지 않도록 여백
        ],
      ),
    );
  }

  // ------------------ 댓글 리스트 (옛날 UI 그대로) ------------------
  Widget _buildCommentsSection() {
    final comments = _post.commentItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '댓글',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E2F23),
          ),
        ),
        const SizedBox(height: 8),

        if (comments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '첫 댓글을 남겨보세요!',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF8F7A64),
              ),
            ),
          )
        else
          Column(
            children: comments.map((c) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EDE2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          c.userName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5B4937),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (c.createdAt != null)
                          Text(
                            c.createdAt!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFFB6A795),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      c.content,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3E2F23),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  // ------------------ 화면 아래 댓글 입력 바 ------------------
  Widget _buildCommentInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFFF5EDE2),
          border: Border(
            top: BorderSide(color: Color(0xFFE3D7C8), width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '댓글을 입력하세요',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB6A795),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFDF7F0),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFFD0C1AE),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 40,
              width: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8F7A64),
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                ),
                onPressed: _isSendingComment ? null : _submitComment,
                child: _isSendingComment
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Icon(
                  Icons.send,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
