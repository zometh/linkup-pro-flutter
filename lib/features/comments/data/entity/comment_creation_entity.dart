import 'dart:io';

import 'package:dio/dio.dart';

class CommentCreationEntity {
  final String content;
  File? file;
  final String? parentId;
  final String postId;

  CommentCreationEntity({
    required this.content,
    this.file,
    this.parentId,
    required this.postId,
});
  Map<String, dynamic> toMap() => {
    'content': content,
    if(parentId != null) 'parentId': parentId,
    if(file != null) "file": MultipartFile.fromFileSync(
        file!.path, filename: file!.path)
  };

}