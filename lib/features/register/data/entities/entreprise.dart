import 'dart:io';

import 'package:dio/dio.dart';

class Entreprise {
  final String name;
  final String description;
  final String phone;
  final String size;
  final String? logo; // Changed from File to String?
  final String website;
  final DateTime creationDate;
  final String sector;
  Entreprise({
    required this.name,
    required this.description,
    required this.phone,
    required this.size,
    this.logo,
    required this.website,
    required this.creationDate,
    required this.sector,
  });
  factory Entreprise.fromJson(Map<String, dynamic> json) {
    return Entreprise(
      name: json['name'],
      description: json['description'],
      phone: json['phone'],
      size: json['size'],
      logo: json['logo'], // Store as string
      website: json['website'],
      creationDate: DateTime.parse(json['creationDate']),
      sector: json['sector'],
    );
  }

  bool get isLocalFile {
    if (logo == null) return false;
    return !logo!.startsWith('http://') && !logo!.startsWith('https://');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'phone': phone,
      'size': size,
      'logo': (logo != null && isLocalFile)
          ? MultipartFile.fromFileSync(logo!, filename: logo!.split('/').last)
          : logo, // Return URL string if remote, or null
      'website': website,
      'creationDate': creationDate.toIso8601String(),
      'sector': sector,
    };
  }
}

enum CompanySize { small, medium, large }
