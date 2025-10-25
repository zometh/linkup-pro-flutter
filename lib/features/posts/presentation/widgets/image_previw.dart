import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final List<String> imageUrls;
  const ImagePreview({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
      ),
      body: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}