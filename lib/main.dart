import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/routes/go_routes.dart';
import 'package:linkup_pro/core/services/notification_service.dart';
import 'package:linkup_pro/core/theme/dark_theme.dart';
import 'package:linkup_pro/core/theme/light_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toastification/toastification.dart';

import 'core/services/app_setup.dart';
import 'features/register/data/repos/register_repository_implement.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await setup();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final initial = await getInitialWidget();

  runApp(
    ToastificationWrapper(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('en', 'US'),
          Locale('fr'),
          Locale('fr', 'FR'),
          Locale('ar'),
          Locale('ar', 'DZ'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: ProviderScope(child: MyApp(initialRoute: initial)),
      ),
    ),
  );
}

Future<String> getInitialWidget() async {
  const storage = FlutterSecureStorage();
  String? isRegistrationComplete = await storage.read(
    key: 'isRegistrationComplete',
  );

  if (isRegistrationComplete == 'true') {
    return "/";
  } else {
    final registerRepositoryImplements = GetIt.I<RegisterRepositoryImplement>();
    await registerRepositoryImplements.deleteUser();
    return "/splash";
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      routerConfig: router(initialRoute),
      darkTheme: darkTheme,
      theme: context.isDarkMode ? darkTheme : lightTheme,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
    );
  }
}

extension ContextExtensions on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  bool get isMobile => MediaQuery.of(this).size.width < 600;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= 600 &&
      MediaQuery.of(this).size.width < 1200;
  Orientation get orientation => MediaQuery.of(this).orientation;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  String get languageCode => locale.languageCode;
}
