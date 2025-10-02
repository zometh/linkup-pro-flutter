import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/services/localdb.dart';

void setup() {
  final getIt = GetIt.I;

  // Example: getIt.registerSingleton<YourService>(YourServiceImplementation());
  getIt.registerLazySingleton(() => LocalDBService());
}
