import 'package:dartz/dartz.dart';

import '../../../../core/utils/types/error_api_type.dart';
import '../entity/conversation.dart';

abstract class ConversationRepository {
  Future<Either<Failure, List<Conversation>>> fetchConversations();
  Future<Either<Failure, Map<String, dynamic>>> fetchOneConversation(String id);
  Future<Either<Failure, Map<String, dynamic>>> markConversationAsRead(
    String conversationId,
  );
  Future<Either<Failure, String>> createConversation(String userId);
  Future<Either<Failure, Map<String, dynamic>>> deleteConversation(
    String conversationId,
  );
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchUsersFriends();
}
