import 'package:linkup_pro/features/posts/domain/entities/post_file.dart';
import 'package:linkup_pro/features/posts/domain/entities/post_owner.dart';
import 'package:linkup_pro/features/posts_actions/domain/enums/post_type.dart';

class Post {
  final String id;
   String content;
  final DateTime publicationDate;
   bool isFollowed;
  int likesCount;
   int commentsCount;
   int sharesCount;
   bool isLiked = false;
   List<PostFile> files;
  final String userId;
   PostType type;
   List<String> tags;
  final PostOwner owner;

  Post({
    required this.id,
    required this.content,
    required this.publicationDate,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.files,
    required this.userId,
    required this.tags,
    required this.owner,
    required this.isLiked,
    this.isFollowed = false,
    required this.type,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    //print(json["type"]);
    final post = Post(
      isFollowed: json['isFollowed'] ?? false,
      id: json['id'],
      content: json['content'],
      publicationDate: DateTime.parse(json['publicationDate']),
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      sharesCount: json['sharesCount'],
      type: getPostType(json["type"]),
      files: (json['files'] as List)
          .map((fileJson) => PostFile.fromJson(fileJson))
          .toList(),
      userId: json['owner']['id'], // Changed: get userId from owner.id
      tags: List<String>.from(json['tags']),
      owner: PostOwner.fromJson(json['owner']),
        isLiked: json['isLiked'] ?? false,
    );
   
    return post;
  }
  toMap() {
    return {
      'id': id,
      'content': content,
      'publicationDate': publicationDate.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      //'files': files.map((file) => file.toJson()).toList(),
      'userId': userId,
      'tags': tags,
    };
  }
  @override
  String toString() {
    // TODO: implement toString
    return ""
        "id: $id\n"
        "content: $content\n"
        "publicationDate: $publicationDate\n"
        "likesCount: $likesCount\n"
        "commentsCount: $commentsCount\n"
        "sharesCount: $sharesCount\n"
        "files: $files\n"
        "userId: $userId\n"
        "tags: $tags\n"
        "isLiked: $isLiked\n"
        "isFollowed: $isFollowed\n"
        "type: $type\n"
        ;
  }
}
