import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:homerental/app/my_home.dart';
import 'package:homerental/core/size_config.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/theme.dart';
import 'package:homerental/widgets/counting_down.dart';

class SuccessSignup extends StatelessWidget {
  final isProcess = true.obs;
  final bool usingPhone;
  SuccessSignup({required this.usingPhone});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.topCenter,
                  child: TextButton(
                    onPressed: () {},
                    child: Obx(
                      () => Text(
                        isProcess.value
                            ? 'Loading...'
                            : 'Signing Up Successfull!',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: Get.height / 1.3,
                  color: Colors.transparent,
                  child: Container(
                    width: Get.width / 1.1,
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => isProcess.value
                              ? progressTimer()
                              : Container(
                                  child: SizedBox(
                                    width: getProportionateScreenWidth(180),
                                    height: getProportionateScreenWidth(180),
                                    child: Image.asset(
                                        "assets/sign-for-success.gif"),
                                  ),
                                ),
                        ),
                        spaceHeight10,
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            usingPhone
                                ? "Now you can login/sign-in with your Phone Number"
                                : "Already sent to your email for verification, click link in your body email to procced registration successfully...",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => isProcess.value
                      ? SizedBox.shrink()
                      : Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20, bottom: 0),
                              child: FloatingActionButton(
                                child: Icon(
                                  Feather.arrow_right,
                                ),
                                onPressed: () {
                                  EasyLoading.showToast(
                                      "Welcome ${x.member['fullname']}");
                                  Get.offAll(MyHome());
                                },
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget progressTimer() {
    return Container(
      alignment: Alignment.center,
      width: Get.width,
      height: getProportionateScreenHeight(180),
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 15),
      child: Container(
        width: Get.width / 1.3,
        alignment: Alignment.center,
        child: CountDownTimer(
          height: getProportionateScreenHeight(180),
          seconds: 9,
          callback: () {
            print("callback...");
            isProcess.value = false;
          },
        ),
      ),
    );
  }
}
