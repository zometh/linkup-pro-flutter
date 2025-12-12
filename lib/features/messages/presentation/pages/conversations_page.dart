import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/features/bottom_nav_bar/providers/unread_conversations_provider.dart';
import 'package:linkup_pro/features/messages/presentation/widgets/chat_app_bar.dart';
import 'package:linkup_pro/features/messages/presentation/widgets/conversation_tile.dart';

import '../../domain/repos_implementation/conversation_repository_implement.dart';
import '../../domain/entity/conversation.dart';
import '../../domain/entity/conversation_sender.dart';

class ConversationsPage extends ConsumerStatefulWidget {
  const ConversationsPage({super.key});

  @override
  ConsumerState<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends ConsumerState<ConversationsPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Conversation> data = [];
  List<Conversation> filtered = [];
  final io = GetIt.I<SocketService>();
  String? currentUserId;
  int selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    fetchConversations();

    setupRealtimeListeners();

    filtered = [];
    _searchCtrl.addListener(_onSearch);
  }

  final List<String> filters = ["Tous", "Lus", "Non lus"];

  Future<void> _loadUserId() async {
    final localDb = GetIt.I<LocalDBService>();
    final userId = await localDb.getUserId();
    setState(() {
      currentUserId = userId;
    });
  }

  void _updateUnreadCount() {
    final unreadCount = data.where((conv) => conv.unreadCount > 0).length;
    ref
        .read(unreadConversationsCountProvider.notifier)
        .updateCount(unreadCount);
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        filtered = _applyFilter(List.from(data));
      } else {
        final searchFiltered = data
            .where((d) => d.title.toLowerCase().contains(q))
            .toList();
        filtered = _applyFilter(searchFiltered);
      }
    });
  }

  List<Conversation> _applyFilter(List<Conversation> conversations) {
    switch (selectedFilterIndex) {
      case 0:
        return conversations;
      case 1:
        return conversations.where((c) => c.unreadCount == 0).toList();
      case 2:
        return conversations.where((c) => c.unreadCount > 0).toList();
      default:
        return conversations;
    }
  }

  void _onFilterChanged(int index) {
    setState(() {
      selectedFilterIndex = index;
      _onSearch();
    });
  }

  void _deleteConversation(String id) async {
    final conversationImplements = GetIt.I<ConversationRepositoryImplement>();

    final removed = data.firstWhere((d) => d.id == id);
    final removedIndex = data.indexWhere((d) => d.id == id);

    setState(() {
      data.removeAt(removedIndex);
      _onSearch();
    });
    _updateUnreadCount();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conversation supprimée'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            Future.microtask(() {
              setState(() {
                data.insert(removedIndex, removed);
                _onSearch();
              });
              _updateUnreadCount();
            });
          },
        ),
      ),
    );

    final result = await conversationImplements.deleteConversation(id);
    result.fold(
      (error) {
        setState(() {
          data.insert(removedIndex, removed);
          _onSearch();
        });
        _updateUnreadCount();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: ${error.message}')));
      },
      (_) {
        MyLogger().log('Conversation deleted successfully: $id');
      },
    );
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = filtered;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchConversations();
        },
        child: CustomScrollView(
          slivers: [
            ChatAppBar(
              selectedFilterIndex: selectedFilterIndex,
              onFilterChanged: _onFilterChanged,
              searchController: _searchCtrl,
            ),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 56,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'no_conversations_found'.tr(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList.separated(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ConversationTile(
                    conversation: item,
                    onDismissed: (dir) => _deleteConversation(item.id),
                    id: item.id,
                  );
                },
                separatorBuilder: (_, index) => Builder(
                  builder: (context) {
                    final hairline =
                        1 / MediaQuery.of(context).devicePixelRatio;
                    return SizedBox(
                      height: hairline,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withAlpha(80),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }

  setupListeners(List<Conversation> conversations) {
    for (final cv in conversations) {
      io.joinRoom("conversationSubscribe", {"conversationId": cv.id});
    }
  }

  fetchConversations() async {
    try {
      final conversationImplements = GetIt.I<ConversationRepositoryImplement>();
      final response = await conversationImplements.fetchConversations();
      response.fold((e) => MyLogger().log(e.toString(), type: LogType.error), (
        raw,
      ) {
        setupListeners(raw);
        try {
          Future.microtask(() {
            setState(() {
              data = raw;
              filtered = raw;
            });
            _updateUnreadCount();
          });
        } catch (e) {
          MyLogger().log('Parsing conv list failed: $e', type: LogType.error);
        }
      });
    } catch (e) {
      MyLogger().log(e.toString(), type: LogType.error);
    }
  }

  void setupRealtimeListeners() {
    io.on('newConversation', (conversationData) {
      MyLogger().log('New conversation received: $conversationData');
      _handleNewConversation(conversationData);
    });

    io.on('conversationDeleted', (data) {
      MyLogger().log('Conversation deleted: $data');
      _handleDeletedConversation(data);
    });

    io.on('newMessage', (messageData) {
      MyLogger().log(
        'New message received in conversations list: $messageData',
      );
      _handleNewMessage(messageData);
    });

    io.on('messageDeleted', (deleteData) {
      MyLogger().log('Message deleted in conversations list: $deleteData');
      _handleDeletedMessage(deleteData);
    });

    io.on('conversationRead', (data) {
      MyLogger().log('Conversation marked as read: $data');
      _handleConversationRead(data);
    });
    io.on('conversationLastMessage', (data) {
      _handleConversationLastMessage(data);
    });
  }

  void _handleNewMessage(dynamic messageData) {
    try {
      final conversationId = messageData['conversationId'] as String?;

      if (conversationId == null) {
        return;
      }

      final conversationIndex = data.indexWhere((c) => c.id == conversationId);

      if (conversationIndex == -1) {
        fetchConversations();
        return;
      }

      final conversation = data[conversationIndex];

      final newLastMessage = ConversationLastMessage(
        id: messageData['id'] as String,
        content: messageData['content'] as String?,
        sentDate: DateTime.parse(messageData['sentDate'] as String),
        sender: ConversationSender.fromJson(
          messageData['sender'] as Map<String, dynamic>,
        ),
      );

      final senderId = messageData['sender']?['id'] as String?;
      final isFromCurrentUser = senderId != null && senderId == currentUserId;

      final updatedConversation = Conversation(
        id: conversation.id,
        image: conversation.image,
        title: conversation.title,
        isGroup: conversation.isGroup,
        createdAt: conversation.createdAt,
        updatedAt: DateTime.now(),
        lastMessageDate: newLastMessage.sentDate,
        lastMessage: newLastMessage,
        unreadCount: isFromCurrentUser
            ? conversation.unreadCount
            : conversation.unreadCount + 1,
      );

      setState(() {
        data[conversationIndex] = updatedConversation;
        data.removeAt(conversationIndex);
        data.insert(0, updatedConversation);
        _onSearch();
      });
      _updateUnreadCount();
    } catch (e) {
      MyLogger().log('Error handling new message in conversations: $e');
    }
  }

  void _handleDeletedMessage(dynamic deleteData) {
    try {
      final messageId = deleteData['messageId'] as String?;
      final deleteForEveryone =
          deleteData['deleteForEveryone'] as bool? ?? false;
      final newLastMessageData = deleteData['newLastMessage'];

      if (messageId == null) return;

      final conversationIndex = data.indexWhere(
        (c) => c.lastMessage?.id == messageId,
      );

      if (conversationIndex == -1) {
        MyLogger().log(' Conversation with last message $messageId not found');
        return;
      }

      final conversation = data[conversationIndex];

      if (deleteForEveryone) {
        ConversationLastMessage? updatedLastMessage;

        if (newLastMessageData != null) {
          updatedLastMessage = ConversationLastMessage(
            id: newLastMessageData['id'] as String,
            content: newLastMessageData['content'] as String?,
            sentDate: DateTime.parse(newLastMessageData['sentDate'] as String),
            sender: ConversationSender.fromJson(
              newLastMessageData['sender'] as Map<String, dynamic>,
            ),
          );
        } else {
          updatedLastMessage = ConversationLastMessage(
            id: conversation.lastMessage!.id,
            content: 'Ce message a été supprimé',
            sentDate: conversation.lastMessage!.sentDate,
            sender: conversation.lastMessage!.sender,
          );
        }

        final updatedConversation = Conversation(
          id: conversation.id,
          image: conversation.image,
          title: conversation.title,
          isGroup: conversation.isGroup,
          createdAt: conversation.createdAt,
          updatedAt: conversation.updatedAt,
          lastMessageDate: updatedLastMessage.sentDate,
          lastMessage: updatedLastMessage,
          unreadCount: conversation.unreadCount,
        );

        setState(() {
          data[conversationIndex] = updatedConversation;
          _onSearch();
        });
        _updateUnreadCount();
      }
    } catch (e) {
      MyLogger().log(' Error handling deleted message in conversations: $e');
    }
  }

  void _handleConversationRead(dynamic readData) {
    try {
      final conversationId = readData['conversationId'] as String?;
      if (conversationId == null) return;

      final conversationIndex = data.indexWhere((c) => c.id == conversationId);
      if (conversationIndex == -1) {
        return;
      }

      final conversation = data[conversationIndex];

      final updatedConversation = Conversation(
        id: conversation.id,
        image: conversation.image,
        title: conversation.title,
        isGroup: conversation.isGroup,
        createdAt: conversation.createdAt,
        updatedAt: conversation.updatedAt,
        lastMessageDate: conversation.lastMessageDate,
        lastMessage: conversation.lastMessage,
        unreadCount: 0,
      );

      setState(() {
        data[conversationIndex] = updatedConversation;
        _onSearch();
      });
      _updateUnreadCount();
    } catch (e) {
      MyLogger().log('Error handling conversation read: $e');
    }
  }

  void _handleNewConversation(dynamic conversationData) {
    try {
      final conversation = Conversation.fromJson(conversationData);

      final exists = data.any((c) => c.id == conversation.id);
      if (!exists) {
        io.joinRoom("conversationSubscribe", {
          "conversationId": conversation.id,
        });

        setState(() {
          data.insert(0, conversation);
          _onSearch();
        });
        _updateUnreadCount();
      } else {}
    } catch (e) {
      MyLogger().log('Error handling new conversation: $e');
    }
  }

  void _handleDeletedConversation(dynamic data) {
    try {
      final conversationId = data['conversationId'] as String?;
      if (conversationId == null) return;

      final conversationIndex = this.data.indexWhere(
        (c) => c.id == conversationId,
      );
      if (conversationIndex != -1) {
        setState(() {
          this.data.removeAt(conversationIndex);
          _onSearch();
        });
        _updateUnreadCount();
      }
    } catch (e) {
      MyLogger().log('Error handling deleted conversation: $e');
    }
  }

  void _handleConversationLastMessage(Map<String, dynamic>? data) {
    if (data == null) return;
    final conversationId = data['conversationId'] as String?;
    final messageData = data['message'];

    if (messageData == null) {
      final conversationIndex = this.data.indexWhere(
        (c) => c.id == conversationId,
      );
      if (conversationIndex != -1) {
        setState(() {
          this.data[conversationIndex].lastMessage = null;
          _onSearch();
        });
      }
      return;
    }

    final lastMessage = ConversationLastMessage.fromJson(messageData);

    final conversationIndex = this.data.indexWhere(
      (c) => c.id == conversationId,
    );
    if (conversationIndex != -1) {
      final conversation = this.data[conversationIndex];
      final isFromCurrentUser = lastMessage.sender.id == currentUserId;

      final updatedConversation = Conversation(
        id: conversation.id,
        image: conversation.image,
        title: conversation.title,
        isGroup: conversation.isGroup,
        createdAt: conversation.createdAt,
        updatedAt: DateTime.now(),
        lastMessageDate: lastMessage.sentDate,
        lastMessage: lastMessage,
        unreadCount: isFromCurrentUser
            ? conversation.unreadCount
            : conversation.unreadCount + 1,
      );

      setState(() {
        this.data.removeAt(conversationIndex);
        this.data.insert(0, updatedConversation);
        _onSearch();
      });
      _updateUnreadCount();
    }
  }
}
