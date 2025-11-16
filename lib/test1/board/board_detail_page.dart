import 'package:flutter/material.dart';
import 'post.dart';

class BoardDetailPage extends StatefulWidget {
  final PostItem post;

  const BoardDetailPage({super.key, required this.post});

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  late bool isLiked;
  late int likeCount;

  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [
    '임시 댓글입니다. 서버 연결 후 실제 댓글이 들어갈 예정이에요.',
  ];

  @override
  void initState() {
    super.initState();
    isLiked = false;
    likeCount = widget.post.likes;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.add(text);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF0E8DD);

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

            // 본문 (지금은 임시 텍스트, 나중에 서버 연동하면 여기 채우면 됨)
            const Text(
              '여기에 실제 게시글 내용이 들어갈 예정입니다.\n'
                  '현재는 서버 연동 전이라 예시 텍스트만 보여주고 있어요.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),

            // 좋아요 / 댓글 수
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
                Text('$likeCount'),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble_outline,
                    size: 18, color: Color(0xFF8F7A64)),
                const SizedBox(width: 4),
                Text('${_comments.length}'),
              ],
            ),

            const Divider(height: 32),

            const Text(
              '댓글',
              style: TextStyle(fontWeight: FontWeight.w600),
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
                      child: Text(c),
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
