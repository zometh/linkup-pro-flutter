import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:linkup_pro/core/widgets/custom_progress.dart';
import 'package:faker/faker.dart' as f;
import 'package:linkup_pro/core/widgets/text_editting_controller_instance.dart';
import 'package:linkup_pro/features/posts/domain/entities/post.dart';
import 'package:linkup_pro/features/posts_actions/domain/entities/post_action_entity.dart';
import 'package:linkup_pro/features/posts_actions/presentation/providers/create_post.dart';
import 'package:linkup_pro/features/posts_actions/presentation/providers/update_post.dart';
import 'package:linkup_pro/features/posts_actions/presentation/widgets/post_action_image_preview.dart';
import 'package:linkup_pro/features/posts_actions/presentation/widgets/post_type_button.dart';
import 'package:linkup_pro/features/posts_actions/presentation/widgets/toolbar_button.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../posts/presentation/providers/fetch_one_post.dart';
import '../../domain/enums/post_type.dart';
import '../widgets/posts_tags_view.dart';


class PostActionPage extends ConsumerStatefulWidget {
  final bool isEdit;
  final String? postId;

  const PostActionPage({super.key,   this.isEdit = false, this.postId});

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
    final isPosting = ref.watch(widget.isEdit ? updatePostProviderProvider : createPostProviderProvider);
    final bool isLoading = ref.watch(fetchOnePostProvider);

    final int remaining = _maxChars - _controller.text.length;
    final theme = Theme.of(context);
    final bool canPost = _controller.text.trim().isNotEmpty || _imageFile != null;
    final loading= widget.isEdit ? isLoading : isPosting;
    return loading ?
    const CustomProgress() :
    Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: (isPosting || !canPost) ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.5),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: isPosting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                (widget.isEdit ? "edit" : "publish").tr(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Type de post - Pills design
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PostTypeButton(
                      type: PostType.publication,
                      label:"simple".tr(),
                      icon: Icons.article_outlined,
                      selectedPostType: _selectedPostType,
                      onChanged: (type) => setState(() => _selectedPostType = type),
                    ).animate().fadeIn( duration: 300.ms)
                  ),
                  PostTypeButton(
                      type: PostType.annonce,
                      label: "announcement".tr(),
                      icon: Icons.campaign_outlined,
                    selectedPostType: _selectedPostType,
                    onChanged: (type) => setState(() => _selectedPostType = type),
                    ).animate().fadeIn(duration: 300.ms),

                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Contenu principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Zone de saisie avec avatar
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          child: Icon(Icons.person, size: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          
                          controller: _controller,
                          maxLines: null,
                          minLines: 3,
                          maxLength: _maxChars,
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            
                            hintText: "what_do_you_want_to_talk_about".tr(),
                            hintStyle: TextStyle(
                              color: theme.hintColor.withValues(alpha: 0.6),
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.all(4),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),


                  // Tags
                  PostsTagsView(
                    selectedTags: _selectedTags,
                    onTagsChanged: (tags) => setState(() => _selectedTags = tags),
                    maxTags: 5,
                  ),
                  const SizedBox(height: 20),
                  PostActionImagePreview(imageFile: _imageFile, removeImage: _removeImage,imageUrl: imageUrl,),

                  if (_imageFile != null) const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                ToolbarButton(
                  icon: Icons.image_outlined,
                  tooltip:"Galerie",
                  onTap :() => _pickImage(ImageSource.gallery),
                ),
                const SizedBox(width: 4),
                ToolbarButton(
                  icon:Icons.camera_alt_outlined,
                  tooltip:"Caméra",
                  onTap :() => _pickImage(ImageSource.camera),
                ),
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        value: _controller.text.isEmpty ? 0 : _controller.text.length / _maxChars,
                        strokeWidth: 3,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          remaining < 0
                              ? theme.colorScheme.error
                              : remaining < 20
                                  ? Colors.orange
                                  : AppColors.primary,
                        ),
                      ),
                    ),
                    if (remaining <= 20)
                      Text(
                        '$remaining',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: remaining < 0 ? theme.colorScheme.error : Colors.orange,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> fetch() async {
    final newPost =
    await ref.read(fetchOnePostProvider.notifier).fetchPosts(widget.postId!);
    if(newPost == null) {
      showToast(description: 'fetching_post_error'.tr(),
          type: ToastificationType.error
      );

        return ;

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
    final XFile? picked = await _picker.pickImage(source: source, imageQuality: 80);
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

  _createPost(String content)async{
    try {
      final post = PostCreationEntity(
        content: content,
        tags: _selectedTags,
        files: _imageFile != null ? [_imageFile!] : [],
        type: _selectedPostType == PostType.publication ? 'POST' : 'ANNOUNCEMENT',
      );
      final response = await ref.read(createPostProviderProvider.notifier).createPost(post);
      if(response == null){
        showToast(description: 'fetching_post_error'.tr(),
            type: ToastificationType.error
        );
        return;
      }
      if (mounted) {
        Navigator.of(context).pop(true); // renvoyer succès
      }
    } catch (e) {
      if (mounted) {
        showToast(description: 'fetching_post_error'.tr(),
            type: ToastificationType.error
        );
      }
    }
  }
  _editPost(String content) async{

    try {
      final updatedPost = PostCreationEntity(
          content: content,
          tags: _selectedTags,
          files: _imageFile != null ? [_imageFile!] : [],
          type: _selectedPostType == PostType.publication
              ? 'POST'
              : 'ANNOUNCEMENT');
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
            if(post!.files.isNotEmpty){
              filesToRemove = [post!.files.first.fileId];
              }
          }
        }
      }

      final response = await ref
          .read(updatePostProviderProvider.notifier)
          .updatePost(updatedPost, filesToRemove, widget.postId!);
     if (response == null) {

       showToast(description: 'creating_post_error'.tr(),
           type: ToastificationType.error
       );
       return;
     }
     if (mounted) {
       Navigator.of(context).pop(true); // renvoyer succès
     }
    }catch(e){
      if (mounted) {
        //updating_post_error
        showToast(description: 'updating_post_error'.tr(),
            type: ToastificationType.error
        );
      }
    }

  }
  Future<void> _submit() async {
    final String content = _controller.text.trim();
    if (content.isEmpty && _imageFile == null) {
      showToast(description: 'add_a_text_or_image'.tr(),
          type: ToastificationType.error
      );

      return;
    }
    if (widget.isEdit) {
      await _editPost(content);
    } else {
      await _createPost(content);
    }


  }

}
