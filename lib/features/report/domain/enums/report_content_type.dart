enum ReportContentType{
  publication,
  comment,
  user
}

String reportContentTypeToString(ReportContentType type){
  switch(type){
    case ReportContentType.publication:
      return 'PUBLICATION';
    case ReportContentType.comment:
      return 'COMMENT';
    case ReportContentType.user:
      return 'USER';
  }
}