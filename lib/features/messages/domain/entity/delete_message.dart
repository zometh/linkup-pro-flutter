class DeleteMessageEntity {
  final String messageId;
  final bool deleteForEveryone;
  final String conversationId;
  DeleteMessageEntity({
    required this.messageId,
    this.deleteForEveryone = false,
    required this.conversationId,
  });
  Map<String, dynamic> toJson() {
    return {
      "messageId": messageId,
      "deleteForEveryone": deleteForEveryone,
      "conversationId": conversationId,
    };
  }
}
