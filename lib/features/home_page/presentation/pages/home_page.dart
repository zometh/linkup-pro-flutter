import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/bottom_nav_bar/providers/bottom_navbar.dart';
import 'package:linkup_pro/features/bottom_nav_bar/widgets/bottom_navbar.dart' as navbar_widget;
import 'package:linkup_pro/features/home_page/presentation/widgets/home_appbar.dart';
import 'package:linkup_pro/features/messages/presentation/pages/messages_home.dart';
import 'package:linkup_pro/features/notifications/presentation/pages/notification_home.dart';
import 'package:linkup_pro/features/posts/presentation/pages/posts_view.dart';
import 'package:linkup_pro/features/profile/presentation/pages/profile_home.dart';
import 'package:linkup_pro/features/search/presentation/pages/search_home.dart';
/*
IconButton(
            onPressed: () {
              ref.read(authProvider).logout();
            },
            icon: const Icon(Icons.logout),
          )
 */
final List<Widget> pages = [
  const PostsView(),
  const SearchHome(),
  const MessagesHome(),
  const NotificationHome(),
  const ProfileHome()

];
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double navBarHeight = MediaQuery.of(context).size.height * 0.095;
    final int currentIndex = ref.watch(bottomNavbarProvider);
    final bool isNavbarVisible = ref.watch(bottomNavbarVisibilityProvider);
    final availableHeight = MediaQuery.of(context).size.height * 0.08;

    return Scaffold(

     /* appBar: isNavbarVisible ? PreferredSize(
        preferredSize: Size.fromHeight(availableHeight),
        child: HomeAppbar(avaibleHeight: availableHeight),
                  )

       : null,*/
      body: Stack(
        children: [
          // Main content avec IndexedStack pour garder l'état des pages
          AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.only(bottom: isNavbarVisible ? navBarHeight : 0),
            child: IndexedStack(
              index: currentIndex,
              children: pages,
            ),
          ),
          // Floating Bottom Navbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: !isNavbarVisible,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                offset: isNavbarVisible ? Offset.zero : const Offset(0, 1),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isNavbarVisible ? 1.0 : 0.0,
                  child: SizedBox(
                    height: navBarHeight,
                    child: const navbar_widget.BottomNavbar(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
