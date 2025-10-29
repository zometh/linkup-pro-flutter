
import '../../posts/domain/entities/post_owner.dart';

class Comment{
  final String id;
  final String content;
  final DateTime commentDate;
  final int likesCount;
  final String? fileUrl;
  final bool isLikedByUser;
  final String userId;
  final PostOwner owner;
  Comment({
    required this.id,
    required this.content,
    required this.commentDate,
    required this.likesCount,
    this.fileUrl,
    required this.isLikedByUser,
    required this.userId,
    required this.owner,
  });
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      commentDate: DateTime.parse(json['commentDate']),
      likesCount: json['likesCount'],
      fileUrl: json['fileUrl'],
      isLikedByUser: json['isLikedByUser'] ?? false,
      userId: json['owner']['id'],
      owner: PostOwner.fromJson(json['owner']),
    );
  }

}