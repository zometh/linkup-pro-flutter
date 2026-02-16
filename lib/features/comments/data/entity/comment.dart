import '../../../posts/domain/entities/post_owner.dart';

class Comment {
  final String id;
  final String content;
  final DateTime commentDate;
  final String postId;
  String? commentId;
  int likesCount;
  final String? fileUrl;
  bool isLikedByUser;
  final String userId;
  int subCommentsCount;
  final PostOwner owner;
  Comment({
    required this.id,
    required this.content,
    required this.commentDate,
    this.likesCount = 0,
    required this.postId,
    this.isLikedByUser = false,
    required this.userId,
    required this.owner,
    this.subCommentsCount = 0,
    this.commentId,
    this.fileUrl,
  });
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json['postId'],
      id: json['id'],
      content: json['content'],
      commentDate: DateTime.parse(json['commentDate']),
      likesCount: json['likesCount'],
      subCommentsCount: json["subCommentsCount"],
      commentId: json['commentId'],
      fileUrl: json['fileUrl'],
      isLikedByUser: json['isLikedByUser'] ?? false,
      userId: json['owner']['id'],
      owner: PostOwner.fromJson(json['owner']),
    );
  }
}
