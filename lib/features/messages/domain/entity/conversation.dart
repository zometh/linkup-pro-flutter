import 'conversation_sender.dart';

class Conversation {
  final String id;
  final String? image;
  final String title;
  final bool isGroup;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastMessageDate;
  ConversationLastMessage? lastMessage;
  final int unreadCount;

  Conversation({
    required this.id,
    this.image,
    required this.title,
    required this.isGroup,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessageDate,
    this.lastMessage,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      image: json['image'] as String?,
      title: json['title'] as String,
      isGroup: json['isGroup'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastMessageDate: json['lastMessageDate'] != null
          ? DateTime.parse(json['lastMessageDate'] as String)
          : null,
      lastMessage: json['lastMessage'] != null
          ? ConversationLastMessage.fromJson(
              json['lastMessage'] as Map<String, dynamic>,
            )
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'isGroup': isGroup,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastMessageDate': lastMessageDate?.toIso8601String(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
    };
  }
}

class ConversationLastMessage {
  final String id;
  final String? content;
  final DateTime sentDate;
  final ConversationSender sender;

  ConversationLastMessage({
    required this.id,
    this.content,
    required this.sentDate,
    required this.sender,
  });

  factory ConversationLastMessage.fromJson(Map<String, dynamic> json) {
    return ConversationLastMessage(
      id: json['id'] as String,
      content: json['content'] as String?,
      sentDate: DateTime.parse(json['sentDate'] as String),
      sender: ConversationSender.fromJson(
        json['sender'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sentDate': sentDate.toIso8601String(),
      'sender': sender.toJson(),
    };
  }
}
