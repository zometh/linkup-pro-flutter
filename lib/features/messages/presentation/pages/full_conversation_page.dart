import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/features/messages/domain/entity/participant_preview.dart';
import 'package:linkup_pro/features/messages/presentation/widgets/conversation_bottom_bar.dart';

import '../../domain/repos_implementation/conversation_repository_implement.dart';
import '../../domain/entity/message_entity.dart';
import '../widgets/chat_bubble.dart';

class FullConversationPage extends StatefulWidget {
  final String conversationId;
  const FullConversationPage({super.key, required this.conversationId});

  @override
  State<FullConversationPage> createState() => _FullConversationPageState();
}

class _FullConversationPageState extends State<FullConversationPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _textCtrl = TextEditingController();
  final List<MessageEntity> _messages = [];
  final io = GetIt.I<SocketService>();
  ParticipantPreview? participantPreview;
  bool _loading = true;
  final _conversationImplements = GetIt.I<ConversationRepositoryImplement>();
  @override
  void initState() {
    super.initState();
    io.joinRoom('conversationSubscribe', {
      "conversationId": widget.conversationId,
    });

    listenNewMessages();

    listenDeletedMessages();

    fetchMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 80), () {
        if (!mounted) return;
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (!mounted) return;
    if (!_scrollCtrl.hasClients) return;
    try {
      _scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    } catch (e) {
      // ignore
    }
  }

  @override
  void dispose() {
    io.off('newMessage');
    io.off('messageDeleted');

    _scrollCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  participantPreview != null &&
                      participantPreview!.image != null
                  ? NetworkImage(participantPreview!.image!)
                  : null,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
              child:
                  participantPreview == null ||
                      participantPreview!.image == null
                  ? Icon(
                      Icons.person,
                      color: isDark ? Colors.white24 : Colors.black26,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                participantPreview?.displayName ?? 'Conversation',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
        titleSpacing: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.transparent,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor.withAlpha(50),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? _buildEmptyState(context, isDark)
                      : ListView.builder(
                          controller: _scrollCtrl,
                          reverse: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            return BubbleChat(
                              messageEntity: msg,
                              conversationId: widget.conversationId,
                            );
                          },
                        ),
                ),
                const SizedBox(height: 60),
              ],
            ),
      bottomSheet: SafeArea(
        child: ConversationBottomBar(conversationId: widget.conversationId),
      ),
    );
  }

  listenNewMessages() {
    //io.off('newMessage');

    // Attacher le nouveau listener
    io.on('newMessage', (data) async {
      await _conversationImplements.markConversationAsRead(
        widget.conversationId,
      );

      try {
        final message = MessageEntity.fromJson(data);

        if (message.conversationId == widget.conversationId) {
          final exists = _messages.any((m) => m.id == message.id);
          if (!exists) {
            setState(() {
              _messages.insert(0, message);
            });
            _scrollToBottom();
          } else {}
        } else {}
      } catch (e) {
        MyLogger().log('Error parsing message: $e');
      }
    });
  }

  void listenDeletedMessages() {
    // io.off('messageDeleted');

    io.on('messageDeleted', (data) {
      try {
        final messageId = data['messageId'] as String?;
        final deleteForEveryone = data['deleteForEveryone'] as bool? ?? false;

        if (messageId == null) {
          return;
        }

        final messageIndex = _messages.indexWhere((m) => m.id == messageId);

        if (messageIndex != -1) {
          if (deleteForEveryone) {
            setState(() {
              _messages[messageIndex].isDeleted = true;
              _messages[messageIndex].content = 'Ce message a été supprimé';
            });
          } else {
            setState(() {
              _messages[messageIndex].isDeleted = true;
            });
          }
        } else {}
      } catch (e) {
        MyLogger().log('Error parsing message deletion: $e');
      }
    });
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: isDark ? Colors.white24 : Colors.black26,
          ),
          const SizedBox(height: 12),
          Text(
            'Aucun message pour le moment',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyLarge?.color?.withAlpha(200),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Commencez la conversation',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  fetchMessages() async {
    // final _localDb = GetIt.I<LocalDBService>();
    //  final _lo = _localDb.getUserId;

    final conversationId = widget.conversationId;
    final response = await _conversationImplements.fetchOneConversation(
      conversationId,
    );
    response.fold((e) => MyLogger().log(e.toString(), type: LogType.error), (
      raw,
    ) {
      final datas = (raw['messages'] as List)
          .map((msgJson) => MessageEntity.fromJson(msgJson))
          .toList();
      final participantDatas = ParticipantPreview.fromJson(raw['participant']);

      setState(() {
        setState(() {
          participantPreview = participantDatas;
          _messages.clear();
          _messages.addAll(datas);
        });
        _loading = false;
      });
    });

    // Toujours marquer la conversation comme lue pour réinitialiser le compteur
    await _conversationImplements.markConversationAsRead(conversationId);
  }
}
