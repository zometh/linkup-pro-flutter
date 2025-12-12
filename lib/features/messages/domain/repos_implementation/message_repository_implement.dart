import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/types/error_api_type.dart';
import 'package:linkup_pro/features/messages/domain/entity/delete_message.dart';
import 'package:linkup_pro/features/messages/domain/entity/send_message_entity.dart';
import 'package:linkup_pro/features/messages/domain/repository/message_repository.dart';

import '../../../../core/network/api/api_client.dart';

class MessageRepositoryImplement implements MessageRepository {
  final _api = GetIt.I<ApiClient>();

  @override
  Future<Either<Failure, dynamic>> sendMessage(
    SendMessageEntity message,
  ) async {
    try {
      final Map<String, dynamic> data = {
        "conversationId": message.conversationId,
        "content": message.content,
      };

      // Ajouter les attachments s'ils existent
      if (message.attachments != null && message.attachments!.isNotEmpty) {
        data["attachments"] = message.attachments;
      }

      final response = await _api.post("/messages/send", data: data);
      return Right(response);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadMessageImage(
    String filePath,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _api.post(
        "/messages/upload-image",
        data: formData,
      );

      return Right(response);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteMessage(
    DeleteMessageEntity deleteMessage,
  ) async {
    final data = deleteMessage.toJson();
    try {
      final response = _api.delete(
        "/messages/${deleteMessage.messageId}",
        queryParams: data,
      );
      return Right(response);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
