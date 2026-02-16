class SendMessageEntity {
  String? content;
  List<dynamic>? attachments;
  List<dynamic>? reactions;
  String? parentMessageId;
  String? conversationId;
  SendMessageEntity({
    this.content,
    this.attachments,
    this.reactions,
    this.parentMessageId,
    this.conversationId,
  });
  Map<String, dynamic> toJson() {
    return {
      "conversationId": conversationId.toString(),
      'content': content,
      'attachments': attachments,
      'reactions': reactions,
      'parentMessageId': parentMessageId,
    };
  }
}
