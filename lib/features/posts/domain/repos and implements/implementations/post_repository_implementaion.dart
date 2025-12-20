import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/domain/entities/user_preview_adds.dart';
import 'package:linkup_pro/features/posts/domain/repos%20and%20implements/repos/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final _apiClient = GetIt.I<ApiClient>();
  final storage = GetIt.I<LocalDBService>();
  @override
  Future<Either<Failure, Post>> getPostById(String id) async {
    try {
      final response = await _apiClient.getOne('/posts/$id');

      final post = Post.fromJson(response);

      return Right(post);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts(
    int? page,
    int? limit,
     String? userId,
  ) async {
    String endPoint = "/posts";
    if (userId != null) {


      // Si un userId est fourni, appeler endpoint user-specific, sinon appeler /posts
      // On utilise le endpoint `/posts` sans userId pour laisser le backend personnaliser
      // la réponse en fonction du token si présent. Cependant, dans certains cas
      // (token non disponible) on permet d'envoyer explicitement `userId` en query
      // pour obtenir des posts ciblés.
      endPoint = "/posts/user/$userId";
    }
    try {
      // TODO: envoyer userId en queryParams as a fallback rather than changing endpoint
      print('[PostRepositoryImpl] calling $endPoint with page=$page limit=$limit userIdPresent=${userId != null}');
      final response = await _apiClient.get(
        endPoint,
        queryParams: {'page': page, 'limit': limit, if (userId != null) 'userId': userId},
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
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserPreviewAdds>> getUserPreview(String userId) async {
    try {
      final response = await _apiClient.getOne('/users/preview/$userId');
      return Right(UserPreviewAdds.fromJson(response));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
