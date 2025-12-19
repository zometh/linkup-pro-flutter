import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/features/auth/presentation/providers/auth_provider.dart';
import 'package:linkup_pro/features/login/presentation/pages/login.dart';
import 'package:linkup_pro/features/auth_checker/auth_checker.dart';
import 'package:linkup_pro/features/home_page/presentation/pages/home_page.dart';
import 'package:linkup_pro/features/messages/presentation/pages/full_conversation_page.dart';
import 'package:linkup_pro/features/posts_actions/presentation/pages/post_action_page.dart';
import 'package:linkup_pro/features/profile/presentation/pages/profile_home.dart';
import 'package:linkup_pro/features/register/data/entities/sector.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_company.dart';
import 'package:linkup_pro/features/register/presentation/pages/register_page.dart';
 import 'package:linkup_pro/features/settings/presentation/pages/settings_page.dart';
import 'package:linkup_pro/features/splash/pages/splash_screen.dart';

import '../../features/posts/presentation/pages/post_details_page.dart';
import '../../features/register/presentation/pages/sector_choice.dart';

GoRouter router(
  AuthProvider authProvider,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return GoRouter(
    navigatorKey: navigatorKey,
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
      GoRoute(
        path: "/post/:id",
        name: "post-detail",
        builder: (context, state) {
          final postId = state.pathParameters['id']!;

          return PostDetailsPage(postId: postId);
        },
      ),
      GoRoute(
        path: "/user/:id",
        name: "user-profile",
        builder: (context, state) {
          final userId = state.pathParameters['id']!;

          return ProfileHome(userId: userId, isOwnProfile: false);
        },
      ),

      GoRoute(
        path: "/conversations/:id",
        name: "conversation-view",
        builder: (context, state) {
          final conversationId = state.pathParameters['id']!;

          return FullConversationPage(conversationId: conversationId);
        },
      ),

      GoRoute(
        path: "/post/new",
        name: "create-post",
        builder: (context, state) => const PostActionPage(),
      ),
      GoRoute(
        path: "/settings",
        name: "settings",
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authProvider.isLoggedIn;
      final String location = state.matchedLocation;

      // Routes publiques (accessibles sans connexion)
      final bool isPublicRoute = location == '/' ||
          location == '/login' ||
          location == '/splash' ||
          location == '/register' ||
          location == '/register-company' ||
          location == '/sector-choice';

      // Si non connecté et essaie d'accéder à une route protégée
      if (!loggedIn && !isPublicRoute) {
        return '/';
      }

      // Si connecté et essaie d'accéder à une route d'authentification
      if (loggedIn && (location == '/login' || location == '/register' ||
          location == '/register-company' || location == '/')) {
        return '/home';
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 100,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 24),
                Text(
                  'Page non trouvée',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  state.matchedLocation,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.home),
                  label: const Text('Retour à l\'accueil'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
