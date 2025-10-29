import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/network/api/api_client.dart';
import '../../../../core/network/websocket/config.dart';
import '../../../../core/services/localdb/localdb.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters/format_number.dart';
import '../../../../core/utils/my_logger.dart';
import '../../domain/entities/post.dart';

class PostsStats extends StatefulWidget {
  final Post post;
  const PostsStats({super.key, required this.post});

  @override
  State<PostsStats> createState() => _PostsStatsState();
}

class _PostsStatsState extends State<PostsStats> {
  final io = GetIt.I<SocketService>();
  final db = GetIt.I<LocalDBService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    io.on("likeUpdate", (callback){
      final Map<String, dynamic> data = callback;

      updateCounter(data);
    });
  }
  updateCounter(Map<String, dynamic> data) async{
    final userId = await db.getUserId();
    if(data["postId"] != widget.post.id ) return;
    if(mounted){
      Future.microtask((){
        setState(() {
          widget.post.likesCount = data["likesCount"];
          if(data["userId"] == userId){
            widget.post.isLiked = data["isLiked"];
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Padding(
        padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 6),
        child: Row(
          children: [
            _buildActionButton(
                icon: widget.post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label:  widget.post.likesCount,
                color:  widget.post.isLiked ? AppColors.primary : Colors.grey,
                isDark: isDark,
                onTap:likeOrDislike
            ),
            const SizedBox(width: 16),
            _buildActionButton(
                icon:Icons.comment,
                label:widget.post.commentsCount,
                color: AppColors.info,
                isDark: isDark
            ),
            const SizedBox(width: 16),
            _buildActionButton(
              icon: Icons.share,
              label:widget.post.sharesCount,
              color:AppColors.success,
              isDark :isDark,
            ),
          ],
        ),
      );
    }
  likeOrDislike() async{
    final apiClient = GetIt.I<ApiClient>();
    try{
      final response = await apiClient.post('/posts/like/${widget.post.id}', data: {});


    }catch(e){
      MyLogger().log(e.toString(), type: LogType.error);
    }
  }
  Widget _buildActionButton({
    required IconData icon,
    required int label,
    Color? color,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    final buttonColor =
        color ?? (isDark ? Colors.white70 : AppColors.textSecondary);
    final reactionsData = FormatNumber.formatReactions(label);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(icon, size: 23, color: buttonColor),
            const SizedBox(width: 6),
            Flexible(
              child: AnimatedFlipCounter(value: reactionsData['value'],
                fractionDigits: reactionsData['suffix'] != '' ? 1 : 0,
                suffix: reactionsData['suffix'],

                duration:   Duration(milliseconds: 500),
                textStyle: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: buttonColor,

                ),
              )
            ),
          ],
        ),
      ),
    )
        .animate(/*target: color != null ? 1 : 0*/)
        .scale(duration: 200.ms, curve: Curves.bounceInOut);
  }
  }
