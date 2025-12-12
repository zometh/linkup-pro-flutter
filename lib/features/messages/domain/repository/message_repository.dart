import 'package:dartz/dartz.dart';
import 'package:linkup_pro/features/messages/domain/entity/delete_message.dart';
import 'package:linkup_pro/features/messages/domain/entity/send_message_entity.dart';

import '../../../../core/utils/types/error_api_type.dart';

abstract class MessageRepository {
  Future<Either<Failure, dynamic>> sendMessage(SendMessageEntity message);
  Future<Either<Failure, dynamic>> deleteMessage(
    DeleteMessageEntity deleteMessage,
  );
  Future<Either<Failure, Map<String, dynamic>>> uploadMessageImage(
    String filePath,
  );
}
