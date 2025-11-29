import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_post.g.dart';

@Riverpod()
class LikePost extends _$LikePost {
  @override
  void build() {}
  final apiClient = GetIt.I<ApiClient>();

  Future<void> likePost(String id) async {
    try {
      await apiClient.post('/posts/like/$id', data: {});
    } catch (e) {
      MyLogger().log(e.toString(), type: LogType.error);
    }
  }
}
