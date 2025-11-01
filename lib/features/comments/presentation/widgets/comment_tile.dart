import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/routes/app_routes.dart';
import 'package:linkup_pro/core/theme/theme.dart';
import 'package:linkup_pro/core/widgets/my_animated_flipcounter.dart';
import 'package:linkup_pro/features/comments/presentation/pages/sub_comments_page.dart';
import 'package:linkup_pro/features/comments/presentation/widgets/comment_reply.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/network/websocket/config.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../data/comment.dart';
import '../../data/comment_repository_implement.dart';
import '../utils/avatar_url.dart';
import '../utils/display_name.dart';

class CommentTile extends StatefulWidget {
  final bool isSubComment;
  final Comment comment;

  const CommentTile({super.key, required this.comment, this.isSubComment = false});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  final commentImplement = GetIt.I<CommentRepositoryImplement>();
  final io = GetIt.I<SocketService>();
  @override
  void initState() {
    super.initState();
    io.on("commentLikeUpdate", (data){
      updateCommentStats(data);
    });

    // Listen for new sub-comments to update count
    io.on("newSubComment", (data){
      if(data['commentId'] == widget.comment.id){
        setState(() {
          widget.comment.subCommentsCount = data['subCommentCount'];
        });
      }
    });
  }
  updateCommentStats(Map<String, dynamic> data){
    if(data['commentId'] == widget.comment.id){
      setState(() {
        widget.comment.likesCount = data['likesCount'];
        widget.comment.isLikedByUser = data['isLiked'];

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                backgroundImage: avatarUrlFor(widget.comment) != null
                    ? CachedNetworkImageProvider(avatarUrlFor(widget.comment)!)
                    : null,
                child: avatarUrlFor(widget.comment) == null
                    ? CustomText(
                        text: displayNameFor(widget.comment)[0].toUpperCase(),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "Poppins",
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          displayNameFor(widget.comment),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          timeago.format(widget.comment.commentDate),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.comment.content,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    iconSize: 15,
                    onPressed: likeComment,
                    icon: Icon(
                      widget.comment.isLikedByUser
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: widget.comment.isLikedByUser
                          ? Colors.red
                          : null,
                    ),
                  ),
                  MyAnimatedFlipcounter(value: widget.comment.likesCount, fontSize: 14,)
                ],
              ),
              if(!widget.isSubComment)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 15,
                    onPressed: showCommentReply,
                    icon: Icon(FontAwesomeIcons.reply),
                  ),
                  MyAnimatedFlipcounter(value: widget.comment.subCommentsCount, fontSize: 14,),
                ],
              ),
              // View all replies button
              if (widget.comment.subCommentsCount > 0)
                TextButton(
                  onPressed: viewAllReplies,
                  child: CustomText(
                    text: 'view_replies'.tr(),
                   fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }


  showCommentReply() async{
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => CommentReply(comment: widget.comment)
    );
    // The sub-comment count will be updated via socket listener
  }

  viewAllReplies() async {
     MyNavigator(context).navigateTo(SubCommentsPage(parentComment: widget.comment));
  }

  likeComment() async{
    await commentImplement.likeComment(widget.comment.id);
    // The like count will be updated via socket listener
  }
}
