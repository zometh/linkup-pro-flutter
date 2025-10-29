import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/comments/data/comment_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/comment.dart';

part 'fetch_post_comments.g.dart';

@Riverpod()
class FetchPostComments extends _$FetchPostComments {
  CommentRepositoryImplement get commentImplement => GetIt.I<CommentRepositoryImplement>();

  @override
  bool build() => false;

  Future<List<Comment>> fetchPostComments(int postId, int page, int limit) async {
    state = true;
    try {
      final result = await commentImplement.fetchCommentsForPost(
          postId.toString(), page, limit);
      return result.fold((failure) => <Comment>[], (comments) => comments);
    } catch (e) {
      // optionally log the error: debugPrint('fetchPostComments error: $e');
      return <Comment>[];
    } finally {
      state = false;
    }
  }
}