import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/comments/data/comment.dart';

import '../../../core/network/api/api_client.dart';
import 'comment_repository.dart';

class CommentRepositoryImplement implements CommentRepository {
  final apiClient = GetIt.I<ApiClient>();

  @override
  Future<Either<Failure, List<Comment>>> fetchCommentsForPost(String postId,int? page, int? limit) async{
    try{
      final response = await apiClient.get("/comments/posts/$postId", queryParams: {'page': page, 'limit': limit});
      final comments = response.map<Comment>((commentJson) {
        return Comment.fromJson(commentJson);
      }).toList();
      return Right(comments);
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }

}