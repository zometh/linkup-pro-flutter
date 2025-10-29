import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts/presentation/pages/post_comments.dart';
import 'package:linkup_pro/features/posts/presentation/providers/fetch_one_post.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/one_post_shimmer.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_card.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_header.dart';

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
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      PostCard(post: post!, isPostDetails: true),
                      Expanded(
                        child: PostsCommentsPage(postId: post!.id),
                      ),
                    ],
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
