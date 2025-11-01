import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:linkup_pro/features/posts/domain/entities/post_file.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text.dart';
import 'image_preview.dart';

class BuildPostFile extends StatefulWidget {
  final List<PostFile> files;
  const BuildPostFile({super.key, required this.files});

  @override
  State<BuildPostFile> createState() => _BuildPostFileState();
}

class _BuildPostFileState extends State<BuildPostFile> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    Widget buildSingleMedia(String url, String fileType) {
      return Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: fileType.startsWith('image')
              ? CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.darkInput,
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.darkInput,
              child: const Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.white54,
              ),
            ),
          )
              : Container(
            color: AppColors.darkInput,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_filled,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                CustomText(
                  text: 'Video',

                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (widget.files.length == 1) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImagePreview(imageUrls: [widget.files[0].url]),
              ),
            );
          },
          child: Hero(
            tag: widget.files[0].url,
            child: buildSingleMedia(widget.files[0].url, widget.files[0].fileType),
          ),
        );
      }

      return Column(
        children: [
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentImageIndex = index);
              },
              itemCount: widget.files.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImagePreview(
                          imageUrls: widget.files.map((f) => f.url).toList(),
                        ),
                      ),
                    );
                  },
                  child: buildSingleMedia(
                    widget.files[index].url,
                    widget.files[index].fileType,
                  ),
                );
              },
            ),
          ),
          if (widget.files.length > 1) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.files.length,
                    (index) =>
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentImageIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentImageIndex == index
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.3),
                      ),
                    )
                        .animate(target: _currentImageIndex == index ? 1 : 0)
                        .scaleX(duration: 300.ms, curve: Curves.easeInOut),
              ),
            ) ,
            const SizedBox(height: 12),
          ],
        ],
      );
    }}

