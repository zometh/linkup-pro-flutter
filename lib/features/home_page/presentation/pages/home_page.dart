import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/bottom_nav_bar/providers/bottom_navbar.dart';
import 'package:linkup_pro/features/bottom_nav_bar/widgets/bottom_navbar.dart'
    as navbar_widget;
import 'package:linkup_pro/features/home_page/presentation/widgets/home_appbar.dart';
import 'package:linkup_pro/features/messages/presentation/pages/conversations_page.dart';
import 'package:linkup_pro/features/posts/presentation/pages/posts_view.dart';
import 'package:linkup_pro/features/profile/presentation/pages/profile_home.dart';
import 'package:linkup_pro/features/search/presentation/pages/search_home.dart';
import 'package:linkup_pro/main.dart';

final List<Widget> pages = [
  const PostsView(),
  const SearchHome(),
  const ConversationsPage(),
  const FlutterLogo() /*OffersHome()*/,
  ProfileHome(isOwnProfile: true),
];

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    final bool visible = ref.read(bottomNavbarVisibilityProvider);
    _controller.value = visible ? 1.0 : 0.0;

    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isNavbarVisible = ref.watch(bottomNavbarVisibilityProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (isNavbarVisible && _controller.isDismissed) {
        _controller.forward();
      } else if (!isNavbarVisible && _controller.isCompleted) {
        _controller.reverse();
      }
    });

    final double navBarHeight = MediaQuery.of(context).size.height /* * 0.095*/;
    final int currentIndex = ref.watch(bottomNavbarProvider);
    final availableHeight = MediaQuery.of(context).size.height * 0.05;

    final bool offstage = !isNavbarVisible && _controller.isDismissed;

    return Scaffold(
      extendBody: true,
      appBar: currentIndex == 0
          ? (isNavbarVisible
                ? PreferredSize(
                    preferredSize: Size.fromHeight(availableHeight),
                    child: Offstage(
                      offstage: !isNavbarVisible,
                      child: HomeAppbar(/*avaibleHeight: availableHeight*/),
                    ),
                  )
                : null)
          : null,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: Offstage(
        offstage: offstage,
        child: IgnorePointer(
          ignoring: offstage,
          child: SlideTransition(
            position: _offsetAnimation,
            child: FadeTransition(
              opacity: _controller,
              child: Padding(
                padding: EdgeInsets.only(bottom: 0, left: 1, right: 1),
                child: SizedBox(
                  width: context.screenWidth,
                  height: navBarHeight * 0.09,
                  // width: 300,
                  child: const navbar_widget.BottomNavbar(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
