import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:linkup_pro/features/comments/data/entity/comment_creation_entity.dart';

import '../../../core/utils/types/error_api_type.dart';
import 'entity/comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<Comment>>> fetchCommentsForPost(String postId,int? page, int? limit);
  Future<Either<Failure, Comment>> addComment(CommentCreationEntity comment);
  Future<Either<Failure, bool>> deleteComment(String commentId);
  Future<Either<Failure, bool>> likeComment(String commentId);
  Future<Either<Failure, List<Comment>>> fetchSubComments(String postId, String parentCommentId, int? page, int? limit);

}