import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:linkup_pro/features/posts/presentation/providers/fetch_post.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_card.dart';

class PostsView extends ConsumerStatefulWidget {
  const PostsView({super.key});

  @override
  ConsumerState<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends ConsumerState<PostsView> {
  final ScrollController _scrollController = ScrollController();
   int _postsPerPage = 10;
  int _currentPage = 1;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      key: refreshKey,
      onRefresh: () async {
        _currentPage = 1;
        setState(() {
          _postsPerPage = 10;
          _currentPage = 1;
        });
      },
      child: FutureBuilder(
        future: ref.read(fetchPostProvider.notifier).fetchPosts(_currentPage, _postsPerPage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomProgress());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final posts = snapshot.data ?? [];
          // print(posts.length);
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
      
              return PostCard(post: post);
            },
          );
        },
      ),
    );
  }
}
