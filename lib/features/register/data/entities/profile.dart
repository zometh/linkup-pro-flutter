

import 'dart:io';

import 'package:dio/dio.dart';

class Profile {
  final String? biography;
  final String? phone;
  final DateTime? birthDate;
  final String? portfolio;
  final String sector;
  final File? file;

  Profile({
    this.biography,
    this.phone,
    this.birthDate,
    this.portfolio,
    required this.sector,
    this.file,
  });

  

  Map<String, dynamic> toJson() {
    return {
      if(biography != null) 'biography': biography,
      if(phone != null) 'phone': phone,
      if(birthDate != null) 'birthDate': birthDate?.toIso8601String(),
      if(portfolio != null) 'portfolio': portfolio,
      'sector': sector,
      if(file != null) "photo": MultipartFile.fromFileSync(file!.path, filename: file!.path.split('/').last),
    };
  }
}