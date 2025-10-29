import 'package:dartz/dartz.dart';

import '../../../core/utils/types/error_api_type.dart';
import 'comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<Comment>>> fetchCommentsForPost(String postId,int? page, int? limit);
}