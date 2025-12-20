import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import '../../domain/entity/conversation.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final String id;
  final DismissDirectionCallback? onDismissed;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.id,
    this.onDismissed,
  });

  bool get _hasPhotoInLastMessage {
    final msg = conversation.lastMessage?.content ?? '';
    final l = msg.toLowerCase();
    return l.contains('photo') || l.contains('📷');
  }

  String _lastMessagePreview() {
    final lm = conversation.lastMessage?.content;

    if (lm == null || lm.isEmpty) {
      if (conversation.lastMessage != null) {
        return '📷 Photo';
      }
      return '';
    }

    return lm;
  }

  String _timeLabel() {
    final ts =
        conversation.lastMessage?.sentDate ?? conversation.lastMessageDate;
    if (ts == null) return '';
    final now = DateTime.now();
    final diff = now.difference(ts);
    if (diff.inDays >= 1) {
      if (diff.inDays == 1) return 'Hier';
      if (diff.inDays < 7) return '${diff.inDays} j';
      return '${ts.day.toString().padLeft(2, '0')}/${ts.month.toString().padLeft(2, '0')}/${ts.year}';
    }
    return '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}';
  }

  ImageProvider? _avatarProvider() {
    final image =
        conversation.image ?? conversation.lastMessage?.sender.profile?.photo;
    if (image == null || image.isEmpty) return null;
    if (image.startsWith('http')) return NetworkImage(image);
    return AssetImage(image) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final avatar = _avatarProvider();

    return Dismissible(
      key: Key(conversation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: onDismissed,
      child: InkWell(
        onTap: () => context.go('/conversations/$id'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Hero(
                tag: 'avatar_${conversation.id}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withAlpha(
                    (0.12 * 255).round(),
                  ),
                  backgroundImage: avatar,
                  child: avatar == null
                      ? Text(
                          conversation.title.isNotEmpty
                              ? conversation.title[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.title,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _timeLabel(),
                          style: textTheme.bodySmall?.copyWith(
                            color: textTheme.bodySmall?.color?.withAlpha(160),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (_hasPhotoInLastMessage) ...[
                          Icon(Icons.photo, size: 16, color: Colors.grey[500]),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            _lastMessagePreview(),
                            style: textTheme.bodyMedium?.copyWith(
                              color: textTheme.bodySmall?.color?.withAlpha(200),
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (conversation.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              conversation.unreadCount > 99
                                  ? '99+'
                                  : conversation.unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
