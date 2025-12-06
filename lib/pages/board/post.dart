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

  // ✅ 목록용 / 상세용 둘 다 커버
  factory PostItem.fromJson(Map<String, dynamic> json) {
    // 이미지
    final dynamic rawImages =
        json['images'] ?? json['image_urls'] ?? json['image_paths'] ?? [];
    final List<String> parsedImages = (rawImages is List)
        ? rawImages.map((e) => e.toString()).toList()
        : <String>[];

    // 댓글 (상세 응답에만 있을 수도 있음)
    final dynamic rawComments = json['comments'];
    final List<CommentItem> parsedComments = (rawComments is List)
        ? rawComments
        .map((e) => CommentItem.fromJson(e as Map<String, dynamic>))
        .toList()
        : <CommentItem>[];

    return PostItem(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      content: json['content'] as String?,
      authorName: (json['author_name'] ?? json['user_name']) as String?,
      createdAt: json['created_at']?.toString(),
      likes: (json['like_count'] ?? json['likes'] ?? 0) as int,
      comments: (json['comment_count'] ?? json['comments_count'] ?? 0) as int,
      commentItems: parsedComments,
      imagePaths: parsedImages,
    );
  }

  // (필요하면) 글 생성용
  Map<String, dynamic> toJsonForCreate(int userId) {
    return {
      'user_id': userId,
      'title': title,
      'content': content ?? '',
    };
  }
}

class CommentItem {
  final String userName;
  final String content;
  final String? createdAt;

  CommentItem({
    required this.userName,
    required this.content,
    this.createdAt,
  });

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return CommentItem(
      userName: json['author_name'] as String? ??
          json['user_name'] as String? ??
          '익명',
      content: json['content'] as String? ?? '',
      createdAt: json['created_at']?.toString(),
    );
  }
}
