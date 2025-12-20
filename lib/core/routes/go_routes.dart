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

import 'package:linkup_pro/features/search/presentation/pages/search_home.dart';
import 'package:linkup_pro/features/notifications/presentation/pages/notification_home.dart';
import 'package:linkup_pro/features/offers/presentation/pages/offers_home.dart';
import 'package:linkup_pro/features/comments/presentation/pages/sub_comments_page.dart';
import 'package:linkup_pro/features/comments/data/entity/comment.dart'
    as comment_model;
// import 'package:linkup_pro/features/offers/presentation/pages/job_detail_page.dart'; // retiré: route /job/:id utilise maintenant un builder inline

import '../../features/posts/presentation/pages/post_details_page.dart';
import '../../features/register/presentation/pages/register_profile.dart';
import '../../features/register/presentation/pages/sector_choice.dart';
import '../../features/offers/presentation/pages/job_detail_page.dart';
import 'package:linkup_pro/features/report/presentation/pages/report_page.dart';
import 'package:linkup_pro/features/report/domain/enums/report_content_type.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/image_preview.dart';

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
        builder: (context, state) {
          // The sector can be passed via `state.extra` when navigating from sector choice
          final extra = state.extra;
          Sector sector;
          if (extra is Sector) {
            sector = extra;
          } else {
            sector = Sector(color: "", name: "", icon: "");
          }
          return RegisterCompany(sector: sector);
        },
      ),
      GoRoute(
        path: '/register/profile',
        name: 'register-profile',
        builder: (context, state) {
          final extra = state.extra;
          Sector sector;
          if (extra is Sector) {
            sector = extra;
          } else {
            sector = Sector(color: "", name: "", icon: "");
          }
          return RegisterProfile(sector: sector);
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) {
          final isEntreprise =
              (state.uri.queryParameters['isEntreprise'] ?? 'false') == 'true';

          return RegisterPage(isEntreprise: isEntreprise);
        },
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: "/sector-choice",
        name: "sector-choice",
        builder: (context, state) {
          final isEntreprise =
              (state.uri.queryParameters['isEntreprise'] ?? 'false') == 'true';
          return SectorGridView(isEntreprise: isEntreprise);
        },
      ),
      GoRoute(
        path: "/search",
        name: "search",
        builder: (context, state) => const SearchHome(),
      ),
      GoRoute(
        path: "/notifications",
        name: "notifications",
        builder: (context, state) => const NotificationHome(),
      ),
      GoRoute(
        path: "/offers",
        name: "offers",
        builder: (context, state) => const OffersHome(),
      ),
      // NOTE: /post/new must be defined BEFORE /post/:id to avoid "new" being matched as an :id
      GoRoute(
        path: "/post/new",
        name: "create-post",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isEdit = extra?['isEdit'] as bool? ?? false;
          final postId = extra?['postId'] as String?;
          return PostActionPage(isEdit: isEdit, postId: postId);
        },
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
        path: "/comments/:id/replies",
        name: "comment-replies",
        builder: (context, state) {
          // We expect the Comment instance via state.extra
          final extra = state.extra;
          if (extra is comment_model.Comment) {
            return SubCommentsPage(parentComment: extra);
          }

          // If not provided, show a fallback informative page instead of crashing
          return Scaffold(
            appBar: AppBar(title: const Text('Replies')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Commentaire introuvable',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Impossible d\'afficher les réponses car le commentaire n\'a pas été fourni.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => GoRouter.of(context).pop(),
                      child: const Text('Retour'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: "/job/:id",
        name: "job-detail",
        builder: (context, state) {
          final jobId = state.pathParameters['id']!;
          return JobDetailPage(jobId: jobId);
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
        path: '/image-preview',
        name: 'image-preview',
        builder: (context, state) {
          final extra = state.extra;
          final List<String> urls = (extra is List<String>)
              ? extra
              : <String>[];
          return ImagePreview(imageUrls: urls);
        },
      ),
      GoRoute(
        path: "/report",
        name: "report",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final reportType =
              extra?['reportType'] as ReportContentType? ??
              ReportContentType.publication;
          final publicationId = extra?['publicationId'] as String?;
          final commentId = extra?['commentId'] as String?;
          final userId = extra?['userId'] as String?;
          return ReportPage(
            reportType: reportType,
            publicationId: publicationId,
            commentId: commentId,
            userId: userId,
          );
        },
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
      final bool isPublicRoute =
          location == '/' ||
          location == '/login' ||
          location == '/splash' ||
          location == '/register' ||
          location == '/register-company' ||
          location == '/register/profile' ||
          location == '/sector-choice' ||
          location == '/search';

      // Si non connecté et essaie d'accéder à une route protégée
      if (!loggedIn && !isPublicRoute) {
        return '/';
      }

      // Si connecté et essaie d'accéder à une route d'authentification
      if (loggedIn &&
          (location == '/login' ||
              location == '/register' ||
              location == '/register-company' ||
              location == '/')) {
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
