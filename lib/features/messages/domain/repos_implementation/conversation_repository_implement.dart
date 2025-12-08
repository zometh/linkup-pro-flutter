

import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/messages/domain/entity/conversation.dart';
import 'package:linkup_pro/features/messages/domain/entity/message_entity.dart';
import 'package:linkup_pro/features/messages/domain/repository/conversation_repository.dart';

class ConversationRepositoryImplement implements ConversationRepository{
  final _api = GetIt.I<ApiClient>();
  @override
  Future<Either<Failure, List<Conversation>>> fetchConversations() async{
    try{
      final response = await _api.get("/messages/conversations");
      final conversations = response.map<Conversation>((conversationJson) {
        return Conversation.fromJson(conversationJson);
      }).toList();
      return Right(conversations);
    }catch(e){
      return Left(Failure(e.toString()));

    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> fetchOneConversation(String id) async{
    try{
    final response = await _api.get("/messages/conversations");
    final messages = response.map<MessageEntity>((messageJson) {
      return MessageEntity.fromJson(messageJson);
    }).toList();
    return Right(messages);
  }catch(e){
  return Left(Failure(e.toString()));

  }
  }


}