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
      final response = await apiClient.get("/comments/post/$postId", queryParams: {'page': page, 'limit': limit});
      final comments = response.map<Comment>((commentJson) {
        return Comment.fromJson(commentJson);
      }).toList();
      return Right(comments);
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment(String postId, String content, String? parentId) async{
    try{
      final response = await apiClient.post("/comments/post/$postId", data: {'content': content, 'parentId': parentId});
      //print(response);
      final comment = Comment.fromJson(response);
      return Right(comment);
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteComment(String commentId) async{
    try{
      return await apiClient.delete("/comments/$commentId").then((_) => Right(true));
    }
    catch(e){
      return Future.value(Left(Failure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> likeComment(String commentId) async{
    try{
      return await apiClient.post("/comments/$commentId/like", data: {}).then((_) => Right(true));
    }
    catch(e){
      return Future.value(Left(Failure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> fetchSubComments(String postId, String parentCommentId, int? page, int? limit)async {
    try{
      return await apiClient.get("/comments/subcomments/$parentCommentId").then((response) {
        final comments = response.map<Comment>((commentJson) {
          return Comment.fromJson(commentJson);
        }).toList();
        return Right(comments);
      });
    }catch(e){
      return Future.value(Left(Failure(e.toString())));
    }
  }

}