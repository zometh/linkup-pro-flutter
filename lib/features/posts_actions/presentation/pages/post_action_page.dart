import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:faker/faker.dart' as f;
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts_actions/domain/entities/post_action_entity.dart';
import 'package:linkup_pro/features/posts_actions/presentation/providers/create_post.dart';
import 'package:linkup_pro/features/posts_actions/presentation/providers/update_post.dart';
import 'package:linkup_pro/features/posts_actions/presentation/widgets/post_action_image_preview.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../posts/presentation/providers/fetch_one_post.dart';
import '../../domain/enums/post_type.dart';
import '../widgets/character_counter.dart';
import '../widgets/floating_media_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/posts_tags_view.dart';

class PostActionPage extends ConsumerStatefulWidget {
  final bool isEdit;
  final String? postId;

  const PostActionPage({super.key, this.isEdit = false, this.postId});

  @override
  ConsumerState<PostActionPage> createState() => _PostActionPageState();
}

class _PostActionPageState extends ConsumerState<PostActionPage> {
  final faker = f.Faker();
  late TextEditingController _controller;
  final int _maxChars = 200;
  File? _imageFile;
  PostType _selectedPostType = PostType.publication;
  String? imageUrl;
  List<String> _selectedTags = [];
  Post? post;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = getInstance(initial: faker.lorem.sentence());
    fetch();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPosting = ref.watch(
      widget.isEdit ? updatePostProviderProvider : createPostProviderProvider,
    );
    final bool isLoading = ref.watch(fetchOnePostProvider);

    final int remaining = _maxChars - _controller.text.length;
    final theme = Theme.of(context);
    final bool canPost =
        _controller.text.trim().isNotEmpty || _imageFile != null;
    final loading = widget.isEdit ? isLoading : isPosting;
    final isDark = theme.brightness == Brightness.dark;

