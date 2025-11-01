import 'package:flutter/material.dart';

import 'package:linkup_pro/features/comments/presentation/widgets/one_comment_shimmer__loading.dart';

class CommentShimmerLoading extends StatelessWidget {
  const CommentShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, index) => Divider(),
        itemCount: 4,
        itemBuilder: (_, index) => const OneCommentShimmerLoading());
  }
}