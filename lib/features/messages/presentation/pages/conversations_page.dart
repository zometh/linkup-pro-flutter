import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/features/messages/presentation/pages/full_conversation_page.dart';
import 'package:linkup_pro/features/messages/presentation/widgets/chat_app_bar.dart';
import 'package:linkup_pro/features/messages/presentation/widgets/conversation_tile.dart';

import '../../domain/repos_implementation/conversation_repository_implement.dart';
import '../../domain/entity/conversation.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<Conversation> data = [];
  List<Conversation> filtered = [];
  @override
  void initState() {
    super.initState();
    fetchConversations();

    filtered = [];
    _searchCtrl.addListener(_onSearch);
  }

  final List<String> filters = ["Tous", "Lus", "Non lus"];

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        filtered = List.from(data);
      } else {
        filtered = data
            .where((d) => d.title.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  void _deleteConversation(String id) {
    final removed = data.firstWhere((d) => d.id == id);
    setState(() {
      data.removeWhere((d) => d.id == id);
      filtered.removeWhere((d) => d.id == id);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conversation supprimée'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            setState(() {
              data.insert(0, removed);
              filtered = List.from(data);
            });
          },
        ),
      ),
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
            ChatAppBar(),
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

  fetchConversations() async {
    try{
      final conversationImplements = GetIt.I<ConversationRepositoryImplement>();
      final response = await conversationImplements.fetchConversations();
      response.fold((e) => MyLogger().log(e.toString(), type: LogType.error), (raw) {

        try {

          setState((){

            filtered = List.from(raw);
          });
        } catch (e) {
          MyLogger().log('Parsing conv list failed: $e', type: LogType.error);
        }
      });
    }catch(e){
      MyLogger().log(e.toString(), type: LogType.error);
    }
  }
}

