class PostItem {
  int? id;
  String title;
  int likes;
  int comments;
  List<CommentItem> commentItems;
  List<String> imagePaths;
  String? content;
  String? authorName;
  String? createdAt;

  PostItem({
    this.id,
    required this.title,
    required this.likes,
    required this.comments,
    List<CommentItem>? commentItems,
    List<String>? imagePaths,
    this.content,
    this.authorName,
    this.createdAt,
  })  : commentItems = commentItems ?? [],
        imagePaths = imagePaths ?? [];

  // ✅ 서버 JSON → PostItem
  factory PostItem.fromJson(Map<String, dynamic> json) {
    return PostItem(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      content: json['content'] as String?,
      authorName: json['author_name'] as String?,
      createdAt: json['created_at'] as String?,
      // 🔥 여기서 서버에서 온 like_count / comment_count 반영
      likes: (json['like_count'] ?? 0) as int,
      comments: (json['comment_count'] ?? 0) as int,
      commentItems: [],
      imagePaths: [],
    );
  }

  // ✅ 글 작성 시 사용할 JSON
  Map<String, dynamic> toJsonForCreate() {
    return {
      'title': title,
      'content': content ?? '',
      'author_name': authorName ?? '익명',
    };
  }
}

class CommentItem {
  final String userName;
  final String content;

  CommentItem({
    required this.userName,
    required this.content,
  });

  // ✅ 서버 댓글 JSON → CommentItem
  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return CommentItem(
      userName: json['author_name'] as String? ?? '익명',
      content: json['content'] as String? ?? '',
    );
  }
}



