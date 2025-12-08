import 'package:dartz/dartz.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/domain/entities/user_preview_adds.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts(int? page, int? limit, bool isMyPosts);
  Future<Either<Failure, Post>> getPostById(String id);
  Future<Either<Failure, List<Post>>> getPostsByUserId(String userId, int? page, int? limit);
  Future<Either<Failure, UserPreviewAdds>> getUserPreview(String userId);
}
