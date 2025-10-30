import 'package:cached_network_image/cached_network_image.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linkup_pro/features/comments/presentation/providers/fetch_post_comments.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/comment_shimmer_loading.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/one_comment_shimmer__loading.dart';
import 'package:linkup_pro/main.dart';

import '../../../posts/presentation/widgets/no_data_widget.dart';
import '../../data/comment.dart';


class PostsCommentsPage extends ConsumerStatefulWidget {
  final String postId;
  const PostsCommentsPage({super.key, required this.postId});

  @override
  ConsumerState<PostsCommentsPage> createState() => _PostsCommentsPageState();
}
class _PostsCommentsPageState extends ConsumerState<PostsCommentsPage> {
  final ScrollController _scrollController = ScrollController();
  int _commentsPerPage = 5;
  int _currentPage = 1;
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isInitialLoading = false; // used for first load or refresh
  bool isLoadingMore = false; // used when loading additional pages (pagination)
  bool hasMore = true;
  List<Comment> comments = [];
  double _lastScrollPosition = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchComments();
    _scrollController.addListener(_onScroll);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // No internal scrolling here: parent CustomScrollView manages it
    return  isInitialLoading
        ? OneCommentShimmerLoading() /*CommentShimmerLoading()*/
        : comments.isEmpty
        ? const NoDataWidget():
      FlutterLogo() /*CommentTreeWidget<Comment, Comment>(
      Comment(
          avatar: 'null',
          userName: 'null',
          content: 'felangel made felangel/cubit_and_beyond public '),
      [
       /* Comment(
            avatar: 'null',
            userName: 'null',
            content: 'A Dart template generator which helps teams'),
        Comment(
            avatar: 'null',
            userName: 'null',
            content:
            'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
        Comment(
            avatar: 'null',
            userName: 'null',
            content: 'A Dart template generator which helps teams'),
        Comment(
            avatar: 'null',
            userName: 'null',
            content:
            'A Dart template generator which helps teams generator which helps teams '),*/
      ],
      treeThemeData:
      TreeThemeData(lineColor: context.isDarkMode
            ? const Color(0xff2F3336)
            : Colors.grey.shade300,
       lineWidth: 2),
      avatarRoot: (context, data) => PreferredSize(
        preferredSize: Size.fromRadius(18),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey,
          backgroundImage: CachedNetworkImageProvider("https://pbs.twimg.com/media/G4c9O7RWMAAjUL6?format=jpg&name=small"),
        ),
      ),
      avatarChild: (context, data) => PreferredSize(
        preferredSize: Size.fromRadius(12),
        child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.grey,
          backgroundImage: CachedNetworkImageProvider("https://pbs.twimg.com/media/G4c9O7RWMAAjUL6?format=jpg&name=small"),
        ),
      ),
      contentChild: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'dangngocduc',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${data.content}',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: const [
                  SizedBox(width: 8),
                  Text('Like'),
                  SizedBox(width: 24),
                  Text('Reply'),
                ],
              ),
            )
          ],
        );
      },
      contentRoot: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'dangngocduc',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: const [
                  SizedBox(width: 8),
                  Text('Like'),
                  SizedBox(width: 24),
                  Text('Reply'),
                ],
              ),
            )
          ],
        );
      },
    )*/;
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
      setState(() {
        _currentPage++;
        comments.addAll(newPosts);
        hasMore = newPosts.length == _commentsPerPage;
      });
    } catch (error) {
      // handle error if needed (e.g., show a snackbar)
    } finally {
      // Reset loading flags
      setState(() {
        isInitialLoading = false;
        isLoadingMore = false;
      });
    }
  }
  void _onScroll() {
    final currentScrollPosition = _scrollController.position.pixels;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    // Load more posts when near the bottom
    if (currentScrollPosition >= maxScrollExtent - 350 &&
        !isInitialLoading &&
        !isLoadingMore &&
        hasMore) {
      fetchComments();
    }

    _lastScrollPosition = currentScrollPosition;
  }
}
