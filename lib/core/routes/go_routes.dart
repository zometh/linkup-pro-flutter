import 'package:go_router/go_router.dart';
import 'package:linkup_pro/features/login/presentation/pages/login.dart';
import 'package:linkup_pro/features/auth_checker/auth_checker.dart';
import 'package:linkup_pro/features/posts/presentation/pages/home_page.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_page.dart';
import 'package:linkup_pro/features/splash/pages/splash_screen.dart';

import '../../features/register/presentation/pages/sector_choice.dart';

/*final routes = [
  
];*/
GoRouter router(String initialRoute){
  return GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: '/',
        name: 'auth-checker',
        builder: (context, state) => const AuthCheckerService(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(path: "/sector-choice",
          name: "sector-choice",
          builder: (context, state) => const SectorGridView()
      )
    ],
  );
}
/*final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      name: 'auth-checker',
      builder: (context, state) => const AuthCheckerService(),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(path: "/sector-choice",
      name: "sector-choice",
      builder: (context, state) => const SectorGridView()
    )
  ],
);*/
