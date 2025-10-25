import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/domain/repos%20and%20implements/repos/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final _apiClient = GetIt.I<ApiClient>();

  @override
  Future<Either<Failure, bool>> createPost(Post post) async {
    // TODO: implement createPost
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deletePost(String id) async {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Post>> getPostById(String id) async {
    // TODO: implement getPostById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts(int? page, int? limit) async {
    try {
      final response = await _apiClient.get(
        '/posts',
        queryParams: {'page': page, 'limit': limit},
      );
      //  print(response);
      final posts = response.map((postJson) {
        //print(postJson);
        return Post.fromJson(postJson);
      }).toList();

      return Right(posts);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPostsByUserId(
    String userId,
    int? page,
    int? limit,
  ) async {
    // TODO: implement getPostsByUserId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updatePost(Post post) async {
    // TODO: implement updatePost
    throw UnimplementedError();
  }
}
