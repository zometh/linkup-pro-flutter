import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/features/messages/domain/entity/delete_message.dart';
import 'package:linkup_pro/features/messages/domain/entity/send_message_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repos_implementation/message_repository_implement.dart';
part 'messages.g.dart';

@Riverpod(keepAlive: true)
class Messages extends _$Messages {
  final _messageImplements = GetIt.I<MessageRepositoryImplement>();
  @override
  bool build() => false;
  Future<void> sendMessage(SendMessageEntity message) async {
    Future.microtask(() => state = true);
    try {
      await _messageImplements.sendMessage(message);
    } catch (e) {
      MyLogger().log(e.toString(), type: LogType.error);
    } finally {
      Future.microtask(() => state = false);
    }
  }

  Future<void> deleteMessage(DeleteMessageEntity deleteMessage) async {
    Future.microtask(() => state = true);
    try {
      await _messageImplements.deleteMessage(deleteMessage);
    } catch (e) {
      MyLogger().log(e.toString(), type: LogType.error);
    } finally {
      Future.microtask(() => state = false);
    }
  }
}
