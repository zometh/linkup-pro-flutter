import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/network/websocket/config.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/features/comments/data/entity/comment.dart';
import 'package:linkup_pro/features/comments/data/comment_repository_implement.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/add_comment.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/comment_tile.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/no_comments_found.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/one_comment_shimmer__loading.dart';
import 'package:linkup_pro/main.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/widgets/custom_confirmation_dialog.dart';
import '../../../../core/widgets/custom_toast.dart';

class SubCommentsPage extends ConsumerStatefulWidget {
  final Comment parentComment;

  const SubCommentsPage({super.key, required this.parentComment});

  @override
  ConsumerState<SubCommentsPage> createState() => _SubCommentsPageState();
}

class _SubCommentsPageState extends ConsumerState<SubCommentsPage> {
  final commentImplement = GetIt.I<CommentRepositoryImplement>();
  final io = GetIt.I<SocketService>();

  final int _commentsPerPage = 10;
  int _currentPage = 1;
  bool isInitialLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  List<Comment> subComments = [];

  @override
  void initState() {
    super.initState();

    // Listen for new sub-comments
    io.on("newComment", (data) {
      if (data["postId"] == widget.parentComment.postId &&
          data["commentId"] == widget.parentComment.id) {
        Future.microtask(() {
          setState(() {
            subComments.insert(
              0,
              Comment.fromJson(data["commentData"]["response"]),
            );
            widget.parentComment.subCommentsCount++;
          });
        });
      }
    });

    fetchSubComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('replies'.tr()), elevation: 1),
      body: Column(
        children: [
          Expanded(
            child: isInitialLoading
                ? OneCommentShimmerLoading()
                : subComments.isEmpty
                ? NoCommentsFound()
                : ListView.separated(
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: context.isDarkMode
                          ? const Color(0xff2F3336)
                          : Colors.grey.shade300,
                    ),
                    itemCount: subComments.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < subComments.length) {
                        final subComment = subComments[index];
                        return InkWell(
                          onTap: () =>
                              showMoreDialog(subComment.content, subComment.id),
                          child: CommentTile(
                            comment: subComment,
                            isSubComment: true,
                          ),
                        ) /*SubCommentTile(subComment: subComment)*/;
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
          ),
          // Add reply button at the bottom
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? const Color(0xff16181C)
                  : Colors.white,
              border: Border(
                top: BorderSide(
                  color: context.isDarkMode
                      ? const Color(0xff2F3336)
                      : Colors.grey.shade300,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: showCommentReply,
                  icon: const Icon(Icons.reply),
                  label: Text('add_reply'.tr()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showMoreDialog(String text, String commentId) async {
    final result = await CustomConfirmationDialog.showDeleteConfirmation(
      context: context,
      title: 'delete_comment'.tr(),
      message: 'delete_comment_message'.tr(),
      confirmText: 'delete'.tr(),
      cancelText: 'cancel'.tr(),
    );

    if (result == true) {
      deleteComment(commentId);
    }
  }

  deleteComment(String commentId) async {
    final commentImplement = GetIt.I<CommentRepositoryImplement>();
    final response = await commentImplement.deleteComment(commentId);
    response.fold((f) => MyLogger().log(f.message), (r) {
      setState(() {
        subComments.removeWhere((comment) => comment.id == commentId);
      });
    });
  }

  fetchSubComments() async {
    final commentImplement = GetIt.I<CommentRepositoryImplement>();

    if (isInitialLoading || isLoadingMore) return;
    final bool isInitial = subComments.isEmpty;
    setState(() {
      if (isInitial) {
        isInitialLoading = true;
      } else {
        isLoadingMore = true;
      }
    });

    try {
      final response = await commentImplement.fetchSubComments(
        widget.parentComment.postId,
        widget.parentComment.id,
        _currentPage,
        _commentsPerPage,
      );

      final newSubComments = response.fold((failure) {
        showToast(
          description: 'error_occurred'.tr(),
          type: ToastificationType.error,
        );

        return <Comment>[];
      }, (d) => d);
      Future.microtask(() {
        /* final newComments = newSubComments
            .where((c) => c.commentId == widget.parentComment.id)
            .toList();*/

        setState(() {
          _currentPage++;
          subComments.addAll(newSubComments);
          hasMore = newSubComments.length == _commentsPerPage;
        });
      });
    } catch (error) {
      // handle error
      if (mounted) {
        showToast(
          description: 'error_occurred'.tr(),
          type: ToastificationType.error,
        );
      }
    } finally {
      Future.microtask(() {
        setState(() {
          isInitialLoading = false;
          isLoadingMore = false;
        });
      });
    }
  }

  showCommentReply() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddComment(
        postId: widget.parentComment.postId,
        c: widget.parentComment,
      ) /*CommentReply(comment: widget.parentComment)*/,
    );

    // Refresh after adding a reply
    if (result == true) {
      setState(() {
        subComments.clear();
        _currentPage = 1;
        hasMore = true;
      });
      fetchSubComments();
    }
  }
}
