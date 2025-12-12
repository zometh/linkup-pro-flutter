import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/features/comments/data/entity/comment.dart';
import 'package:linkup_pro/features/comments/data/entity/comment_creation_entity.dart';
import 'package:linkup_pro/features/comments/presentation/providers/create_comment.dart';
import 'package:linkup_pro/features/comments/presentation/utils/display_name.dart';
import 'package:toastification/toastification.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../core/widgets/custom_toast.dart';

class AddComment extends ConsumerStatefulWidget {
  final String? title;
  final Comment? c;
  final String postId;
  const AddComment({super.key, required this.postId, this.c, this.title});

  @override
  ConsumerState<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends ConsumerState<AddComment> {
  String get title => widget.title?.tr() ?? 'add_a_comment'.tr();
  late TextEditingController _controller;
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_pickedImage != null) _buildImagePreview(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 150,
                    decoration: InputDecoration(
                      hintText: formatTitle(),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: _pickImage,
                  tooltip: 'add_image'.tr(),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: addComment),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatTitle() {
    if (widget.c != null) {
      return "$title ${displayNameFor(widget.c!)}";
    }
    return title;
  }

  Widget _buildImagePreview() {
    final file = File(_pickedImage!.path);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              file,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: InkWell(
              onTap: () {
                setState(() {
                  _pickedImage = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _pickedImage = picked;
        });
      }
    } catch (e) {
      showToast(
        description: 'error_occurred'.tr(),
        type: ToastificationType.error,
      );
    }
  }

  addComment() async {
    if (_controller.text.isEmpty && _pickedImage == null) return;

    final content = _controller.text.trim();
    if (content.isEmpty && _pickedImage == null) return;
    final parentId = widget.c?.id;
    final CommentCreationEntity comment = CommentCreationEntity(
      content: content,
      postId: widget.postId,
      file: _pickedImage != null ? File(_pickedImage!.path) : null,
      parentId: parentId,
    );

    await ref
        .read(createCommentProvider.notifier)
        .createComment(comment)
        .then((v) {
          _controller.clear();
          setState(() {
            _pickedImage = null;
          });
          // Navigator.of(context).pop(true);
        })
        .catchError((e) {
          MyLogger().log(e.toString(), type: LogType.error);
          if (mounted) {
            /*showToast(description: 'error_occurred'.tr(),
            type: ToastificationType.error
        );*/
          }
        });
  }
}
