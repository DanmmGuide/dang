// lib/pages/board/board_detail_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'post.dart';

class BoardDetailPage extends StatefulWidget {
  final PostItem post; // 목록에서 넘어온 간단 정보 (id, title 등)

  const BoardDetailPage({super.key, required this.post});

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  // ✅ 서버 주소 (BoardPage, WritePostPage랑 통일)
  static const String _baseUrl = 'http://10.0.2.2:5000/api/board';

  late PostItem _post;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    if (_post.id == null) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final uri = Uri.parse('$_baseUrl/posts/${_post.id}');
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

          // 좋아요 / 댓글 수
          Row(
            children: [
              const Icon(Icons.favorite_border,
                  size: 18, color: Color(0xFF8F7A64)),
              const SizedBox(width: 4),
              Text(
                '${_post.likes}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.chat_bubble_outline,
                  size: 18, color: Color(0xFF8F7A64)),
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

          // 댓글 영역
          _buildCommentsSection(),
        ],
      ),
    );
  }

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
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
}
