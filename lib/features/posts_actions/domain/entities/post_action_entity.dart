

import 'dart:io';

import 'package:dio/dio.dart';

class PostCreationEntity{
  final String content;
  final List<String> tags;
  List<File> files;
  final String type;

  PostCreationEntity({
    required this.content,
    required this.tags,
    required this.files,
    required this.type,
  });
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'tags[]': tags,

      if(files.isNotEmpty) 'files': files.map(
              (file) =>
              MultipartFile.fromFileSync(file.path, filename: file.path
                  .split('/')
                  .last)).toList(),
      'type': type,
    };
  }

}