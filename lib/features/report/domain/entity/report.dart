
import '../enums/report_content_type.dart';

class Report{
  final String reason;
  final ReportContentType contentType;
  String? publicationId;
  String? commentId;
  String? userId;
  String? details;
  Report({
    required this.reason,
    required this.contentType,
    this.publicationId,
    this.commentId,
     this.userId,
    this.details,
  });
  Map<String, dynamic>toMap() {
    return {
      "reason": reason,
      "details": details,
      "contentType": reportContentTypeToString(contentType),
      if(publicationId != null) 'publicationId': publicationId,
      if(commentId != null) 'commentId': commentId,
      if(userId != null) 'userId': userId,
    };
  }
}