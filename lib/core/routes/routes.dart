import 'package:go_router/go_router.dart';
import 'package:linkup_pro/features/auth/presentation/pages/login.dart';
import 'package:linkup_pro/features/splash/pages/splash_screen.dart';

/*final routes = [
  
];*/
final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
