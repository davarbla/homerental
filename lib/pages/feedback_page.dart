import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/theme.dart';
import 'package:homerental/widgets/icon_back.dart';

class FeedbackPage extends StatelessWidget {
  final TextEditingController _deController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var thisRating = 5.0;
    final XController x = XController.to;

    return Container(
      width: Get.width,
      height: Get.height,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: mainBackgroundcolor,
            title: topIcon(),
            elevation: 0.1,
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            height: Get.height,
            width: Get.width,
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                      "information".tr,
                      textAlign: TextAlign.center,
                      style: Get.theme.textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        //print(rating);
                        thisRating = rating;
                        print(thisRating);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                        controller: _deController,
                        enabled: true,
                        maxLines: 5,
                        maxLength: 150,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'genius_feedback'.tr,
                          hintStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  print("submitted");
                                  String desc = _deController.text;
                                  if (desc.isEmpty) {
                                    EasyLoading.showToast(
                                        "Description invalid...");
                                    return;
                                  }
                                  //Get.back();
                                  EasyLoading.show(status: 'Loading...');
                                  var dataPush = jsonEncode({
                                    "iu": "${x.thisUser.value.id}",
                                    "ds": desc.trim(),
                                    "rt": "$thisRating",
                                  });

                                  print(dataPush);

                                  await x.provider.pushResponse(
                                    "user/feedback",
                                    dataPush,
                                  );

                                  await Future.delayed(
                                      Duration(milliseconds: 1800));
                                  EasyLoading.dismiss();
                                  EasyLoading.showToast("done_thank".tr);
                                  Get.back();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Get.theme.buttonColor
                                            .withOpacity(0.2),
                                        blurRadius: 1.0,
                                        offset: Offset(0.0, 6),
                                      )
                                    ],
                                    color:
                                        Get.theme.accentColor.withOpacity(.8),
                                    //Theme.of(context).bottomAppBarColor,
                                    borderRadius: BorderRadius.circular(42),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 2, right: 5),
                                          child: Icon(Feather.check,
                                              size: 16, color: Colors.white),
                                        ),
                                        Text(
                                          "Submit",
                                          style: Get.theme.textTheme.subtitle2!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  print("submitted");

                                  var phone = "${MyTheme.noWA}";
                                  String text = "Hi ${MyTheme.appName}";

                                  MyTheme.sendWA(phone, text);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Get.theme.buttonColor
                                            .withOpacity(0.2),
                                        blurRadius: 1.0,
                                        offset: Offset(0.0, 6),
                                      )
                                    ],
                                    color: Colors.green[600],
                                    borderRadius: BorderRadius.circular(42),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(horizontal: 15),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 2, right: 5),
                                          child: Icon(Feather.message_circle,
                                              size: 16, color: Colors.white),
                                        ),
                                        Text(
                                          "WhatsApp",
                                          style: Get.theme.textTheme.subtitle2!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget topIcon() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 0),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 0),
            child: IconBack(),
          ),
          Container(
            padding: EdgeInsets.only(top: 0),
            child: Text(
              "feedback".tr,
              style: TextStyle(
                fontSize: 18,
                color: colorTrans2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox.shrink(),
        ],
      ),
    );
  }
}
