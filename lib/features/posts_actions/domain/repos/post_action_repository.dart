import 'package:dartz/dartz.dart';
import 'package:linkup_pro/features/posts_actions/domain/entities/post_action_entity.dart';

import '../../../../core/utils/types/error_api_type.dart';

abstract class PostActionRepository {
  Future<Either<Failure, Map<String, dynamic>>> createPost(
    PostCreationEntity post,
  );
  Future<Either<Failure, Map<String, dynamic>>> deletePost(String postId);
  Future<Either<Failure, Map<String, dynamic>>> updatePost(
    PostCreationEntity post,
    List<String> filesToRemove,
    String id,
  );
}
