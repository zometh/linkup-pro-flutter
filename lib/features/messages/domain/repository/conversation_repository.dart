
import 'package:dartz/dartz.dart';
import 'package:linkup_pro/features/messages/domain/entity/message_entity.dart';

import '../../../../core/utils/types/error_api_type.dart';
import '../entity/conversation.dart';
abstract class ConversationRepository {
  Future<Either<Failure, List<Conversation>>> fetchConversations();
  Future<Either<Failure, List<MessageEntity>>> fetchOneConversation(String id);

}