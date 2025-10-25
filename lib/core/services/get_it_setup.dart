import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/api/api_client.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/services/localdb.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/features/login/data/auth_repository_implement.dart';
import 'package:linkup_pro/features/posts/domain/repos%20and%20implements/implementations/post_repository_implementaion.dart';
import 'package:linkup_pro/features/register/data/repos/register_repository_implement.dart';

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

}