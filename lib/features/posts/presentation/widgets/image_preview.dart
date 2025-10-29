import 'package:flutter/material.dart';
import 'package:linkup_pro/core/widgets/custom_text.dart';

class ImagePreview extends StatelessWidget {
  final List<String> imageUrls;
  const ImagePreview({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: const Text('Image Preview')),
      body: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Hero(
            tag: imageUrls[index],
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrls[index], fit: BoxFit.contain),
                Positioned(
                  width: 100,
                  height: 30,

                  top: 2,
                  right: 2,
                  child: CustomText(
                    text: '${index + 1} / ${imageUrls.length}',
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
