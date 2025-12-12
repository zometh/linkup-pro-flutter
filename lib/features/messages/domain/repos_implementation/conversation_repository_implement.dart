import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/messages/domain/entity/conversation.dart';
import 'package:linkup_pro/features/messages/domain/repository/conversation_repository.dart';

class ConversationRepositoryImplement implements ConversationRepository {
  final _api = GetIt.I<ApiClient>();
  @override
  Future<Either<Failure, List<Conversation>>> fetchConversations() async {
    try {
      final response = await _api.get("/messages/conversations");

      final conversations = response.map<Conversation>((conversationJson) {
        return Conversation.fromJson(conversationJson);
      }).toList();
      return Right(conversations);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchOneConversation(
    String id,
  ) async {
    try {
      final response = await _api.getOne(
        "/messages/conversations/$id/messages",
      );
      /* final messages = response.map<MessageEntity>((messageJson) {
        return MessageEntity.fromJson(messageJson);
      }).toList();*/
      return Right(response);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markConversationAsRead(
    String conversationId,
  ) async {
    //conversations/:conversationId/mark-as-read
    try {
      final response = await _api.put(
        "/messages/conversations/$conversationId/mark-as-read",
        {},
      );
      return Right(response);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createConversation(String userId) async {
    try {
      final response = await _api.post(
        "/messages/conversations",
        data: {
          "participantIds": [userId],
        },
      );
      return Right(response["conversationId"]);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteConversation(
    String conversationId,
  ) async {
    try {
      final response = await _api.delete(
        "/messages/conversations/$conversationId",
      );
      return Right(response);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  fetchUsersFriends() async {
    try {
      final db = GetIt.I<LocalDBService>();
      final userId = await db.getUserId();
      final response = await _api.get("/follow/following-followers/$userId");
      return Right(response);
    } catch (e) {
      MyLogger().log(e.toString(), type: LogType.error);
      return Left(Failure(e.toString()));
    }
  }
}
