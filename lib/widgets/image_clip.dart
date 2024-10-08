import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageClip extends StatelessWidget {
  final String url;
  final double? width, height;
  ImageClip({required this.url, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width ?? 85,
      height: this.height ?? 85,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ExtendedImage.network(
          '$url',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
