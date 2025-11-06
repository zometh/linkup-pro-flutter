import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/domain/repos%20and%20implements/implementations/post_repository_implementaion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'fetch_one_post.g.dart';

@Riverpod(keepAlive: true)
class FetchOnePost extends _$FetchOnePost {
  final _postImplement = GetIt.I<PostRepositoryImpl>();
  @override
  bool build() => false;


  Future<Post?> fetchPosts(String id) async {
    Future.microtask(() => state = true);
    try {
      final result = await _postImplement.getPostById(id);
      final post = result.fold(
            (failure) { 
          // Handle failure
          return null;
        },
            (data) {

          return data;
        },
      );
      Future.microtask(() => state = false);
      return post;
    } catch (e) {
      Future.microtask(() => state = false);
      rethrow;
    }
  }
}
