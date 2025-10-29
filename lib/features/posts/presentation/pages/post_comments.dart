import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PostsCommentsPage extends ConsumerStatefulWidget {
  final String postId;
  const PostsCommentsPage({super.key, required this.postId});

  @override
  ConsumerState<PostsCommentsPage> createState() => _PostsCommentsPageState();
}
class _PostsCommentsPageState extends ConsumerState<PostsCommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: CommentTreeWidget<Comment, Comment>(
          Comment(
              avatar: 'null',
              userName: 'null',
              content: 'felangel made felangel/cubit_and_beyond public '),
          [
            Comment(
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
                'A Dart template generator which helps teams generator which helps teams '),
          ],
          treeThemeData:
          TreeThemeData(lineColor: Colors.green[500]!, lineWidth: 3),
          avatarRoot: (context, data) => PreferredSize(
            preferredSize: Size.fromRadius(18),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage('assets/avatar_2.png'),
            ),
          ),
          avatarChild: (context, data) => PreferredSize(
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage('assets/avatar_1.png'),
            ),
            preferredSize: Size.fromRadius(12),
          ),
          contentChild: (context, data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'dangngocduc',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${data.content}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text('Like'),
                        SizedBox(
                          width: 24,
                        ),
                        Text('Reply'),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
          contentRoot: (context, data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'dangngocduc',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${data.content}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey[700], fontWeight: FontWeight.bold),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text('Like'),
                        SizedBox(
                          width: 24,
                        ),
                        Text('Reply'),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
class Comment{
  final String avatar;
  final String userName;
  final String content;

  Comment(
      {required this.avatar, required this.userName, required this.content});
}