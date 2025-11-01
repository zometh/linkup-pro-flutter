import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/comments/data/comment_repository_implement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/comment.dart';

part 'fetch_post_comments.g.dart';

@Riverpod(keepAlive: true)
class FetchPostComments extends _$FetchPostComments {
  CommentRepositoryImplement get commentImplement => GetIt.I<CommentRepositoryImplement>();

  @override
  bool build() => false;

  Future<List<Comment>> fetchPostComments(String postId, int page, int limit) async {
    Future.microtask(() => state = true);
    try {
      final result = await commentImplement.fetchCommentsForPost(
          postId, page, limit);
      final data =  result.fold((failure) => <Comment>[], (comments) => comments);
      //print(data.length);
      return data;
    } catch (e) {
      // optionally log the error: debugPrint('fetchPostComments error: $e');
      return <Comment>[];
    } finally {
      Future.microtask(() => state = false);
    }
  }
}