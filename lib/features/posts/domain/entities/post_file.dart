class PostFile{
  final String fileId;
  final String url;
  final String fileType;

  PostFile({
    required this.fileId,
    required this.url,
    required this.fileType,
  });

  factory PostFile.fromJson(Map<String, dynamic> json) {
    return PostFile(
      fileId: json['fileId'],
      url: json['url'],
      fileType: json['fileType'],
    );
  }
}