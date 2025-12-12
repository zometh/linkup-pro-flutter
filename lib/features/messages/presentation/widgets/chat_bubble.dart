import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/messages/domain/entity/delete_message.dart';
import 'package:linkup_pro/features/messages/domain/entity/message_entity.dart';
import 'package:linkup_pro/features/messages/presentation/providers/messages.dart';
import 'package:linkup_pro/features/messages/presentation/widgets/bubble_action_tile.dart';

import '../../../../core/services/localdb/localdb.dart';
import '../../../../core/utils/formatters/format_date.dart';
import '../../../../core/widgets/custom_text.dart';

class BubbleChat extends ConsumerWidget {
  final String conversationId;
  final MessageEntity messageEntity;
  const BubbleChat({
    super.key,
    required this.messageEntity,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localDbService = GetIt.I<LocalDBService>();

    bool isSender = false;
    return FutureBuilder(
      future: localDbService.getUserId(),
      builder: (_, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (!snapshots.hasData || snapshots.data == null) {
          return Center(
            child: CustomText(text: "Aucune information trouvée !"),
          );
        }
        if (snapshots.hasError) {
          return Center(child: CustomText(text: "Une erreur est survenue !"));
        }
        isSender = snapshots.data == messageEntity.sender?.id;

        // Ne pas permettre d'actions sur les messages supprimés
        final isDeleted = messageEntity.isDeleted ?? false;

        return InkWell(
          onLongPress: isDeleted
              ? null
              : () async {
                  HapticFeedback.mediumImpact();

                  await _buildModal(context, isSender, ref);
                },
          child: _buildMessageBubble(context, isSender),
        );
      },
    );
  }

  Future<dynamic> _buildModal(
    BuildContext context,
    bool isSender,
    WidgetRef ref,
  ) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Color(0xFF1C1C1E)
                : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 8),

              BubbleActionTile(
                title: "copy_message",
                icon: Icons.copy,
                onTap: () => _copyToClipboard(context),
              ),
              BubbleActionTile(
                title: "delete_message",
                icon: Icons.delete_outline,
                iconColor: Colors.red,
                onTap: () => _deleteMesage(
                  deleteForEveryone: false,
                  ref: ref,
                  context: context,
                ),
              ),
              if (isSender)
                BubbleActionTile(
                  title: "delete_for_everyone",
                  icon: Icons.delete_forever,
                  iconColor: Colors.red,
                  onTap: () => _deleteMesage(
                    deleteForEveryone: true,
                    ref: ref,
                    context: context,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  _deleteMesage({
    bool deleteForEveryone = false,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    Navigator.pop(context);
    final deletedMessage = DeleteMessageEntity(
      messageId: messageEntity.id!,
      conversationId: conversationId,
      deleteForEveryone: deleteForEveryone,
    );
    await ref.read(messagesProvider.notifier).deleteMessage(deletedMessage);
  }

  _copyToClipboard(BuildContext context) async {
    if (messageEntity.content == null || messageEntity.content!.isEmpty) {
      return;
    }
    Navigator.pop(context);

    await Clipboard.setData(ClipboardData(text: messageEntity.content ?? ""));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(
          text: "message_copied_to_clipboard".tr(),
          color: Colors.white,
        ),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  _buildMessageBubble(BuildContext context, bool isSender) {
    // Vérifier si le message a été supprimé
    final isDeleted = messageEntity.isDeleted ?? false;
    final hasAttachments =
        messageEntity.attachments != null &&
        messageEntity.attachments!.isNotEmpty;
    final hasImage =
        hasAttachments &&
        messageEntity.attachments!.any((att) => att['fileType'] == 'image');

    return Column(
      crossAxisAlignment: isSender
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        // Afficher l'image si présente
        if (hasImage && !isDeleted)
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                messageEntity.attachments!.firstWhere(
                  (att) => att['fileType'] == 'image',
                )['fileUrl'],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

        if (messageEntity.content != null && messageEntity.content!.isNotEmpty)
          Row(
            children: [
              Flexible(
                child: BubbleSpecialOne(
                  isSender: isSender,
                  text: isDeleted
                      ? "Ce message a été supprimé"
                      : (messageEntity.content ?? ""),
                  color: isDeleted
                      ? Colors.grey.shade300
                      : (isSender ? AppColors.primary : Color(0xFFE8E8EE)),
                  textStyle: GoogleFonts.montserrat(
                    color: isDeleted
                        ? Colors.grey.shade600
                        : (isSender ? Colors.white : Colors.black),
                    fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        Padding(
          padding: EdgeInsets.only(right: isSender ? 15 : 0),
          child: Text(
            FormatDate().formatMessageDate(
              messageEntity.sentDate ?? DateTime.now(),
            ),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
