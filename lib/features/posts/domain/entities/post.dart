import 'package:linkup_pro/features/posts/domain/entities/post_file.dart';
import 'package:linkup_pro/features/posts/domain/entities/post_owner.dart';

class Post {
  final String id;
  final String content;
  final DateTime publicationDate;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final List<PostFile> files;
  final String userId;
  final List<String> tags;
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
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // print(json);
    final post = Post(
      id: json['id'],
      content: json['content'],
      publicationDate: DateTime.parse(json['publicationDate']),
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      sharesCount: json['sharesCount'],
      files: (json['files'] as List)
          .map((fileJson) => PostFile.fromJson(fileJson))
          .toList(),
      userId: json['owner']['id'], // Changed: get userId from owner.id
      tags: List<String>.from(json['tags']),
      owner: PostOwner.fromJson(json['owner']),
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
}
