import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_event_provider.g.dart';

/// Provider pour notifier les événements de posts (création, suppression, mise à jour)
/// afin de synchroniser l'UI en temps réel
@Riverpod(keepAlive: true)
class PostEventNotifier extends _$PostEventNotifier {
  @override
  PostEvent? build() => null;

  /// Notifie qu'un nouveau post a été créé
  void notifyPostCreated(Post post) {
    state = PostEvent(type: PostEventType.created, post: post);
    // Reset après notification
    Future.microtask(() => state = null);
  }

  /// Notifie qu'un post a été supprimé
  void notifyPostDeleted(String postId) {
    state = PostEvent(type: PostEventType.deleted, postId: postId);
    Future.microtask(() => state = null);
  }

  /// Notifie qu'un post a été mis à jour
  void notifyPostUpdated(Post post) {
    state = PostEvent(type: PostEventType.updated, post: post);
    Future.microtask(() => state = null);
  }
}

enum PostEventType { created, deleted, updated }

class PostEvent {
  final PostEventType type;
  final Post? post;
  final String? postId;

  PostEvent({required this.type, this.post, this.postId});
}
