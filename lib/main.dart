import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/providers/theme_provider.dart';
import 'package:linkup_pro/core/routes/go_routes.dart';
import 'package:linkup_pro/core/services/notification_service.dart';
import 'package:linkup_pro/core/theme/dark_theme.dart';
import 'package:linkup_pro/core/theme/light_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:linkup_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:toastification/toastification.dart';

import 'core/services/app_setup.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await setup();
  await NotificationService.initialize(navigatorKey);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final appLinks = AppLinks();
  final initialLink = await appLinks.getInitialLink();
  await EasyLocalization.ensureInitialized();

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
        child: ProviderScope(
          child: MyApp(appLinks: appLinks, initialLink: initialLink),
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final Uri? initialLink;
  final AppLinks appLinks;

  const MyApp({super.key, required this.initialLink, required this.appLinks});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (mounted) {
          // Use `go` to replace current location for deep links instead of stacking
          GoRouter.of(context).go(uri.path);
        }
      }
    });
    if (widget.initialLink != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Use `go` for initial link navigation
        GoRouter.of(context).go(widget.initialLink!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final routerConfig = router(auth, navigatorKey);
    // Watch the provider state (AppThemeMode) instead of the notifier instance.
    // Watching the notifier (`themeProvider.notifier`) returns the notifier object
    // and won't trigger rebuilds when the state changes. We must watch
    // `themeProvider` to rebuild the app when the theme changes.
    final appThemeMode = ref.watch(themeProvider);
    ThemeMode currentThemeMode;
    switch (appThemeMode) {
      case AppThemeMode.light:
        currentThemeMode = ThemeMode.light;
        break;
      case AppThemeMode.dark:
        currentThemeMode = ThemeMode.dark;
        break;
      case AppThemeMode.system:
        currentThemeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      routerConfig: routerConfig,
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: currentThemeMode,
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
