import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loading {
  static Widget type1() => Container(
        width: 25,
        height: 25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 19, height: 19, child: CircularProgressIndicator())
          ],
        ),
      );

  static Widget type2() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Get.theme.accentColor),
              ),
            ),
          ],
        ),
      );

  static Widget type3() => Container(
        width: 30,
        height: 30,
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            valueColor:
                new AlwaysStoppedAnimation<Color>(Get.theme.accentColor),
          ),
        ),
      );
}
