import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/widgets/custom_textfield.dart';
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/features/comments/presentation/providers/create_comment.dart';

import '../../data/comment.dart';

class AddComment extends ConsumerStatefulWidget {
  final String postId;
  const AddComment({super.key, required this.postId});

  @override
  ConsumerState<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends ConsumerState<AddComment> {
  late TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _controller,
              hintText: "Add a comment...",

            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: addComment,
          ),
        ],
      ),
    );
  }
  addComment() async{
    final content = _controller.text.trim();
    if(content.isEmpty) return;
    final Comment? comment = await ref.read(createCommentProvider.notifier).createComment(widget.postId, content, null);

    _controller.clear();
  }
}
