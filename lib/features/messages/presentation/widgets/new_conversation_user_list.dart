import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/features/messages/presentation/providers/conversations.dart';
import 'package:linkup_pro/features/messages/presentation/widgets/friends_tile.dart';

class NewConversationUserList extends ConsumerWidget {
  const NewConversationUserList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(conversationsProvider.notifier).fetchUsersFriends(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(child: Text('No friends found.'));
        } else {
          final friends = snapshot.data as List<Map<String, dynamic>>;

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];

              return FriendsTile(
                id: friend['id'] ?? '',
                displayName: friend['displayName'] ?? 'Unknown',
                photoUrl: friend['imageUrl'],
                onTap: () {
                  _createConversation(friend['id'] ?? '', context, ref);
                },
              );
            },
          );
        }
      },
    );
  }

  _createConversation(
    String userId,
    BuildContext context,
    WidgetRef ref,
  ) async {
    final result = await ref
        .read(conversationsProvider.notifier)
        .create(userId);
    result.fold(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${failure.message}')));
      },
      (data) {
        Navigator.pop(context);
        context.push("/conversations/$data");
      },
    );
  }
}
