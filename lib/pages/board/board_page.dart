// lib/pages/board/board_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'write_post_page.dart';
import 'post.dart';
import 'board_detail_page.dart';

import '../../network/api_config.dart';

class BoardPage extends StatefulWidget {
  final int userId;

  const BoardPage({
    super.key,
    required this.userId, // ✅ main에서 BoardPage()만 호출해도 에러 안 나게
  });

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  // ✅ Flask 서버 주소
  final String _baseUrl = ApiConfig.baseUrl;

  List<PostItem> _allPosts = []; // 서버에서 받은 전체 게시글
  String _selectedFilter = '전체';
  int _currentPage = 1;
  static const int _pageSize = 10;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final uri = Uri.parse('$_baseUrl/posts');
      final resp = await http.get(uri);

      if (resp.statusCode != 200) {
        throw Exception('status: ${resp.statusCode}, body: ${resp.body}');
      }

      final Map<String, dynamic> json = jsonDecode(resp.body);

      if (json['ok'] != true) {
        throw Exception('서버에서 ok=false 응답: ${resp.body}');
      }

      final List<dynamic> jsonList = json['posts'] as List<dynamic>;

      final posts = jsonList
          .map((e) => PostItem.fromJson(e as Map<String, dynamic>))
          .toList();

      setState(() {
        _allPosts = posts;
        _currentPage = 1;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '게시글을 불러오는 중 오류가 발생했어요.\n$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<PostItem> get _filteredPosts {
    String query = _searchController.text.trim();

    List<PostItem> list = _allPosts.where((p) {
      if (query.isEmpty) return true;
      return p.title.contains(query);
    }).toList();

    switch (_selectedFilter) {
      case '좋아요 많은 순':
        list.sort((a, b) => b.likes.compareTo(a.likes));
        break;
      case '댓글 많은 순':
        list.sort((a, b) => b.comments.compareTo(a.comments));
        break;
      case '최신순':
      // 나중에 createdAt으로 정렬 가능
        break;
      case '전체':
      default:
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: const Color(0xFFF0E8DD),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        color: const Color(0xFFF0E8DD),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadPosts,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    final posts = _filteredPosts;

    final totalPages = (posts.length / _pageSize).ceil().clamp(1, 999);
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, posts.length);
    final pagedPosts = posts.sublist(startIndex, endIndex);

    return Container(
      color: const Color(0xFFF0E8DD),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: pagedPosts.length,
                  itemBuilder: (context, index) {
                    final post = pagedPosts[index];
                    return _PostCard(
                      post: post,
                      onTap: () => _openPostDetail(post),
                    );
                  },
                ),
              ),

              // 페이지 번호
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: _PageNumberBar(
                  currentPage: _currentPage,
                  totalPages: totalPages,
                  onPageSelected: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                ),
              ),

              // 필터 + 검색
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5EDE2),
                  border: Border(
                    top: BorderSide(color: Color(0xFFE3D7C8), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side:
                          const BorderSide(color: Color(0xFFB79A7B)),
                          backgroundColor: const Color(0xFFF0E3D3),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _openFilterSheet,
                        icon: const Icon(Icons.menu,
                            size: 18, color: Colors.black),
                        label: Text(
                          _selectedFilter,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5B4937),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: '검색하기',
                            hintStyle: const TextStyle(
                              color: Color(0xFFB6A795),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFFDF7F0),
                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFFD0C1AE),
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Color(0xFF8F7A64),
                              ),
                              onPressed: () {
                                setState(() {
                                  _currentPage = 1;
                                });
                              },
                            ),
                          ),
                          onSubmitted: (_) {
                            setState(() {
                              _currentPage = 1;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 글쓰기 버튼
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF8F7A64),
              onPressed: () async {
                final created = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WritePostPage(),
                  ),
                );

                if (created == true) {
                  _loadPosts();
                }
              },
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _openPostDetail(PostItem post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BoardDetailPage(
          post: post,
          userId: widget.userId, // ✅ 상세 화면에 유저 id 전달
        ),
      ),
    );
    setState(() {}); // 돌아왔을 때 새로고침 필요시 나중에 _loadPosts()로 바꿔도 됨
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF7EADA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        final filters = ['전체', '좋아요 많은 순', '댓글 많은 순', '최신순'];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '필터 선택',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...filters.map((f) {
                return RadioListTile<String>(
                  dense: true,
                  title: Text(f),
                  value: f,
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedFilter = value;
                      _currentPage = 1;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _openWriteDialog() {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('새 글 작성'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: '제목',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  setState(() {
                    _allPosts.insert(
                      0,
                      PostItem(title: title, likes: 0, comments: 0),
                    );
                    _currentPage = 1;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('등록'),
            ),
          ],
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostItem post;
  final VoidCallback onTap;

  const _PostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF7F0),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3E2F23),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),

              if (post.imagePaths.isNotEmpty) ...[
                const Icon(Icons.photo, size: 16, color: Color(0xFF8F7A64)),
                const SizedBox(width: 4),
                Text(
                  '${post.imagePaths.length}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 12),
              ],

              Row(
                children: [
                  const Icon(Icons.favorite_border,
                      size: 16, color: Color(0xFF8F7A64)),
                  const SizedBox(width: 4),
                  Text(
                    '${post.likes}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chat_bubble_outline,
                      size: 16, color: Color(0xFF8F7A64)),
                  const SizedBox(width: 4),
                  Text(
                    '${post.comments}',
                    style: const TextStyle(fontSize: 12),
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

class _PageNumberBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  const _PageNumberBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(totalPages, (i) => i + 1).take(10).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pages.map((page) {
        final isSelected = page == currentPage;
        return InkWell(
          onTap: () => onPageSelected(page),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF3E2F23)
                    : const Color(0xFF8F7A64),
                decoration: isSelected
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
