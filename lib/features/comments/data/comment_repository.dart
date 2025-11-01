import 'package:dartz/dartz.dart';

import '../../../core/utils/types/error_api_type.dart';
import 'comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<Comment>>> fetchCommentsForPost(String postId,int? page, int? limit);
  Future<Either<Failure, Comment>> addComment(String postId, String content, String? parentId);
  Future<Either<Failure, bool>> deleteComment(String commentId);
  Future<Either<Failure, bool>> likeComment(String commentId);
  Future<Either<Failure, List<Comment>>> fetchSubComments(String postId, String parentCommentId, int? page, int? limit);

}