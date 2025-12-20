import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/bottom_nav_bar/providers/bottom_navbar.dart';
import 'package:linkup_pro/features/bottom_nav_bar/widgets/bottom_navbar.dart'
    as navbar_widget;
import 'package:linkup_pro/features/home_page/presentation/widgets/home_appbar.dart';
import 'package:linkup_pro/main.dart';

import 'package:go_router/go_router.dart';

// Removed pages list as it's now handled by GoRouter branches

class HomePage extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const HomePage({super.key, required this.navigationShell});

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
    final int currentIndex = widget.navigationShell.currentIndex;
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
      body: widget.navigationShell,
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
                  child: navbar_widget.BottomNavbar(
                    currentIndex: currentIndex,
                    onTap: (index) {
                      widget.navigationShell.goBranch(
                        index,
                        initialLocation:
                            index == widget.navigationShell.currentIndex,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
