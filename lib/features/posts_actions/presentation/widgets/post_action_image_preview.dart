import 'dart:io';

import 'package:flutter/material.dart';

import '../../../posts/presentation/widgets/image_preview.dart';


class PostActionImagePreview extends StatelessWidget {
  String? imageUrl;
  final VoidCallback removeImage;
  File? imageFile;
   PostActionImagePreview({super.key, required this.imageFile, required this.removeImage, this.imageUrl});



  @override
  Widget build(BuildContext context) {

      if (imageFile == null && imageUrl == null) return const SizedBox.shrink();


      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ImagePreview(
                      imageUrls: [],
                      image: imageFile,
                      isAssets: true,
                    ),
                  ),
                );
              },
              child: Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: imageFile != null ? Image.file(
                  imageFile!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ) : Image.network(
                  imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.black.withValues(alpha: 0.6),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: ()=> removeImage.call(),
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );


  }
}
