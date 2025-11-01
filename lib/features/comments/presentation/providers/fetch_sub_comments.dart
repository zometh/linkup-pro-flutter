import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../data/comment.dart';
import '../../data/comment_repository_implement.dart';

final fetchSubCommentsProvider = Provider.autoDispose<FetchSubCommentsNotifier>(
  (ref) => FetchSubCommentsNotifier(),
);

class FetchSubCommentsNotifier {
  final commentRepository = GetIt.I<CommentRepositoryImplement>();

  Future<List<Comment>> fetchSubComments(
    String postId,
    String parentCommentId,
    int page,
    int limit,
  ) async {
    try {
      final result = await commentRepository.fetchCommentsForPost(
        postId,
        page,
        limit,
      );

      return result.fold(
        (failure) {
          throw Exception(failure.toString());
        },
        (comments) {
          // Filter to get only sub-comments of the parent
          final subComments = comments
              .where((comment) => comment.commentId == parentCommentId)
              .toList();
          return subComments;
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}

