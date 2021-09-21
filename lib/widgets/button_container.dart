import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonContainer extends StatelessWidget {
  final String text;
  final VoidCallback? callback;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? sizeText;
  final LinearGradient? linearGradient;
  final BoxShadow? boxShadow;

  ButtonContainer({
    required this.text,
    this.callback,
    this.paddingHorizontal,
    this.paddingVertical,
    this.sizeText,
    this.linearGradient,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: this.paddingHorizontal ?? 0,
          vertical: this.paddingVertical ?? 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          this.boxShadow ??
              BoxShadow(
                color: Get.theme.primaryColor,
                blurRadius: 3.0,
                offset: Offset(1, 2),
              )
        ],
        gradient: this.linearGradient ??
            LinearGradient(
              colors: [
                Get.theme.primaryColor,
                Get.theme.primaryColor.withOpacity(.95),
              ],
            ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$text",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: this.sizeText ?? 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
