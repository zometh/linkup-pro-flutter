import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/add_comment.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/comments/presentation/pages/post_comments.dart';
import 'package:linkup_pro/features/posts/presentation/providers/fetch_one_post.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/one_post_shimmer.dart';
import 'package:linkup_pro/features/posts/presentation/widgets/post_card.dart';
import 'package:linkup_pro/main.dart';

import '../../../comments/data/comment.dart';
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
      backgroundColor: context.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
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
                          PostCard(post: post!, isPostDetails: true),
                          Container(
                            height: 1,

                            color: context.isDarkMode
                                ? const Color(0xff2F3336)
                                : Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only( top: 5,
                        bottom: 100
                        ),
                        child: PostsCommentsPage(postId: post!.id),
                      ),
                    ),
                  ],
                ),
      bottomSheet: post != null ? AddComment(postId: post!.id) : null,
    );
  }
  Column displayCommentsList(List<Comment> comments) {
    return Column(
      children: [
        ListView.builder(
          //controller: _attachedController,
          shrinkWrap: true,
         // physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return Text(comment.content);
          },
        ),

      ],
    );
  }
  Future<void> fetch() async {
    final newPost =
        await ref.read(fetchOnePostProvider.notifier).fetchPosts(widget.postId);
    setState(() {
      post = newPost;
    });
  }
}
