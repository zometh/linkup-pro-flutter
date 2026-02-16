import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:linkup_pro/main.dart';

class ImagePreview extends StatefulWidget {
  final File? image;
  final bool isAssets;
  final List<String> imageUrls;
  final String? heroTagPrefix;
  final int initialIndex;

  const ImagePreview({
    super.key,
    required this.imageUrls,
    this.isAssets = false,
    this.image,
    this.heroTagPrefix,
    this.initialIndex = 0,
  });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          final imageUrl = widget.imageUrls[index];
          return Center(
            child: SizedBox(
              width: double.infinity,
              height: context.screenHeight,
              child: Hero(
                tag: widget.heroTagPrefix != null
                    ? '${widget.heroTagPrefix}${widget.imageUrls[index]}'
                    : widget.imageUrls[index],
                child: InteractiveViewer(
                  child: widget.isAssets
                      ? Image.file(widget.image!, fit: BoxFit.contain)
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
