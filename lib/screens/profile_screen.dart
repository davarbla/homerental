import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:homerental/auth/intro_screen.dart';
import 'package:homerental/core/my_pref.dart';
import 'package:homerental/core/size_config.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/models/user_model.dart';
import 'package:homerental/pages/feedback_page.dart';
import 'package:homerental/pages/webview_page.dart';
import 'package:homerental/theme.dart';
import 'package:homerental/widgets/action_menu.dart';
import 'package:homerental/widgets/icon_back.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  final XController x = XController.to;
  final MyPref myPref = MyPref.to;

  ProfileScreen() {
    updateUser.value = x.thisUser.value;
  }

  final updateUser = UserModel().obs;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: mainBackgroundcolor,
        title: topIcon(),
        elevation: 0.1,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getProportionateScreenHeight(25)),
              Container(
                alignment: Alignment.center,
                child: Obx(
                  () => profileIcon(updateUser.value),
                ),
              ),
              spaceHeight15,
              Obx(
                () => displayUserProfile(updateUser.value),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),
              listActions(),
              SizedBox(height: getProportionateScreenHeight(55)),
              SizedBox(height: getProportionateScreenHeight(155)),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayUserProfile(final UserModel thisUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            "${thisUser.fullname}",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text("${thisUser.email}", style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  final List<dynamic> actions = [
    {"title": "change_fullname".tr, "icon": Icon(Feather.user)},
    {"title": "change_password".tr, "icon": Icon(Feather.key)},
    {"title": "setting".tr, "icon": Icon(Feather.settings)},
    {"title": "help_center".tr, "icon": Icon(Feather.alert_circle)},
    {"title": "Log Out", "icon": Icon(Feather.log_out)},
  ];

  Widget listActions() {
    return Container(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: actions.map((e) {
          final int index = actions.indexOf(e);
          return ActionMenu(
              text: e['title'],
              icon: e['icon'],
              press: () {
                clickAction(index);
              });
        }).toList(),
      ),
    );
  }

  clickAction(final int index) {
    if (index >= actions.length - 1) {
      CoolAlert.show(
          context: Get.context!,
          backgroundColor: Get.theme.canvasColor,
          type: CoolAlertType.confirm,
          text: 'Do you want to logout',
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () async {
            Get.back();
            x.setIndexBar(0);
            EasyLoading.show(status: 'Loading...');
            await Future.delayed(Duration(milliseconds: 2200));

            x.doLogout();

            Future.delayed(Duration(milliseconds: 1000), () {
              EasyLoading.dismiss();
              Get.offAll(IntroScreen());
            });
          });
    } else if (index == 0) {
      showDialogOptionChangeFullname(XController.to, updateUser.value);
    } else if (index == 1) {
      showDialogOptionChangePassword(XController.to, updateUser.value);
    } else if (index == 2) {
      showDialogSetting();
    } else if (index == 3) {
      Get.to(WebViewPage(url: 'https://erhacorp.id/'),
          transition: Transition.fadeIn);
    }
  }

  Widget profileIcon(final UserModel thisUser) {
    return Container(
      height: getProportionateScreenHeight(115),
      width: getProportionateScreenWidth(115),
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.all(0),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: ExtendedNetworkImageProvider(
                  "${thisUser.image}",
                  cache: true,
                ),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -5,
            child: SizedBox(
              height: 44,
              width: 44,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Get.theme.backgroundColor.withOpacity(.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    //side: BorderSide(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  print("onclick add photo");
                  showDialogOptionImage();
                },
                child: Icon(
                  Icons.add_a_photo,
                  color: Get.theme.canvasColor,
                  size: 22,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget topIcon() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 0),
            child: IconBack(callback: () {
              x.setIndexBar(0);
            }),
          ),
          Container(
            padding: EdgeInsets.only(top: 0),
            child: Text(
              "profile".tr,
              style: TextStyle(
                fontSize: 18,
                color: colorTrans2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(FeedbackPage(), transition: Transition.fade);
            },
            child: Padding(
              padding: EdgeInsets.only(top: 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorGrey2,
                    style: BorderStyle.solid,
                    width: 0.8,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Icon(
                  FontAwesome.edit,
                  size: 16,
                  color: Get.theme.accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // option change photo
  final picker = ImagePicker();
  final pathImage = ''.obs;
  pickImageSource(int tipe) {
    Future<XFile?> file;

    file = picker.pickImage(
        source: tipe == 1 ? ImageSource.gallery : ImageSource.camera);
    file.then((XFile? pickFile) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (pickFile != null) {
          //startUpload();

          pathImage.value = pickFile.path;
          _cropImage(File(pathImage.value));
        }
      });
    });
  }

  Future<Null> _cropImage(File imageFile) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: GetPlatform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Get.theme.accentColor,
            initAspectRatio: CropAspectRatioPreset
                .ratio3x2, //CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      File tmpFile = croppedFile;
      String base64Image = base64Encode(tmpFile.readAsBytesSync());
      String fileName = MyTheme.basename(tmpFile.path);
      Future.microtask(() {
        upload(fileName, base64Image);
      });
    } else {
      File tmpFile = imageFile;
      String base64Image = base64Encode(tmpFile.readAsBytesSync());
      String fileName = MyTheme.basename(tmpFile.path);
      Future.microtask(() {
        upload(fileName, base64Image);
      });
    }
  }

  upload(String fileName, String base64Image) async {
    EasyLoading.show(status: "Loading...");

    String? idUser = updateUser.value.id;

    if (idUser == null && idUser == '') {
      return;
    }

    var dataPush = jsonEncode({
      "filename": fileName,
      "id": idUser,
      "image": base64Image,
      "lat": "${x.latitude}",
      "loc": "${x.location}",
    });

    //print(dataPush);
    var path = "upload/upload_image_user";
    //print(link);

    x.provider.pushResponse(path, dataPush)!.then((result) {
      //print(result.body);
      dynamic _result = jsonDecode(result.bodyString!);
      //print(_result);

      //EasyLoading.dismiss();
      if (_result['code'] == '200') {
        EasyLoading.showSuccess("Process success...");
        String fileUploaded = "${_result['result']['file']}";
        print(fileUploaded);

        x.getUserById();
        Future.delayed(Duration(seconds: 2), () {
          updateUser.value = x.thisUser.value;
        });
        Future.delayed(Duration(seconds: 4), () {
          Future.microtask(() {
            x.asyncHome();
          });
          Get.back();
        });
      } else {
        EasyLoading.showError("Process failed...");
      }
    }).catchError((error) {
      print(error);
      EasyLoading.dismiss();
    });
  }

  showDialogOptionImage() {
    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 2.5,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          //color: MyTheme.mainBackgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
          gradient: LinearGradient(
            colors: [
              mainBackgroundcolor,
              mainBackgroundcolor2,
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.only(top: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: EdgeInsets.only(top: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          padding: EdgeInsets.only(top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Pick One",
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              pickImageSource(0);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Camera",
                                  )
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () {
                              Get.back();
                              pickImageSource(1);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Get.theme.accentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gallery",
                                    style: textBold.copyWith(
                                      color: Get.theme.canvasColor,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceHeight20,
                      spaceHeight20,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Feather.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showDialogSetting() {
    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 2.5,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
          gradient: LinearGradient(
            colors: [
              mainBackgroundcolor,
              mainBackgroundcolor2,
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.only(top: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: EdgeInsets.only(top: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          padding: EdgeInsets.only(top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "language".tr,
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              updateLanguageSetting(x, 'en');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "English",
                                  )
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () {
                              Get.back();
                              updateLanguageSetting(x, 'id');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Get.theme.accentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Indonesia",
                                    style: textBold.copyWith(
                                      color: Get.theme.canvasColor,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceHeight20,
                      spaceHeight20,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Feather.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateLanguageSetting(final XController x, final String lang) async {
    x.myPref.pLang.val = lang;

    await Future.delayed(Duration(milliseconds: 300), () async {
      Locale locale = lang == 'en' ? Locale('en', 'US') : Locale('id', 'ID');
      Get.updateLocale(locale);
    });
  }

  //change fullname
  final TextEditingController _fullname = TextEditingController();
  showDialogOptionChangeFullname(
      final XController x, final UserModel thisUser) {
    _fullname.text = '${thisUser.fullname}';

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 2,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
          gradient: LinearGradient(
            colors: [
              mainBackgroundcolor,
              mainBackgroundcolor2,
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.only(top: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: EdgeInsets.only(top: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          padding: EdgeInsets.only(top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "change_fullname".tr,
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Get.theme.backgroundColor,
                              blurRadius: 1.0,
                              offset: Offset(1, 2),
                            )
                          ],
                        ),
                        child: Container(
                          width: Get.width,
                          child: TextField(
                            controller: _fullname,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Fullname",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight20,
                      spaceHeight10,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "close".tr,
                                  )
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () async {
                              String fn = _fullname.text.trim();
                              if (fn.isEmpty) {
                                MyTheme.showToast('Fullname invalid!');
                                return;
                              }

                              Get.back();
                              EasyLoading.show(status: 'Loading...');
                              x.updateUserById(
                                  'update_about_fullname', 'About Me', fn);
                              await Future.delayed(Duration(milliseconds: 1800),
                                  () {
                                x.getUserById();
                                Future.delayed(Duration(seconds: 2), () {
                                  updateUser.value = x.thisUser.value;
                                });
                              });

                              Future.delayed(Duration(milliseconds: 800), () {
                                EasyLoading.showSuccess('Update successful...');
                                x.asyncHome();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Get.theme.accentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Submit",
                                    style: textBold.copyWith(
                                      color: Get.theme.canvasColor,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceHeight20,
                      spaceHeight20,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Feather.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //change password
  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _newRePass = TextEditingController();
  showDialogOptionChangePassword(
      final XController x, final UserModel thisUser) {
    _oldPass.text = '';
    _newPass.text = '';
    _newRePass.text = '';

    return showCupertinoModalBottomSheet(
      barrierColor: Get.theme.disabledColor.withOpacity(.4),
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height / 1.3,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
          ),
          gradient: LinearGradient(
            colors: [
              mainBackgroundcolor,
              mainBackgroundcolor2,
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.only(top: 15),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        margin: EdgeInsets.only(top: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          padding: EdgeInsets.only(top: 0, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(MyTheme.conerRadius),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "change_password".tr,
                                style: Get.theme.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceHeight20,
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Get.theme.backgroundColor,
                              blurRadius: 1.0,
                              offset: Offset(1, 2),
                            )
                          ],
                        ),
                        child: Container(
                          width: Get.width,
                          child: TextField(
                            controller: _oldPass,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Old Password",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Get.theme.backgroundColor,
                              blurRadius: 1.0,
                              offset: Offset(1, 2),
                            )
                          ],
                        ),
                        child: Container(
                          width: Get.width,
                          child: TextField(
                            controller: _newPass,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "New Password",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [
                              Get.theme.canvasColor,
                              Get.theme.canvasColor.withOpacity(.98)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Get.theme.backgroundColor,
                              blurRadius: 1.0,
                              offset: Offset(1, 2),
                            )
                          ],
                        ),
                        child: Container(
                          width: Get.width,
                          child: TextField(
                            controller: _newRePass,
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Retype New Password",
                            ),
                          ),
                        ),
                      ),
                      spaceHeight20,
                      spaceHeight10,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "close".tr,
                                  )
                                ],
                              ),
                            ),
                          ),
                          spaceWidth10,
                          InkWell(
                            onTap: () async {
                              String op = _oldPass.text.trim();
                              String np = _newPass.text.trim();
                              String rp = _newRePass.text.trim();
                              if (op.isEmpty) {
                                MyTheme.showToast('Old Password invalid!');
                                return;
                              }

                              if (np.isEmpty || np.length < 6) {
                                MyTheme.showToast(
                                    'New Password invalid! Min. 6 alphanumeric');
                                return;
                              }

                              if (rp.isEmpty || rp.length < 6) {
                                MyTheme.showToast(
                                    'Retype New Password invalid! Min. 6 alphanumeric');
                                return;
                              }

                              if (np != rp) {
                                MyTheme.showToast('New Password  not equal');
                                return;
                              }

                              if (op != x.myPref.pPassword.val) {
                                MyTheme.showToast('Old Password  is wrong');
                                return;
                              }

                              Get.back();
                              EasyLoading.show(status: 'Loading...');
                              x.updateUserById('change_password', op, np);
                              await Future.delayed(
                                  Duration(milliseconds: 1800));

                              Future.delayed(Duration(milliseconds: 800), () {
                                EasyLoading.showSuccess('Update successful...');
                                x.setIndexBar(0);
                                x.doLogout();

                                Future.delayed(Duration(milliseconds: 1000),
                                    () {
                                  EasyLoading.dismiss();
                                  Get.offAll(IntroScreen());
                                });
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              margin: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 10),
                              decoration: BoxDecoration(
                                color: Get.theme.accentColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Submit",
                                    style: textBold.copyWith(
                                      color: Get.theme.canvasColor,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceHeight20,
                      spaceHeight20,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                      spaceHeight50,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Feather.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
