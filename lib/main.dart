import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/utils/services/get_it_setup.dart';
import 'package:linkup_pro/features/splash/pages/splash_fisrt.dart';
import 'package:linkup_pro/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await EasyLocalization.ensureInitialized();
  await DotEnv.DotEnv().load(fileName: ".env");
  runApp(
    EasyLocalization(
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
      child: ProviderScope(child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      home: const SplashFisrt(),
      darkTheme: ThemeData.dark(),
      theme: context.isDarkMode ? ThemeData.dark() : ThemeData.light(),
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
  bool get isTablet => MediaQuery.of(this).size.width >= 600 && MediaQuery.of(this).size.width < 1200;
  Orientation get orientation => MediaQuery.of(this).orientation;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  String get languageCode => locale.languageCode;



}

