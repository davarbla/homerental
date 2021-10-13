import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:homerental/app/my_home.dart';
import 'package:homerental/auth/sign_up_screen.dart';
import 'package:homerental/core/firebase_auth_service.dart';
import 'package:homerental/core/size_config.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/main.dart';
import 'package:homerental/theme.dart';
import 'package:homerental/widgets/button_container.dart';
import 'package:homerental/widgets/icon_back.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen() {
    Future.delayed(Duration(milliseconds: 2200), () {
      x.asyncLatitude();
    });
  }

  final XController x = XController.to;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _email.text = '';
    _password.text = '';

    return Container(
      padding: EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainBackgroundcolor,
            mainBackgroundcolor2,
            mainBackgroundcolor3,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        width: Get.width,
        height: Get.height,
        child: SafeArea(
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
              width: Get.width,
              height: Get.height,
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 60, left: 10),
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        "We provide you the best units and the best services.\nInput your credential to Log In",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    spaceHeight20,
                    spaceHeight20,
                    inputEmail(),
                    spaceHeight20,
                    inputPassword(),
                    spaceHeight10,
                    Container(
                      alignment: Alignment.centerRight,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin:
                                EdgeInsets.only(left: 0, right: 0, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Forgot Password",
                                  style: textBold.copyWith(
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                    color: Get.theme.backgroundColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    spaceHeight20,
                    Container(
                      margin: EdgeInsets.only(bottom: 0),
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            print("sign in clicked..");
                            String em = "${textEmail.value}";
                            String ps = "${textPassword.value}";

                            if (em.trim().length < 3 || !GetUtils.isEmail(em)) {
                              MyTheme.showSnackbar("Email invalid!");
                              return;
                            }

                            if (ps.trim().length < 6) {
                              MyTheme.showSnackbar("Password invalid!");
                              return;
                            }

                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            pushLogin(x);
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: ButtonContainer(
                              text: "Log In",
                            ),
                          ),
                        ),
                      ),
                    ),
                    spaceHeight20,
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: fontFamily,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontFamily: fontFamily,
                                      fontSize: 16,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // navigate to desired screen
                                        Get.back();
                                        Future.microtask(() => Get.to(
                                            SignUpScreen(),
                                            transition: Transition.upToDown));
                                      })
                              ]),
                        ),
                      ),
                    ),
                    spaceHeight50,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // email address
  final textEmail = ''.obs;
  final TextEditingController _email = new TextEditingController();
  Widget inputEmail() {
    print("rebuild form inputEmail");
    _email.text = "${textEmail.value}";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Get.theme.canvasColor,
            Get.theme.canvasColor.withOpacity(.98)
          ],
        ),
      ),
      child: Container(
        width: Get.width,
        child: TextFormField(
          controller: _email,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (!GetUtils.isEmail(value!))
              return "Email invalid!";
            else
              return null;
          },
          onChanged: (text) {
            textEmail.value = text;
          },
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(
              FontAwesome.envelope,
              size: 18,
              color: Get.theme.backgroundColor,
            ),
            border: InputBorder.none,
            hintText: "Email",
          ),
        ),
      ),
    );
  }

  // password
  final textPassword = ''.obs;
  final isSecured = true.obs;
  final TextEditingController _password = new TextEditingController();
  Widget inputPassword() {
    print("rebuild form inputPassword");
    _password.text = "${textPassword.value}";
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Get.theme.canvasColor,
            Get.theme.canvasColor.withOpacity(.98)
          ],
        ),
      ),
      child: Container(
        width: Get.width,
        child: Obx(
          () => TextFormField(
            controller: _password,
            onChanged: (text) {
              textPassword.value = text;
            },
            obscureText: isSecured.value,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(
                FontAwesome.key,
                size: 18,
                color: Get.theme.backgroundColor,
              ),
              border: InputBorder.none,
              hintText: "Password",
              suffixIcon: InkWell(
                onTap: () {
                  isSecured.value = !isSecured.value;
                },
                child: Icon(
                  isSecured.value ? FontAwesome.eye : FontAwesome.eye_slash,
                  size: 18,
                  color: Get.theme.backgroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget topIcon() {
    return Container(
      padding: EdgeInsets.only(top: 5),
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
              "Sign In",
              style: TextStyle(
                fontSize: 18,
                color: colorTrans2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Container(
                child: Image.asset(
                  "assets/icon_home220.png",
                  width: 22,
                  height: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pushLogin(final XController x) async {
    EasyLoading.show(status: 'Loading...');

    try {
      String em = "${textEmail.value.trim()}";
      String ps = "${textPassword.value.trim()}";

      FirebaseAuthService _auth = x.notificationFCMManager.firebaseAuthService;
      await _auth.firebaseSignInByEmailPwd(em, ps);

      await Future.delayed(Duration(milliseconds: 1200));

      String? uid = await _auth.getFirebaseUserId();
      if (uid == null) {
        showErrorLogin();
        return;
      }

      var dataPush = jsonEncode({
        "em": "$em",
        "ps": "$ps",
        "is": x.install['id_install'],
        "lat": "${x.latitude}",
        "loc": "${x.location}",
        "cc": "${x.myPref.pCountry.val}",
        "uf": uid,
      });
      print(dataPush);

      final response = await x.provider.pushResponse('api/login', dataPush);
      //print(response);

      if (response != null && response.statusCode == 200) {
        print(response.body);
        dynamic _result = jsonDecode(response.bodyString!);

        if (_result['code'] == '200') {
          dynamic member = _result['result'][0];
          x.doLogin(member);

          await Future.delayed(Duration(milliseconds: 800), () {
            x.asyncHome();
          });

          await Future.delayed(Duration(milliseconds: 2200), () {
            EasyLoading.dismiss();
            Get.offAll(MyHome());
          });
        } else {
          await Future.delayed(Duration(milliseconds: 2200), () async {
            showErrorLogin();
            await Future.delayed(Duration(milliseconds: 3200), () {
              x.notificationFCMManager.firebaseAuthService.signOut();
            });
          });
        }
      } else {
        await Future.delayed(Duration(milliseconds: 3200), () {
          x.notificationFCMManager.firebaseAuthService.signOut();
        });
      }
    } catch (e) {
      print("Error: api/login $e");
    }
  }

  showErrorLogin() {
    EasyLoading.dismiss();

    CoolAlert.show(
      backgroundColor: Get.theme.backgroundColor,
      context: Get.context!,
      type: CoolAlertType.error,
      text: "Your credential login (Email & Password) invalid!",
      //autoCloseDuration: Duration(seconds: 10),
    );
  }
}
