import 'conversation_sender.dart';

class MessageEntity {
  String? content;
  DateTime? sentDate;
  DateTime? editedAt;
  bool? isDeleted;
  String? parentMessageId;
  String? conversationId;
  ConversationSender? sender;
  List<dynamic>? attachments;
  List<dynamic>? reactions;
  int? repliesCount;
  String? id;
  MessageEntity({
    this.content,
    this.sentDate,
    this.editedAt,
    this.isDeleted,
    this.parentMessageId,
    this.conversationId,
    this.sender,
    this.attachments,
    this.reactions,
    this.repliesCount,
    this.id,
  });
  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
        if (v is String) return DateTime.tryParse(v);
        return null;
      } catch (_) {
        return null;
      }
    }

    ConversationSender? sender;
    try {
      if (json['sender'] != null && json['sender'] is Map) {
        sender = ConversationSender.fromJson(
          Map<String, dynamic>.from(json['sender']),
        );
      }
    } catch (_) {
      sender = null;
    }

    return MessageEntity(
      content: json['content']?.toString(),
      sentDate: parseDate(json['sentDate']),
      editedAt: parseDate(json['editedAt']),
      isDeleted: json['isDeleted'] as bool?,
      parentMessageId: json['parentMessageId']?.toString(),
      conversationId: json['conversationId']?.toString(),
      sender: sender,
      attachments: json['attachments'] is List
          ? List<dynamic>.from(json['attachments'])
          : (json['attachments'] != null ? [json['attachments']] : null),
      reactions: json['reactions'] is List
          ? List<dynamic>.from(json['reactions'])
          : (json['reactions'] != null ? [json['reactions']] : null),
      repliesCount: json['repliesCount'] is int
          ? json['repliesCount'] as int
          : (json['repliesCount'] != null
                ? int.tryParse(json['repliesCount'].toString())
                : null),
      id: json['id']?.toString(),
    );
  }
}