    return loading
        ? const CustomProgress()
        : Scaffold(
            backgroundColor: isDark
                ? const Color(0xFF0A0E21)
                : const Color(0xFFF5F7FA),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF1E2139).withValues(alpha: 0.95),
                            const Color(0xFF0F1129).withValues(alpha: 0.95),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.95),
                            const Color(0xFFF8F9FB).withValues(alpha: 0.95),
                          ],
                  ),
                ),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(13),
                    bottomLeft: Radius.circular(13),
                    bottomRight: Radius.circular(11),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 19),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.4,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isEdit ? Icons.edit_rounded : Icons.add_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Text(
                    widget.isEdit ? 'edit_post'.tr() : 'create_post'.tr(),
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      height: 1.2,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    gradient: (isPosting || !canPost)
                        ? null
                        : LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    color: (isPosting || !canPost)
                        ? theme.colorScheme.primary.withValues(alpha: 0.3)
                        : null,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: (isPosting || !canPost)
                        ? null
                        : [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (isPosting || !canPost) ? null : _submit,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: isPosting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Opacity(
                                    opacity: (isPosting || !canPost) ? 0.5 : 1.0,
                                    child: const Text(
                                      '🚀',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    (widget.isEdit ? 'edit' : 'publish').tr(),
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.1,
                                      color: (isPosting || !canPost)
                                          ? Colors.white.withValues(alpha: 0.5)
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // Contenu principal scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Zone d'écriture naturelle
                          GlassCard(
                            isDark: isDark,
                            padding: const EdgeInsets.fromLTRB(18, 16, 16, 18),
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              maxLength: _maxChars,
                              autofocus: true,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.55,
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                              ),
                              decoration: InputDecoration(
                                hintText: 'what_do_you_want_to_talk_about'.tr(),
                                hintStyle: TextStyle(
                                  color: theme.hintColor.withValues(alpha: 0.4),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.15,
                                  height: 1.55,
                                ),
                                border: InputBorder.none,
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Catégoriser votre post
                          GlassCard(
                            isDark: isDark,
                            padding: const EdgeInsets.fromLTRB(17, 15, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      '🏷️',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      'Tags',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.8),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                PostsTagsView(
                                  selectedTags: _selectedTags,
                                  onTagsChanged: (tags) =>
                                      setState(() => _selectedTags = tags),
                                  maxTags: 5,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Aperçu de l'image
                          if (_imageFile != null || imageUrl != null)
                            GlassCard(
                              isDark: isDark,
                              padding: const EdgeInsets.all(5),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(18),
                                      bottomLeft: Radius.circular(18),
                                      bottomRight: Radius.circular(17),
                                    ),
                                    child: PostActionImagePreview(
                                      imageFile: _imageFile,
                                      removeImage: _removeImage,
                                      imageUrl: imageUrl,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 9,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.75,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.25,
                                          ),
                                          width: 1.2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.35,
                                            ),
                                            blurRadius: 10,
                                            spreadRadius: -1,
                                            offset: const Offset(0.5, 1),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 17,
                                        ),
                                        onPressed: _removeImage,
                                        padding: const EdgeInsets.all(7),
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),

                // Outils rapides
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              const Color(0xFF1E2139).withValues(alpha: 0.97),
                              const Color(0xFF0F1129).withValues(alpha: 0.97),
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.97),
                              const Color(0xFFF8F9FB).withValues(alpha: 0.97),
                            ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(21),
                      bottomLeft: Radius.circular(21),
                      bottomRight: Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.5)
                            : theme.colorScheme.primary.withValues(alpha: 0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(13, 10, 12, 11),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.07)
                                : Colors.black.withValues(alpha: 0.05),
                            width: 0.9,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(21),
                            bottomLeft: Radius.circular(21),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                        child: Row(
                          children: [
                            FloatingMediaButton(
                              emoji: '🖼️',
                              icon: Icons.image_outlined,
                              label: 'gallery'.tr(),
                              onTap: () => _pickImage(ImageSource.gallery),
                              theme: theme,
                              isDark: isDark,
                            ),
                            const SizedBox(width: 9),
                            FloatingMediaButton(
                              emoji: '📸',
                              icon: Icons.camera_alt_outlined,
                              label: 'camera'.tr(),
                              onTap: () => _pickImage(ImageSource.camera),
                              theme: theme,
                              isDark: isDark,
                            ),
                            const Spacer(),
                            CharacterCounter(
                              remaining: remaining,
                              theme: theme,
                              progress: _controller.text.isEmpty
                                  ? 0
                                  : _controller.text.length / _maxChars,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> fetch() async {
    final newPost = await ref
        .read(fetchOnePostProvider.notifier)
        .fetchPosts(widget.postId!);
    if (newPost == null) {
      showToast(
        description: 'fetching_post_error'.tr(),
        type: ToastificationType.error,
      );

      return;
    }

    Future.microtask(() {
      setState(() {
        post = newPost;
        _controller.text = post!.content;
        _selectedTags = post!.tags;
        _selectedPostType = post!.type;
        imageUrl = post!.files.isNotEmpty ? post!.files.first.url : null;
      });
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
      imageUrl = null;
    });
  }

  _createPost(String content) async {
    try {
      final post = PostCreationEntity(
        content: content,
        tags: _selectedTags,
        files: _imageFile != null ? [_imageFile!] : [],
        type: _selectedPostType == PostType.publication
            ? 'POST'
            : 'ANNOUNCEMENT',
      );
      final response = await ref
          .read(createPostProviderProvider.notifier)
          .createPost(post);
      if (response == null) {
        showToast(
          description: 'fetching_post_error'.tr(),
          type: ToastificationType.error,
        );
        return;
      }
      if (mounted) {
        Navigator.of(context).pop(true); // renvoyer succès
      }
    } catch (e) {
      if (mounted) {
        showToast(
          description: 'fetching_post_error'.tr(),
          type: ToastificationType.error,
        );
      }
    }
  }

  _editPost(String content) async {
    try {
      final updatedPost = PostCreationEntity(
        content: content,
        tags: _selectedTags,
        files: _imageFile != null ? [_imageFile!] : [],
        type: _selectedPostType == PostType.publication
            ? 'POST'
            : 'ANNOUNCEMENT',
      );
      // Determine which files should be removed when editing a post.
      // Cases:
      // 1) If user selected a new image (_imageFile != null) and the post had an existing file -> remove the old file id.
      // 2) Else if no new image and imageUrl != null -> user kept the existing image -> remove nothing.
      // 3) Else (no new image and imageUrl == null) and post had an existing file -> user removed the image -> remove the old file id.
      List<String> filesToRemove = [];
      if (post != null && post!.files.isNotEmpty) {
        if (_imageFile != null) {
          // New image chosen: delete previous file
          filesToRemove = [post!.files.first.fileId];
        } else {
          // No new image chosen
          if (imageUrl != null) {
            // Existing image kept: nothing to remove
            filesToRemove = [];
          } else {
            // imageUrl is null (user removed image) -> remove previous file
            if (post!.files.isNotEmpty) {
              filesToRemove = [post!.files.first.fileId];
            }
          }
        }
      }

      final response = await ref
          .read(updatePostProviderProvider.notifier)
          .updatePost(updatedPost, filesToRemove, widget.postId!);
      if (response == null) {
        showToast(
          description: 'creating_post_error'.tr(),
          type: ToastificationType.error,
        );
        return;
      }
      if (mounted) {
        Navigator.of(context).pop(true); // renvoyer succès
      }
    } catch (e) {
      if (mounted) {
        //updating_post_error
        showToast(
          description: 'updating_post_error'.tr(),
          type: ToastificationType.error,
        );
      }
    }
  }

  Future<void> _submit() async {
    final String content = _controller.text.trim();
    if (content.isEmpty && _imageFile == null) {
      showToast(
        description: 'add_a_text_or_image'.tr(),
        type: ToastificationType.error,
      );

      return;
    }
    if (widget.isEdit) {
      await _editPost(content);
    } else {
      await _createPost(content);
    }
  }

  // ==================== UI HELPERS ====================
}
