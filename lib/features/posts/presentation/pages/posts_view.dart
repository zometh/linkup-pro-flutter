import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/bottom_nav_bar/providers/bottom_navbar.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/presentation/providers/fetch_post.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/no_data_widget.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_card.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_shimmer_loading.dart';
import 'package:linkup_pro/main.dart';
import 'package:shimmer/shimmer.dart';

class PostsView extends ConsumerStatefulWidget {
  const PostsView({super.key});

  @override
  ConsumerState<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends ConsumerState<PostsView> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  int _postsPerPage = 3;
  int _currentPage = 1;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isInitialLoading = false; // used for first load or refresh
  bool isLoadingMore = false; // used when loading additional pages (pagination)
  bool hasMore = true;
  List<Post> posts = [];
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();

    fetchPosts();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentScrollPosition = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    ref.read(bottomNavbarVisibilityProvider.notifier).state = true;
    // Gérer la visibilité du navbar en fonction de la direction du scroll
    if (currentScrollPosition > _lastScrollPosition && currentScrollPosition > 100) {
      // Scroll vers le bas - cacher le navbar
      ref.read(bottomNavbarVisibilityProvider.notifier).state = false;
    } else if (currentScrollPosition < _lastScrollPosition) {
      // Scroll vers le haut - afficher le navbar
      ref.read(bottomNavbarVisibilityProvider.notifier).state = true;
    }

    // Load more posts when near the bottom
    if (currentScrollPosition >= maxScrollExtent - 350 &&
        !isInitialLoading &&
        !isLoadingMore &&
        hasMore) {
      fetchPosts();
    }

    _lastScrollPosition = currentScrollPosition;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator.adaptive(
      key: refreshKey,
      onRefresh: () async {
        setState(() {
          _postsPerPage = 3;
          _currentPage = 1;
          posts.clear();
          hasMore = true;
        });
        await fetchPosts();
      },
      child: isInitialLoading
          ?  PostShimmerLoading()
          : posts.isEmpty
              ? const NoDataWidget()
              : CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverList.separated(
                      separatorBuilder: (context, index) => Container(
                        height: 1,
                        color: context.isDarkMode
                            ? const Color(0xff2F3336)
                            : Colors.grey.shade300,
                      ),
                      itemCount: posts.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == posts.length) {
                          if (isLoadingMore) {
                            // constrain footer height so the spinner doesn't center vertically over the whole screen
                            return const SizedBox(
                              height: 80,
                              child: Center(child: LinearProgressIndicator()),
                            );
                          } else if (!hasMore) {
                            return const SizedBox(
                              height: 80,
                              child: Center(
                                child: Text("Aucun post disponible."),
                              ),
                            );
                          } else {
                            return const SizedBox(); // rien tant qu’on n’a pas déclenché le chargement
                          }
                        }
                        final post = posts[index];
                        return PostCard(post: post);
                      },
                    ),
                  ],
                ),
    );
  }
  Widget showShimmer() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: SizedBox(
          width: 200.0,
          height: 100.0,
          child: Shimmer.fromColors(
            baseColor: Colors.red,
            highlightColor: Colors.yellow,
            child: const Text(
              'Shimmer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
        )
        ,
      ),
    );
  }
  fetchPosts() async {
    // Prevent concurrent loads
    if (isInitialLoading || isLoadingMore) return;

    // Determine if this is the initial load (no posts yet) or a pagination load
    final bool isInitial = posts.isEmpty;
    setState(() {
      if (isInitial) {
        isInitialLoading = true;
      } else {
        isLoadingMore = true;
      }
    });

    try {
      final newPosts = await ref
          .read(fetchPostProvider.notifier)
          .fetchPosts(_currentPage, _postsPerPage);
      Future.microtask((){
        if(mounted){
          setState(() {
            _currentPage++;
            posts.addAll(newPosts);
            hasMore = newPosts.length == _postsPerPage;
          });
        }
      });
    } catch (error) {
      // handle error if needed (e.g., show a snackbar)
    } finally {
      // Reset loading flags
      Future.microtask(() {
        if(mounted) {
          setState(() {
            isInitialLoading = false;
            isLoadingMore = false;
          });
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
