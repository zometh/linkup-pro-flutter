
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:linkup_pro/features/login/presentation/pages/login.dart';
import 'package:linkup_pro/features/auth_checker/auth_checker.dart';
import 'package:linkup_pro/features/home_page/presentation/pages/home_page.dart';
import 'package:linkup_pro/features/posts_actions/presentation/pages/create_post_page.dart';
import 'package:linkup_pro/features/register/data/entities/sector.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_company.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_page.dart';
import 'package:linkup_pro/features/splash/pages/splash_screen.dart';

import '../../features/posts/presentation/pages/post_details_page.dart';
import '../../features/register/presentation/pages/sector_choice.dart';

GoRouter router(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: "/",
    refreshListenable: authProvider,
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
        path: '/register-company',
        name: 'register-company',
        builder: (context, state) => RegisterCompany(
          sector: Sector(color: "", name: "", icon: ""),
        ),
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
      GoRoute(
        path: "/sector-choice",
        name: "sector-choice",
        builder: (context, state) => const SectorGridView(),
      ),
      GoRoute(path: "/post/:id", name: "post-detail", builder: (context, state) {
        final postId = state.pathParameters['id']!;

         return PostDetailsPage(postId: postId);

      }),
      GoRoute(
        path: "/post/new",
        name: "create-post",
        builder: (context, state) => const CreatePostPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authProvider.isLoggedIn;
      final bool isLoggingIn = state.matchedLocation == '/login';
      final bool isRegistering = state.matchedLocation == '/register' ||
          state.matchedLocation == '/register-company' ||
          state.matchedLocation == '/sector-choice';
      final bool isSplashing = state.matchedLocation == '/splash';
      final bool isAuthChecker = state.matchedLocation == '/';

      if (!loggedIn &&
          !isLoggingIn &&
          !isRegistering &&
          !isSplashing &&
          !isAuthChecker) {
        return '/';
      }

      if (loggedIn && (isLoggingIn || isRegistering || isAuthChecker)) {
        return '/home';
      }

      return null;
    },
  );
}
