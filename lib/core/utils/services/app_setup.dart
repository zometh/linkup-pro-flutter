import 'package:get_it/get_it.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:linkup_pro/core/utils/services/localdb.dart';
import 'package:linkup_pro/core/utils/services/my_logger.dart';

import '../../../features/login/data/auth_repository_implement.dart';
import '../../network/api_client.dart';

Future<void> setup() async{
  setupGetIt();
  await setupGoogleMlKit();

}
void setupGetIt() {
  final getIt = GetIt.I;

  // Register your services here
  getIt.registerLazySingleton<LocalDBService>(() => LocalDBService());
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<AuthRepositoryImplement>(() => AuthRepositoryImplement());
  getIt.registerLazySingleton<MyLogger>(() => MyLogger());

}
setupGoogleMlKit() async{
  final modelManager = OnDeviceTranslatorModelManager();
  final bool isEnglishModelDownloaded = await modelManager.isModelDownloaded(TranslateLanguage.english.bcpCode);
  final bool isFrenchModelDownloaded = await modelManager.isModelDownloaded(TranslateLanguage.french.bcpCode);
  final bool isArabicModelDownloaded = await modelManager.isModelDownloaded(TranslateLanguage.arabic.bcpCode);
  if (!isEnglishModelDownloaded) {
    await modelManager.downloadModel(TranslateLanguage.english.bcpCode);
  }
  if (!isFrenchModelDownloaded) {
    await modelManager.downloadModel(TranslateLanguage.french.bcpCode);
  }
  if (!isArabicModelDownloaded) {
    await modelManager.downloadModel(TranslateLanguage.arabic.bcpCode);
  }
}