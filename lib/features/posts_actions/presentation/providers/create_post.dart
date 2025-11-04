import 'package:get_it/get_it.dart';
import 'package:linkup_pro/features/posts_actions/domain/entities/post_action_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repos_implementation/post_action_repository_implementation.dart';
part 'create_post.g.dart';
@Riverpod()
class CreatePostProvider extends _$CreatePostProvider {
  final repos = GetIt.I<PostActionRepositoryImplementation>();

  @override
  bool build() => false;

  Future<dynamic> createPost(PostCreationEntity postData) async {
    Future.microtask(() => state = true);
    try {
      final response = await repos.createPost(postData);
      final result = response.fold(
        (failure) {
          return null;
        },
        (data) {
          return data;
        },
      );
      Future.microtask(() => state = false);
      return result;

    }catch (e) {
      Future.microtask(() => state = false);
      rethrow;
    }
  }
}