import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero(
      {Key? key, this.photo, this.onTap, this.width, this.height, this.fit})
      : super(key: key);

  final String? photo;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BoxFit? fit;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: (this.height != null && this.height! > 0)
          ? this.height
          : double.infinity,
      child: InkWell(
        onTap: onTap,
        child: ExtendedImage.network(
          '$photo',
          fit: fit == null ? BoxFit.cover : fit,
        ),
      ),
    );
  }

  Widget inHero() {
    var rand = new Random().nextInt(999); //.nextInt(999999999);
    return Hero(
      tag: "$photo-$rand",
      child: Material(
        //color: Theme.of(context).primaryColor.withOpacity(0.25),
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ExtendedImage.network(
            '$photo',
            fit: fit == null ? BoxFit.cover : fit,
          ),
        ),
      ),
    );
  }

  static Widget loading() {
    return Container(
        child: SizedBox(
            width: 30,
            height: 30,
            child: Center(child: CircularProgressIndicator())));
  }

  static toast(String text) {
    EasyLoading.showToast(text);
  }
}
