import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/services/localdb.dart';

import '../../network/api_client.dart';

void setup() {
  final getIt = GetIt.I;

  // Example: getIt.registerSingleton<YourService>(YourServiceImplementation());
  getIt.registerLazySingleton(() => LocalDBService());
  getIt.registerLazySingleton(() => ApiClient());
}
