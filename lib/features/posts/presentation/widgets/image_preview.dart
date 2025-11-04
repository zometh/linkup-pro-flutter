import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';
import 'package:linkup_pro/main.dart';

class ImagePreview extends StatelessWidget {
  final bool  isAssets;
  final List<String> imageUrls;
  const ImagePreview({super.key, required this.imageUrls, this.isAssets = false});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(
      ),
     // appBar: AppBar(title: const Text('Image Preview')),
      body: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];
          return Center(
            child: SizedBox(
              width: double.infinity,
                height: context.screenHeight,
                child: Hero(
                  tag: imageUrls[index],
                  child:
                  InteractiveViewer(child: isAssets ? Image.asset(imageUrl, fit: BoxFit.contain,) : CachedNetworkImage(imageUrl: imageUrl,

                    fit: BoxFit.contain,)),



                )
            ),
          );
        },
      ),
    );
  }
}
