import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/comments/presentation/pages/post_comments.dart';
import 'package:linkup_pro/features/posts/presentation/providers/fetch_one_post.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/one_post_shimmer.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_card.dart';
import 'package:linkup_pro/main.dart';

import '../widgets/no_data_widget.dart';

class PostDetailsPage extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailsPage({super.key, required this.postId});

  @override
  ConsumerState<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends ConsumerState<PostDetailsPage> {
  Post? post;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(fetchOnePostProvider);

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const OnePostShimmer()
          : post == null
              ? const NoDataWidget()
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: PostCard(post: post!, isPostDetails: true),
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.only(
                              bottom: 10
                            ),
                            color: context.isDarkMode
                                ? const Color(0xff2F3336)
                                : Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: PostsCommentsPage(postId: post!.id),
                      ),
                    ),
                  ],
                ),
      bottomSheet: Container(

        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Add a comment...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                // Implement comment submission logic
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetch() async {
    final _post =
        await ref.read(fetchOnePostProvider.notifier).fetchPosts(widget.postId);
    setState(() {
      post = _post;
    });
  }
}
