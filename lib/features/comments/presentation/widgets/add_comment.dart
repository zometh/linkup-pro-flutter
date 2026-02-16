import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
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
  bool _isLoading = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = getInstance();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Répondre à indication
            if (widget.c != null) _buildReplyIndicator(isDark),

            // Aperçu de l'image
            if (_pickedImage != null) _buildImagePreview(isDark),

            // Zone de saisie
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Bouton image
                  _buildIconButton(
                    icon: Icons.image_outlined,
                    onPressed: _pickImage,
                    isDark: isDark,
                    tooltip: 'add_image'.tr(),
                  ),

                  const SizedBox(width: 8),

                  // Champ de texte
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withAlpha(13)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        minLines: 1,
                        maxLines: 5,
                        maxLength: 500,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: formatTitle(),
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white38 : Colors.grey.shade500,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          counterText: '',
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Bouton envoyer
                  _buildSendButton(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyIndicator(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withAlpha(26)
            : AppColors.primary.withAlpha(13),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.reply,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${'reply_to'.tr()} ${displayNameFor(widget.c!)}',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    String? tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Tooltip(
          message: tooltip ?? '',
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withAlpha(13)
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: isDark ? Colors.white60 : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton(bool isDark) {
    final hasContent = _controller.text.trim().isNotEmpty || _pickedImage != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: hasContent && !_isLoading
            ? AppColors.primary
            : (isDark ? Colors.white.withAlpha(13) : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: hasContent && !_isLoading ? addComment : null,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: _isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark ? Colors.white : AppColors.primary,
                    ),
                  )
                : Icon(
                    Icons.send_rounded,
                    size: 22,
                    color: hasContent
                        ? Colors.white
                        : (isDark ? Colors.white38 : Colors.grey.shade400),
                  ),
          ),
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

  Widget _buildImagePreview(bool isDark) {
    final file = File(_pickedImage!.path);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.file(
              file,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          // Overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(77),
                    Colors.transparent,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bouton supprimer
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _pickedImage = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16,
                ),
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

    setState(() => _isLoading = true);

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
            _isLoading = false;
          });
          _focusNode.unfocus();
        })
        .catchError((e) {
          setState(() => _isLoading = false);
          MyLogger().log(e.toString(), type: LogType.error);
          if (mounted) {
            showToast(
              description: 'error_occurred'.tr(),
              type: ToastificationType.error,
            );
          }
        });
  }
}
