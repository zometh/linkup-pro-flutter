import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/features/comments/data/entity/comment.dart';
import 'package:linkup_pro/features/comments/data/entity/comment_creation_entity.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../data/comment_repository_implement.dart';
import '../utils/display_name.dart';

class CommentReply extends StatefulWidget {
  final Comment comment;
  const CommentReply({super.key, required this.comment});

  @override
  State<CommentReply> createState() => _CommentReplyState();
}

class _CommentReplyState extends State<CommentReply> {
  late TextEditingController _replyController;
  @override
  void initState() {
    super.initState();
    _replyController = getInstance();
  }
  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Flexible(child: Row(
              children: [
                const Icon(Icons.reply, size: 20,),
                const SizedBox(width: 10),
                Row(
                  children: [
                    CustomText(text: 'reply_to'.tr(), fontWeight: FontWeight.bold, fontSize: 14,),
                    CustomText(text: ' ${displayNameFor(widget.comment)}', fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue,),
                  ],
                )
              ],
            )),
            CustomTextField(controller: _replyController, hintText: 'comment'.tr(), maxLines: 4,maxLength: 200,),

            ElevatedButton(
              onPressed: sendReply,
              child:  Text('reply'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  sendReply() async{
    final commentImplement = GetIt.I<CommentRepositoryImplement>();
    final CommentCreationEntity comment = CommentCreationEntity(content: _replyController.text.trim(), postId: widget.comment.postId,parentId: widget.comment.id);
    final result = await commentImplement.addComment(comment);
    result.fold((failure) {
      // Show error message

      showToast(description: 'error_occurred'.tr(),
          type: ToastificationType.error
      );
    }, (comment) {
      // Successfully added reply
      Navigator.of(context).pop(); // Close the reply modal
    });

  }
}
