import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:linkup_pro/core/theme/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/widgets/custom_text.dart';
import '../../../../core/widgets/my_animated_flipcounter.dart';
import '../../../../core/network/websocket/config.dart';
import '../../data/comment.dart';
import '../../data/comment_repository_implement.dart';
import '../utils/avatar_url.dart';
import '../utils/display_name.dart';

class SubCommentTile extends StatefulWidget {
  final Comment subComment;

  const SubCommentTile({super.key, required this.subComment});

  @override
  State<SubCommentTile> createState() => _SubCommentTileState();
}

class _SubCommentTileState extends State<SubCommentTile> {
  final commentImplement = GetIt.I<CommentRepositoryImplement>();
  final io = GetIt.I<SocketService>();

  @override
  void initState() {
    super.initState();
    io.on("commentLikeUpdate", (data) {
      updateCommentStats(data);
    });
  }

  updateCommentStats(Map<String, dynamic> data) {
    if (data['commentId'] == widget.subComment.id) {
      setState(() {
        widget.subComment.likesCount = data['likesCount'];
        widget.subComment.isLikedByUser = data['isLiked'];
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
                radius: 20,
                backgroundColor: AppColors.primary,
                backgroundImage: avatarUrlFor(widget.subComment) != null
                    ? CachedNetworkImageProvider(avatarUrlFor(widget.subComment)!)
                    : null,
                child: avatarUrlFor(widget.subComment) == null
                    ? CustomText(
                        text: displayNameFor(widget.subComment)[0].toUpperCase(),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                          displayNameFor(widget.subComment),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          timeago.format(widget.subComment.commentDate),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subComment.content,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 44.0),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      iconSize: 14,
                      onPressed: likeComment,
                      icon: Icon(
                        widget.subComment.isLikedByUser
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: widget.subComment.isLikedByUser
                            ? Colors.red
                            : null,
                      ),
                    ),
                    MyAnimatedFlipcounter(
                      value: widget.subComment.likesCount,
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  likeComment() async {
    await commentImplement.likeComment(widget.subComment.id);
    // The like count will be updated via socket listener
  }
}

