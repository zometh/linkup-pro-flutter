import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:linkup_pro/features/posts/domain/entities/post_file.dart';
import 'package:linkup_pro/main.dart';

import '../../../../core/theme/app_colors.dart';
import 'image_preview.dart';

class BuildPostFile extends StatefulWidget {
  final List<PostFile> files;
  const BuildPostFile({super.key, required this.files});

  @override
  State<BuildPostFile> createState() => _BuildPostFileState();
}

class _BuildPostFileState extends State<BuildPostFile>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  final Map<int, double> _aspectRatios = {};
  @override
  Widget build(BuildContext context) {
    Widget buildSingleMedia(String url, String fileType, {int? index}) {
      const horizontalMargin = 16.0;
      final screenWidth = context.screenWidth;
      final availableWidth = screenWidth - horizontalMargin * 2;

      double height = 300;
      if (index != null && _aspectRatios.containsKey(index)) {
        final ratio = _aspectRatios[index]!; // width / height
        if (ratio > 0) {
          height = (availableWidth / ratio).clamp(
            120.0,
            MediaQuery.of(context).size.height * 0.8,
          );
          if (height > 450) {
            height = 450;
          }
        }
      }

      return AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: horizontalMargin),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
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
            ),
          ),
        ),
      );
    }

    void resolveImage(int index, String url) {
      if (_aspectRatios.containsKey(index)) return;
      final provider = CachedNetworkImageProvider(url);
      final resolver = provider.resolve(const ImageConfiguration());
      ImageStreamListener? listener;
      listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          final img = info.image;
          if (img.height != 0) {
            final ratio = img.width / img.height;

            if (synchronousCall) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                setState(() => _aspectRatios[index] = ratio);
              });
            } else {
              if (mounted) setState(() => _aspectRatios[index] = ratio);
            }
          }
          try {
            resolver.removeListener(listener!);
          } catch (_) {}
        },
        onError: (dynamic _, __) {
          try {
            resolver.removeListener(listener!);
          } catch (_) {}
        },
      );
      resolver.addListener(listener);
    }

    if (widget.files.length == 1) {
      resolveImage(0, widget.files[0].url);
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ImagePreview(imageUrls: transformFiles(widget.files)),
            ),
          );
        },
        child: Hero(
          tag: widget.files[0].url,
          child: buildSingleMedia(
            widget.files[0].url,
            widget.files[0].fileType,
            index: 0,
          ),
        ),
      );
    }

    const horizontalMargin = 16.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - horizontalMargin * 2;
    final ratio = _aspectRatios[_currentImageIndex];
    final double currentHeight = (ratio != null && ratio > 0)
        ? (availableWidth / ratio).clamp(
            120.0,
            MediaQuery.of(context).size.height * 0.8,
          )
        : 300.0;

    return Column(
      children: [
        SizedBox(
          height: currentHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemCount: widget.files.length,
            itemBuilder: (context, index) {
              resolveImage(index, widget.files[index].url);
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ImagePreview(imageUrls: transformFiles(widget.files)),
                    ),
                  );
                },
                child: buildSingleMedia(
                  widget.files[index].url,
                  widget.files[index].fileType,
                  index: index,
                ),
              );
            },
          ),
        ),
        if (widget.files.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.files.length, (index) {
              final isCurrent = _currentImageIndex == index;
              return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isCurrent ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isCurrent
                          ? AppColors.primary
                          : AppColors.primary.withAlpha((0.3 * 255).round()),
                    ),
                  )
                  .animate(target: 1.0)
                  .scaleX(duration: 300.ms, curve: Curves.easeInOut);
            }),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  List<String> transformFiles(List<PostFile> files) {
    return files.map((file) => file.url).toList();
  }
}
