import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entity/conversation.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/repos_implementation/conversation_repository_implement.dart';
part "conversations.g.dart";

@Riverpod(keepAlive: true)
class Conversations extends _$Conversations {
  final _conversationImplements = GetIt.I<ConversationRepositoryImplement>();
  @override
  bool build() => false;
  Future<List<Conversation>> fetchConversations() async {
    Future.microtask(() => state = true);
    try{
      final result = await _conversationImplements.fetchConversations();
      final data = result.fold((failure) => <Conversation>[], (conversations) => conversations);
      return data;

    }catch(e){
      return <Conversation>[];
    }finally{
      Future.microtask(() => state = false);
    }

  }
  Future<List<MessageEntity>> fetchOneConversation(String id) async {
    try{
      final result = await _conversationImplements.fetchOneConversation(id);
      final data = result.fold((failure) => <MessageEntity>[], (conversations) => conversations);
      return data;

    }catch(e){
      return <MessageEntity>[];
    }finally{
      Future.microtask(() => state = false);
    }
  }
}