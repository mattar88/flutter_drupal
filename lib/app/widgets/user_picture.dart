import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final dynamic image;
  final double? width;
  final double? height;

  const ImageView(this.image, {this.width, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return (Image(
        width: width,
        height: height,
        fit: BoxFit.cover,
        frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: frame != null ? child : CircularProgressIndicator(),
          );
        }),
        errorBuilder: (context, exception, stackTrace) {
          return IconButton(onPressed: () {}, icon: Icon(Icons.warning));
        },
        image: NetworkImage(image.uri.toString())));
  }
}
