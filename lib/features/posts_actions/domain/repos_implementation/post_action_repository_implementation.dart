import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:linkup_pro/core/utils/types/error_api_type.dart';

import 'package:linkup_pro/features/posts_actions/domain/entities/post_action_entity.dart';

import '../../../../core/network/api/api_client.dart';
import '../repos/post_action_repository.dart';

class PostActionRepositoryImplementation implements PostActionRepository {
  final _apiClient = GetIt.I<ApiClient>();

  @override
  Future<Either<Failure, Map<String, dynamic>>> createPost(PostCreationEntity post) async{
    try{
      final formData = FormData.fromMap(post.toMap());
      final response = await _apiClient.post("/posts", data: formData);

      return Right(response);
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deletePost(String postId) async{
    try{
      final response = await _apiClient.delete("/posts/$postId");
      return Right(response);
    }catch(e){
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePost(PostCreationEntity post, List<String> filesToRemove, String id) async{
   try{
      final formData = FormData.fromMap({
        ...post.toMap(),
        'filesToRemove[]': filesToRemove,
      });
      final response = await _apiClient.put("/posts/$id", formData);
      return Right(response);
    }catch(e){
      return Left(Failure(e.toString()));
   }
  }
  // Implementation details would go here
}