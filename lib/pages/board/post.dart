class PostItem {
  String title;
  int likes;
  int comments;
  List<CommentItem> commentItems;
  List<String> imagePaths;
  String? content;

  PostItem({
    required this.title,
    required this.likes,
    required this.comments,
    List<CommentItem>? commentItems,
    List<String>? imagePaths,
    this.content,
  })  : commentItems = commentItems ?? [],
        imagePaths = imagePaths ?? [];
}

class CommentItem {
  final String userName;
  final String content;

  CommentItem({
    required this.userName,
    required this.content,
  });
}

