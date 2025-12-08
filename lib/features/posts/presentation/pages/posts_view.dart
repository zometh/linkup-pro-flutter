import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/services/localdb/localdb.dart';
import 'package:linkup_pro/features/bottom_nav_bar/providers/bottom_navbar.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/presentation/providers/fetch_post.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/no_data_widget.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_card.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_shimmer_loading.dart';
import 'package:linkup_pro/main.dart';
import 'package:shimmer/shimmer.dart';

class PostsView extends ConsumerStatefulWidget {
  final bool isMyPosts;
  
  const PostsView({super.key, this.isMyPosts = false});

  @override
  ConsumerState<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends ConsumerState<PostsView>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  int _postsPerPage = 5;
  int _currentPage = 1;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isInitialLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  List<Post> posts = [];
  double _lastScrollPosition = 0;
  final io = GetIt.I<SocketService>();
  String? connectedUserId;
  @override
  void initState() {
    super.initState();
    getUserId();
    fetchPosts();
    _scrollController.addListener(_onScroll);

    _setupSocketListeners();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Nettoyer les listeners WebSocket
    io.off("newPost");
    io.off("deletePost");
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
          ? PostShimmerLoading()
          : posts.isEmpty
          ? NoDataWidget(onPressed: () => fetchPosts())
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
                        return const SizedBox(
                          height: 80,
                          child: Center(child: LinearProgressIndicator()),
                        );
                      } else if (!hasMore) {
                        return const SizedBox(
                          height: 80,
                          child: Center(child: Text("Aucun post disponible.")),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }
                    final post = posts[index];
                    return PostCard(post: post, userId: connectedUserId!);
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
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getUserId() async {
    final storage = GetIt.I<LocalDBService>();
    final userId = await storage.getUserId();
    if (mounted) {
      Future.microtask(() {
        setState(() {
          connectedUserId = userId;
        });
      });
    }
  }

  fetchPosts() async {
    if (isInitialLoading || isLoadingMore) return;

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
          .fetchPosts(_currentPage, _postsPerPage, widget.isMyPosts);
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _currentPage++;
            posts.addAll(newPosts);
            hasMore = newPosts.length == _postsPerPage;
          });
        }
      });
    } catch (error) {
    } finally {
      Future.microtask(() {
        if (mounted) {
          setState(() {
            isInitialLoading = false;
            isLoadingMore = false;
          });
        }
      });
    }
  }

  void _setupSocketListeners() {
    io.off("newPost");
    io.off("deletePost");
    io.off("postUpdated");

    io.on("newPost", (d) {
      if (d is Map<String, dynamic>) {
        insertNewPost(d);
        io.joinRoom("postSubscribe", {"roomId": d["id"]});
      } else {}
    });
    io.on("postUpdated", (v) {
      if (v is Map<String, dynamic>) {
        updatePost(v);
      } else {}
    });
    io.on("deletePost", (v) {
      if (v is String) {
        removePost(v);
      } else {}
    });
  }

  removePost(String postId) {
    final existingIndex = posts.indexWhere((post) => post.id == postId);

    if (existingIndex != -1) {
      setState(() {
        posts.removeAt(existingIndex);
      });
    } else {}
  }

  void _onScroll() {
    final currentScrollPosition = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    ref.read(bottomNavbarVisibilityProvider.notifier).state = true;
    if (currentScrollPosition > _lastScrollPosition &&
        currentScrollPosition > 100) {
      ref.read(bottomNavbarVisibilityProvider.notifier).state = false;
    } else if (currentScrollPosition < _lastScrollPosition) {
      ref.read(bottomNavbarVisibilityProvider.notifier).state = true;
    }

    if (currentScrollPosition >= maxScrollExtent - 350 &&
        !isInitialLoading &&
        !isLoadingMore &&
        hasMore) {
      fetchPosts();
    }

    _lastScrollPosition = currentScrollPosition;
  }

  void insertNewPost(Map<String, dynamic> data) {
    final newPost = Post.fromJson(data);

    final existingIndex = posts.indexWhere((post) => post.id == newPost.id);

    if (existingIndex != -1) {
      setState(() {
        posts[existingIndex] = newPost;
      });
      return;
    }

    setState(() {
      posts.insert(0, newPost);
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  updatePost(Map<String, dynamic> data) {
    final updatedPost = Post.fromJson(data);

    final existingIndex = posts.indexWhere((post) => post.id == updatedPost.id);

    if (existingIndex != -1) {
      setState(() {
        posts[existingIndex] = updatedPost;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
