import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/comment_repository_implement.dart';

part 'create_comment.g.dart';
@Riverpod(keepAlive: true)
class CreateComment extends _$CreateComment {
  CommentRepositoryImplement get commentImplement =>
      GetIt.I<CommentRepositoryImplement>();

  @override
  bool build() => false;

  Future<dynamic> createComment(String postId, String content, String? parentId) async {
    state = true;
    try {
      final result = await commentImplement.addComment(postId, content, parentId);
      return result.fold(
              (falilure) => null,
              (comment) => comment
      );
    } catch (e) {
      return null;
    } finally {
      state = false;
    }
  }
}