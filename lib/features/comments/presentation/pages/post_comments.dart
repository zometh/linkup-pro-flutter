import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/utils/my_logger.dart';
import 'package:linkup_pro/core/widgets/custom_confirmation_dialog.dart';
import 'package:linkup_pro/features/comments/data/comment_repository_implement.dart';
import 'package:linkup_pro/features/comments/presentation/providers/fetch_post_comments.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/comment_tile.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/no_comments_found.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/one_comment_shimmer__loading.dart';
import 'package:linkup_pro/main.dart';
import '../../../../core/network/websocket/config.dart';
import '../../data/entity/comment.dart';


class PostsCommentsPage extends ConsumerStatefulWidget {
  final String postId;
  const PostsCommentsPage({super.key, required this.postId});

  @override
  ConsumerState<PostsCommentsPage> createState() => _PostsCommentsPageState();
}
class _PostsCommentsPageState extends ConsumerState<PostsCommentsPage> {
  late final ScrollController _localScrollController;
  ScrollController? _attachedController;
  bool _attachedToPrimary = false;
  bool _listenerAttached = false;

  final int _commentsPerPage = 3;
  int _currentPage = 1;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isInitialLoading = false; // used for first load or refresh
  bool isLoadingMore = false; // used when loading additional pages (pagination)
  bool hasMore = true;
  List<Comment> comments = [];
  final io = GetIt.I<SocketService>();

  @override
  void initState() {
    super.initState();
    // create a local controller; we will attach the listener either to the
    // PrimaryScrollController (if parent provides one) or to this local one.
    _localScrollController = ScrollController();
    io.on("newComment", (data){
      if(data["postId"] == widget.postId){
        Future.microtask(() {
          final newComment = Comment.fromJson(data["commentData"]["response"]);
          // Only add if it's a main comment (not a reply)
          if(newComment.commentId == null){
            Future.microtask(() {
              setState(() {
                comments.insert(0, newComment);
              });
            });
          }
        });
      }
    });
    // Fetch initial comments
    fetchComments();
    // Don't add listener here because PrimaryScrollController might be available
    // only after widget is inserted into tree; we attach in didChangeDependencies.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Attach to PrimaryScrollController if available so pagination works when
    // this page is inside a scrollable parent (e.g. CustomScrollView).
    final primary = PrimaryScrollController.maybeOf(context);
    // If primary exists and we weren't attached to it yet -> attach
    if (primary != null && _attachedController != primary) {
      // detach old if present
      if (_listenerAttached && _attachedController != null) {
        _attachedController!.removeListener(_onScroll);
        _listenerAttached = false;
      }
      _attachedController = primary;
      _attachedToPrimary = true;
    } else if (primary == null && _attachedController == null) {
      // Use local controller when no primary controller
      _attachedController = _localScrollController;
      _attachedToPrimary = false;
    }

    if (!_listenerAttached && _attachedController != null) {
      _attachedController!.addListener(_onScroll);
      _listenerAttached = true;
    }
  }

  @override
  void dispose() {
    if (_listenerAttached && _attachedController != null) {
      _attachedController!.removeListener(_onScroll);
      _listenerAttached = false;
    }
    // dispose only the local controller (don't dispose primary controller)
    if (!_attachedToPrimary) {
      _localScrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (isInitialLoading) return OneCommentShimmerLoading();
    if (comments.isEmpty) return NoCommentsFound();

    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: context.isDarkMode
            ? const Color(0xff2F3336)
            : Colors.grey.shade300,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < comments.length) {
          final comment = comments[index];

          return InkWell(
              onLongPress:() =>  showMoreDialog(comment.content, comment.id),
              child: CommentTile(comment: comment));
        } else {
          // Show loading indicator at the bottom when loading more
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
  showMoreDialog(String text, String commentId) async{

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
  deleteComment(String commentId) async{
    final commentImplement = GetIt.I<CommentRepositoryImplement>();
    final response = await commentImplement.deleteComment(commentId);
    response.fold((f) => MyLogger().log(f.message), (r) {
      setState(() {
        comments.removeWhere((comment) => comment.id == commentId);
      });
    });
  }
  fetchComments() async{
    if (isInitialLoading || isLoadingMore) return;
    final bool isInitial = comments.isEmpty;
    setState(() {
      if (isInitial) {
        isInitialLoading = true;
      } else {
        isLoadingMore = true;
      }
    });
    try {
      final newPosts = await ref
          .read(fetchPostCommentsProvider.notifier)
          .fetchPostComments(widget.postId,_currentPage, _commentsPerPage);

      // Filter to only include main comments (not replies)
      final mainComments = newPosts.where((comment) => comment.commentId == null).toList();

      setState(() {
        _currentPage++;
        comments.addAll(mainComments);
        hasMore = newPosts.length == _commentsPerPage;
      });
    } catch (error) {
      // handle error if needed (e.g., show a snackbar)
    } finally {
      // Reset loading flags
      Future.microtask(() {
        setState(() {
          isInitialLoading = false;
          isLoadingMore = false;
        });
      });
    }
  }
  void _onScroll() {
    try {
      final controller = _attachedController ?? _localScrollController;
      if (!controller.hasClients) return;
      final currentScrollPosition = controller.position.pixels;
      final maxScrollExtent = controller.position.maxScrollExtent;
      // Load more posts when near the bottom
      if (currentScrollPosition >= maxScrollExtent - 250 &&
          !isInitialLoading &&
          !isLoadingMore &&
          hasMore) {
        fetchComments();
      }

    } catch (_) {
      // ignore if scroll metrics not available
    }
  }
}
