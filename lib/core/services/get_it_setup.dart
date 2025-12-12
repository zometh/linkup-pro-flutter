import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/services/auth_service.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/features/comments/data/comment_repository_implement.dart';
import 'package:linkup_pro/features/login/data/auth_repository_implement.dart';
import 'package:linkup_pro/features/messages/domain/repos_implementation/conversation_repository_implement.dart';
import 'package:linkup_pro/features/messages/domain/repos_implementation/message_repository_implement.dart';
import 'package:linkup_pro/features/posts/domain/repos%20and%20implements/implementations/post_repository_implementaion.dart';
import 'package:linkup_pro/features/register/data/repos/register_repository_implement.dart';
import 'package:linkup_pro/features/report/domain/implementations/report_repository_implement.dart';
import 'package:linkup_pro/features/users/domain/user_repos_implement.dart';

import '../../features/posts_actions/domain/repos_implementation/post_action_repository_implementation.dart';

void setupGetIt() {
  final getIt = GetIt.I;

  // Register your services here
  getIt.registerLazySingleton<LocalDBService>(() => LocalDBService());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<AuthRepositoryImplement>(() => AuthRepositoryImplement());
  getIt.registerLazySingleton<RegisterRepositoryImplement>(() => RegisterRepositoryImplement());
  getIt.registerLazySingleton<MyLogger>(() => MyLogger());
  getIt.registerLazySingleton<SocketService>(() => SocketService());
  getIt.registerLazySingleton<PostRepositoryImpl>(() => PostRepositoryImpl());
  getIt.registerLazySingleton<CommentRepositoryImplement>(() => CommentRepositoryImplement());
  getIt.registerLazySingleton<UsersRepositoryImpl>(() => UsersRepositoryImpl());
  getIt.registerLazySingleton<PostActionRepositoryImplementation>(() => PostActionRepositoryImplementation());
  getIt.registerLazySingleton<ReportRepositoryImplement>(() => ReportRepositoryImplement());
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<ConversationRepositoryImplement>(() => ConversationRepositoryImplement());
  getIt.registerLazySingleton<MessageRepositoryImplement>(() => MessageRepositoryImplement());


}