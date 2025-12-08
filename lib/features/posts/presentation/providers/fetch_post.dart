import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/domain/repos%20and%20implements/implementations/post_repository_implementaion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'fetch_post.g.dart';

@Riverpod(keepAlive: true)
class FetchPost extends _$FetchPost {
  final _postImplement = GetIt.I<PostRepositoryImpl>();
  @override
  bool build() {
    return false;
  }

  Future<List<Post>> fetchPosts(int? page, int? limit, bool isMyPosts) async {
    Future.microtask(() => state = true);
    try {
      final result = await _postImplement.getPosts(page, limit, isMyPosts);
      final posts = result.fold(
        (failure) {
          // Handle failure
          return <Post>[];
        },
        (data) {
         
          return data;
        },
      );
      Future.microtask(() => state = false);
      return posts;
    } catch (e) {
      Future.microtask(() => state = false);
      rethrow;
    }
  }
}
