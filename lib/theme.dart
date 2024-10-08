import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homerental/core/my_pref.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/models/rental_model.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class MyTheme {
  static const IS_DEBUG = kDebugMode;
  static const String appName = "FBHomeRental";
  static const String appVersion = "v. 1.0.3";

  static String fcmTopicName = "homerentaltopic";
  static String serverKeyFCM = 'AAAAXQP6aFE:APA91bFwdARD3LVQ7qa1qEg4icatEErrZjuDNlrdoxjtMj1zW24VXUQjiwQu_zdrlAdDVpHhK4gJjRbfmN3umFoCO9Xl4pZMPYT1q3S81j_Z9tsSjKVGFAOlg-_LRuS5ycR4eMuRzw0q';

  static const String webSite = "https://homerental.hobbbies.id/";
  static String urlTermService = "https://homerental.hobbbies.id/";
  static String urlPolicy = 'https://homerental.id/policy.html';

  static String contentToShare =
      "HomeRental - Seamless space booking. \n\nWebsite: https://homerental.id @Copyrights 2021, Erhacorp.ID\n";

  // ----------------- preference box box -------------
  static String prefDarkName = "darkmode";
  static String prefLangName = "langname";
  static String prefFirstTime = "firsttime";
  static String prefLogin = "loginkey";
  static String prefUuid = "uuidkey";
  static String prefInstall = "installkey";

  static String prefLatitude = "latitudekey";
  static String prefLocation = "locationkey";
  static String prefCountry = "countrykey";

  static String prefTokenFCM = "tokenFCMkey";
  static String prefMember = "memberkey";
  static String prefHome = "homekey";
  static String prefMyhobb = "myhobbkey";
  // ----------------- preference box box -------------

  static String noWA = "+6281293812628";

  // file uploaded reference
  static String image1 = "Image";
  static String image2 = "Image2";
  static String image3 = "Image3";

  // max comment on post data view
  static int maxViewComment = 5;
  static int pagePaging = 400; // 100 row per page
  static String pageLimit = "0,400"; // limit paging push

  static const double conerRadius = 28.0;

  static const iconColor = Color(0xffaf9594);

  static InputDecoration inputForm(final String hint, final Color fillColor) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: fillColor,
      focusedBorder: OutlineInputBorder(
        borderSide: new BorderSide(color: Colors.white),
        borderRadius: new BorderRadius.circular(20),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.white),
        borderRadius: new BorderRadius.circular(20),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: new BorderSide(color: Colors.white),
        borderRadius: new BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.all(15),
      border: InputBorder.none,
    );
  }

  static InputDecoration inputFormAccent(
      final String hint, final Color fillColor, final Color accentColor) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: fillColor,
      focusedBorder: OutlineInputBorder(
        borderSide: new BorderSide(color: accentColor),
        borderRadius: new BorderRadius.circular(20),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: new BorderSide(color: accentColor),
        borderRadius: new BorderRadius.circular(20),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: new BorderSide(color: accentColor),
        borderRadius: new BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.all(15),
      border: OutlineInputBorder(
        borderSide: new BorderSide(color: accentColor),
        borderRadius: new BorderRadius.circular(20),
      ),
    );
  }

  static String basename(String path) {
    return path.split('/').last;
  }

  static sendWA(String phone, String text) {
    try {
      if (phone.length < 5) {
        EasyLoading.showToast("Phone Number invalid...");
        return;
      }
      if (phone.substring(0, 1) == '0') {
        phone = "+62" + phone.substring(1);
      }
      print(phone);
      launch("https://api.whatsapp.com/send?phone=$phone&text=$text");
    } catch (e) {}
  }

  static showToast(final String text) {
    EasyLoading.showToast("$text");
  }

  static showSnackbar(final String text) {
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text('$text')));
  }

  static loadingCircular() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  static String formatCounterNumber(final int number) {
    var f = NumberFormat.compact();
    //print(f.format(1230));
    return f.format(number);
  }

  static bool isValidEmail(String email) => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);

  static String numberFormat(int number) {
    final NumberFormat numberFormat =
        NumberFormat.currency(symbol: "", decimalDigits: 0);

    return numberFormat.format(number);
  }

  static String numberFormatDec(double number, int digit) {
    final NumberFormat numberFormat =
        NumberFormat.currency(symbol: "", decimalDigits: digit);

    return numberFormat.format(number);
  }

  static createLatLngFromString(String latitude) {
    var split = latitude.split(",");
    return LatLng(double.parse(split[0]), double.parse(split[1]));
  }

  static int timeStamp(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse("$date");
    return dateTime.toLocal().millisecondsSinceEpoch;
  }

  static DateTime convertDatetime(String date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse("$date");
    return dateTime.toLocal(); //DateTime.now());
  }

  static String formatDateMemberSince(DateTime date) {
    var format = DateFormat("MMM yyyy");
    //DateFormat('yyyy-MM-dd HH:mm:ss')
    return "${format.format(date.toLocal())}"; //DateTime.now());
  }

  static String formatDatePost(DateTime date) {
    final MyPref myPref = MyPref.to;
    var format = DateFormat.yMMMMEEEEd();
    var formatHour =
        myPref.pLang.val == 'id' ? DateFormat('HH:mm') : DateFormat("hh:mm a");
    //DateFormat('yyyy-MM-dd HH:mm:ss')
    return "${format.format(date.toLocal())} ${formatHour.format(date.toLocal())}"; //DateTime.now());
  }

  static Widget photoView(photoUrl) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        brightness: Get.theme.brightness,
        leading: BackButton(
          color: Colors.black87,
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: mainBackgroundcolor,
      ),
      body: Container(
        color: mainBackgroundcolor,
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.topLeft,
        child: PhotoView(
          backgroundDecoration: BoxDecoration(
            color: mainBackgroundcolor,
          ),
          loadingBuilder: (context, event) => Center(
            child: Container(
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(child: CircularProgressIndicator()))),
          ),
          imageProvider: ExtendedNetworkImageProvider(
            '$photoUrl',
          ),
        ),
      ),
    );
  }

  static launchUrlGeo(String _url) async {
    try {
      print(_url);
      await canLaunch(_url)
          ? await launch(_url)
          : throw 'Could not launch $_url';
    } catch (e) {
      print("Error launchUrlGeo $e");
    }
  }
}

