

import 'dart:io';

class Profile {
  final String? biography;
  final String? phone;
  final DateTime? birthDate;
  final String? portfolio;
  final String visibility;
  final String sector;
  final File? file;

  Profile({
    this.biography,
    this.phone,
    this.birthDate,
    this.portfolio,
    required this.visibility,
    required this.sector,
    this.file,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'biography': biography,
      'phone': phone,
      'birthDate': birthDate?.toIso8601String(),
      'portfolio': portfolio,
      'visibility': visibility,
      'sector': sector,
    };
  }
}