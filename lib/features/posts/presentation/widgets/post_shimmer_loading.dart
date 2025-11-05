import 'package:linkup_pro/features/posts/presentation/widgets/one_post_shimmer.dart';
import 'package:flutter/material.dart';

class PostShimmerLoading extends StatelessWidget {
  const PostShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, index) => Divider(color: Colors.grey.shade200,),
        itemCount: 4,
        itemBuilder: (_, index) => OnePostShimmer());
  }
}