logPrint(text) => MyTheme.IS_DEBUG ? print(text) : "";

const myStorageName = "myStorageBox";

const backColor = Color(0xffd4dce4);
const mainBackgroundcolor = Color(0xfff2f2f2);
const mainBackgroundcolor2 = Color(0xfff3f3f3);
const mainBackgroundcolor3 = Color(0xfff8f8f8);

const colorGrey = Color(0xffa2a2a2);
const colorGrey2 = Color(0xffd2d2d2);
const colorTrans1 = Color(0xffb4b6c3);
const colorTrans2 = Color(0xff81828e);

const colorBoxShadow = Color(0xFFF57C7C); //Color(0xffe2e2e2)
const colorBoxShadowGrey = Color(0xFFDDDCDC);

const EdgeInsets padding5 = EdgeInsets.all(5);
const EdgeInsets padding8 = EdgeInsets.all(8);

const TextStyle textBold = TextStyle(fontWeight: FontWeight.bold);
const TextStyle textNormal = TextStyle(fontSize: 14);
const TextStyle textSmall = TextStyle(fontSize: 11);
const TextStyle textSmallGrey = TextStyle(fontSize: 12, color: Colors.grey);

const SizedBox spaceHeight2 = SizedBox(height: 2);
const SizedBox spaceHeight5 = SizedBox(height: 5);
const SizedBox spaceHeight10 = SizedBox(height: 10);
const SizedBox spaceHeight15 = SizedBox(height: 15);
const SizedBox spaceHeight20 = SizedBox(height: 20);
const SizedBox spaceHeight50 = SizedBox(height: 50);

const SizedBox spaceWidth2 = SizedBox(width: 2);
const SizedBox spaceWidth5 = SizedBox(width: 5);
const SizedBox spaceWidth10 = SizedBox(width: 10);
const SizedBox spaceWidth15 = SizedBox(width: 15);
const SizedBox spaceWidth20 = SizedBox(width: 20);
const SizedBox spaceWidth50 = SizedBox(width: 50);

RentalModel findRentalById(final String id) {
  final XController x = XController.to;
  final List<RentalModel> latests = x.itemHome.value.latests!;

  return latests.firstWhere((element) => element.id == id);
}

BoxDecoration boxDecorationGradientHome = BoxDecoration(
  gradient: LinearGradient(
    //begin: Alignment.topCenter,
    //end: Alignment.bottomCenter,
    colors: [
      mainBackgroundcolor,
      mainBackgroundcolor2,
      mainBackgroundcolor3,
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topLeft,
  ),
);
