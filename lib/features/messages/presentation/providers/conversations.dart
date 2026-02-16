import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entity/conversation.dart';
import '../../domain/repos_implementation/conversation_repository_implement.dart';
part "conversations.g.dart";

@Riverpod(keepAlive: true)
class Conversations extends _$Conversations {
  final _conversationImplements = GetIt.I<ConversationRepositoryImplement>();
  @override
  bool build() => false;
  Future<List<Conversation>> fetchConversations() async {
    Future.microtask(() => state = true);
    try {
      final result = await _conversationImplements.fetchConversations();
      final data = result.fold(
        (failure) => <Conversation>[],
        (conversations) => conversations,
      );
      return data;
    } catch (e) {
      return <Conversation>[];
    } finally {
      Future.microtask(() => state = false);
    }
  }

  Future<Map<String, dynamic>> fetchOneConversation(String id) async {
    try {
      final result = await _conversationImplements.fetchOneConversation(id);
      final data = result.fold(
        (failure) => <String, dynamic>{},
        (conversations) => conversations,
      );
      return data;
    } catch (e) {
      return <String, dynamic>{};
    } finally {
      Future.microtask(() => state = false);
    }
  }

  Future<bool> markConversationAsRead(String conversationId) async {
    try {
      final result = await _conversationImplements.markConversationAsRead(
        conversationId,
      );
      final data = result.fold((failure) => false, (res) => true);
      return data;
    } catch (e) {
      return false;
    } finally {
      Future.microtask(() => state = false);
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsersFriends() async {
    try {
      final result = await _conversationImplements.fetchUsersFriends();
      final data = result.fold(
        (failure) => <Map<String, dynamic>>[],
        (friends) => friends,
      );
      return data;
    } catch (e) {
      return <Map<String, dynamic>>[];
    } finally {
      Future.microtask(() => state = false);
    }
  }

  Future<Either<Failure, String>> create(String userId) async {
    try {
      final result = await _conversationImplements.createConversation(userId);
      return result;
    } catch (e) {
      return Left(Failure(e.toString()));
    } finally {
      Future.microtask(() => state = false);
    }
  }
}
