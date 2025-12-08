import 'dart:io';

import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entity/conversation.dart';
import '../../domain/repos_implementation/conversation_repository_implement.dart';
import '../../domain/entity/message_entity.dart';
import '../../../../core/services/localdb/localdb.dart';

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
  bool _loading = true;
  String? _currentUserId;

  static const double _inputBarHeight = 70.0;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
    fetchMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 80), () {
        if (!mounted) return;
        _scrollToBottom();
      });
    });
  }

  Future<void> _loadCurrentUserId() async {
    try {
      final db = GetIt.I<LocalDBService>();
      final id = await db.getUserId();
      if (!mounted) return;
      setState(() => _currentUserId = id);
    } catch (_) {
      // ignore
    }
  }

  void _send() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.insert(
        0,
        MessageEntity(
          content: text,
          sentDate: DateTime.now(),
          id: DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      );
      _textCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 200), () => _scrollToBottom());
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

  String _formatTime(DateTime? ts) {
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

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
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
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14).copyWith(bottom: _inputBarHeight + MediaQuery.of(context).viewPadding.bottom + MediaQuery.of(context).viewInsets.bottom + 24),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final m = _messages[index];
                            final String? senderId = m.sender?.id;
                            // treat as 'me' only when senderId matches current user
                            final me = senderId != null && _isCurrentUser(senderId);
                            final bool hasText = (m.content?.trim().isNotEmpty ?? false);

                            // if attachments contains an image url, show image bubble
                            String? imageUrl;
                            if (m.attachments != null && m.attachments!.isNotEmpty) {
                              final first = m.attachments!.first;
                              if (first is String && first.isNotEmpty) imageUrl = first;
                              if (first is Map && first['url'] != null) imageUrl = first['url'].toString();
                            }

                            // sender (me) bubble
                            if (me) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // add right padding so tail is visible inside screen
                                        Padding(
                                          padding: const EdgeInsets.only(right: 12.0),
                                          child: (imageUrl != null && imageUrl.isNotEmpty)
                                              ? ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildImageWidget(imageUrl, isAsset: _isAssetPath(imageUrl)))
                                              : (hasText
                                                  ? ConstrainedBox(
                                                      constraints: BoxConstraints(minWidth: 90, maxWidth: MediaQuery.of(context).size.width * 0.78),
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                                        child: BubbleSpecialOne(
                                                          text: m.content ?? '',
                                                          isSender: true,
                                                          color: AppColors.primary,
                                                          tail: true,
                                                          textStyle: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      constraints: BoxConstraints(minWidth: 64, maxWidth: MediaQuery.of(context).size.width * 0.3, minHeight: 36),
                                                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                                                    )),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _formatTime(m.sentDate),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160),
                                                fontSize: 11,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            // other user's bubble
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // avatar with initials fallback
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: _avatarForMessage(m) == null ? (isDark ? Colors.grey[700] : AppColors.primary) : Colors.transparent,
                                    backgroundImage: _avatarForMessage(m),
                                    child: _avatarForMessage(m) == null ? Text(_avatarInitials(m), style: const TextStyle(fontSize: 11, color: Colors.white)) : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (imageUrl != null && imageUrl.isNotEmpty)
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: _buildImageWidget(imageUrl, isAsset: _isAssetPath(imageUrl)),
                                            )
                                          else if (hasText)
                                            ConstrainedBox(
                                              constraints: BoxConstraints(minWidth: 90, maxWidth: MediaQuery.of(context).size.width * 0.72),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                child: BubbleSpecialOne(
                                                  text: m.content ?? '',
                                                  isSender: false,
                                                  color: isDark ? Colors.grey[700]! : Theme.of(context).cardColor,
                                                  tail: true,
                                                  textStyle: TextStyle(
                                                    color: isDark ? Colors.white70 : Theme.of(context).textTheme.bodyLarge?.color,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            )
                                          else
                                            Container(
                                              constraints: BoxConstraints(minWidth: 64, maxWidth: MediaQuery.of(context).size.width * 0.3, minHeight: 36),
                                              decoration: BoxDecoration(
                                                color: isDark ? Colors.grey[800] : Colors.grey[200],
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          const SizedBox(height: 6),
                                          Text(
                                            _formatTime(m.sentDate),
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(160),
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Color.fromRGBO(128, 128, 128, 0.18)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textCtrl,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Écrire un message...',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      IconButton(
                        onPressed: () async => await _pickImage(),
                        icon: Icon(Icons.attach_file, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _send,
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withAlpha((0.85 * 255).round()),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: isDark ? Colors.white24 : Colors.black26),
          const SizedBox(height: 12),
          Text('Aucun message pour le moment', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withAlpha(200))),
          const SizedBox(height: 6),
          Text('Commencez la conversation', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1600, imageQuality: 80);
      if (picked == null) return;
      final path = picked.path;
      setState(() {
        _messages.insert(
          0,
          MessageEntity(
            content: null,
            sentDate: DateTime.now(),
            attachments: [path],
            id: DateTime.now().millisecondsSinceEpoch.toString(),
          ),
        );
      });
      Future.delayed(
        const Duration(milliseconds: 200),
        () => _scrollToBottom(),
      );
    } catch (e) {
      // ignore errors from picker
    }
  }

  fetchMessages() async{
    final _conversationImplements = GetIt.I<ConversationRepositoryImplement>();
    final conversationId = widget.conversationId;
    final response = await _conversationImplements.fetchOneConversation(conversationId);
    response.fold((e) => print(e.toString()), (dynamic raw) {
      setState(() {
        _messages.clear();
        try {
          final dynamic rr = raw;
          if (rr is Map) {
            final msgs = rr['messages'] ?? ((rr['data'] is Map) ? rr['data']['messages'] : null);
            if (msgs is List) {
              final list = List<dynamic>.from(msgs);
              for (final m in list) {
                if (m is MessageEntity) _messages.add(m);
                else if (m is Map) _messages.add(MessageEntity.fromJson(Map<String, dynamic>.from(m)));
                else _messages.add(MessageEntity(content: m?.toString(), id: null));
              }
            }
          } else if (rr is Conversation) {
            final dynamic msgs = (rr as dynamic).messages;
            if (msgs is List) {
              final list = List<dynamic>.from(msgs);
              for (final m in list) {
                if (m is MessageEntity) _messages.add(m);
                else if (m is Map) _messages.add(MessageEntity.fromJson(Map<String, dynamic>.from(m)));
                else _messages.add(MessageEntity(content: m?.toString(), id: null));
              }
            }
          } else if (rr is List) {
            final list = List<dynamic>.from(rr);
            for (final m in list) {
              if (m is MessageEntity) _messages.add(m);
              else if (m is Map) _messages.add(MessageEntity.fromJson(Map<String, dynamic>.from(m)));
              else _messages.add(MessageEntity(content: m?.toString(), id: null));
            }
          }
        } catch (e) {
          print('Error parsing messages: $e');
        }
        _loading = false;
      });
    });
  }

  ImageProvider? _avatarForMessage(MessageEntity m) {
    final url = m.sender?.profile?.photo;
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return NetworkImage(url);
    if (url.startsWith('assets/')) return AssetImage(url) as ImageProvider;
    // local file path
    if (url.startsWith('file://') || url.startsWith('/')) {
      try {
        final path = url.startsWith('file://') ? url.replaceFirst('file://', '') : url;
        return FileImage(File(path));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  String _avatarInitials(MessageEntity m) {
    final sender = m.sender;
    if (sender == null) return '';
    final name = sender.displayName.isNotEmpty
        ? sender.displayName
        : ((sender.firstName.isNotEmpty || sender.lastName.isNotEmpty)
            ? '${sender.firstName} ${sender.lastName}'.trim()
            : (sender.username.isNotEmpty ? sender.username : ''));
    if (name.isEmpty) return '';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  bool _isCurrentUser(String userId) {
    if (_currentUserId == null) return false;
    return userId == _currentUserId;
  }

  bool _isAssetPath(String p) {
    if (p.startsWith('http')) return false;
    if (p.startsWith('file://') || p.startsWith('/')) return false; // treat file separately
    // assume non-http are asset if they start with 'assets/'
    return p.startsWith('assets/');
  }

  Widget _buildImageWidget(String url, {required bool isAsset}) {
    // constrain image height so bubble is visible and not just tail
    final double maxH = 220;
    if (isAsset) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        height: maxH,
        width: double.infinity,
      );
    }
    // local file path
    if (url.startsWith('file://') || url.startsWith('/')) {
      final path = url.startsWith('file://') ? url.replaceFirst('file://', '') : url;
      try {
        return Image.file(
          File(path),
          fit: BoxFit.cover,
          height: maxH,
          width: double.infinity,
          errorBuilder: (c, e, s) => _imageErrorWidget(),
        );
      } catch (_) {
        return _imageErrorWidget();
      }
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      height: maxH,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) => _imageErrorWidget(),
    );
  }

  Widget _imageErrorWidget() {
    return Container(
      height: 180,
      color: Colors.grey.shade800,
      alignment: Alignment.center,
      child: Icon(Icons.broken_image, color: Colors.white30, size: 36),
    );
  }
}
