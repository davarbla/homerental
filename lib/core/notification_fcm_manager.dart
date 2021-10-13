import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:homerental/core/firebase_auth_service.dart';
import 'package:homerental/core/my_pref.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:http/http.dart' as http;

class NotificationFCMManager {
  MyPref? _box = Get.find<MyPref>(); //MyPref box = Get.find<MyPref>();
  MyPref get box => _box!;

  setMyPref(final MyPref box) {
    _box = box;
    _firebaseAuthService.setBox(box);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationFCMManager._internal() {
    logPrint("NotificationFCMManager._internal...");
    init();
  }

  static final NotificationFCMManager _instance =
      NotificationFCMManager._internal();
  static NotificationFCMManager get instance => _instance;

  FirebaseAuthService _firebaseAuthService = FirebaseAuthService.instance;
  FirebaseAuthService get firebaseAuthService => _firebaseAuthService;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;

  AndroidNotificationChannel? channel;

  bool _initialized = false;
  static final String iconNotif = "logo_small";
  static final String iconBigNotif = "logo_round";
  static final String idNotif = '${MyTheme.appName}_APP';
  static final String titleNotif = '${MyTheme.appName} Broadcast Message.';
  static final String descNotif = '${MyTheme.appName} Notification Alert.';

  init() async {
    tz.initializeTimeZones();

    if (!kIsWeb && !_initialized) {
      _initialized = true;

      channel = AndroidNotificationChannel(
        idNotif, // id
        titleNotif, // title
        description: descNotif, // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings(iconNotif);
      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );
      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      if (GetPlatform.isAndroid)
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel!);

      if (GetPlatform.isIOS)
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );

      final NotificationSettings settings =
          await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      logPrint('User granted permission: ${settings.authorizationStatus}');

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      if (GetPlatform.isIOS) {
        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
      }
    }

    firebaseMessaging.getInitialMessage().then((RemoteMessage? message) async {
      if (message != null) {
        logPrint("getInitialMessage() FCM..");
        logPrint(message.data);
        if (message.data['post'] != null) {
          Future.delayed(Duration(milliseconds: 1200), () {
            onSelectNotification(jsonEncode(message.data));
          });
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logPrint("onMessage.listenining... get new message");

      RemoteNotification notification = message.notification!;
      Map<String, dynamic> getData = message.data;
      logPrint(getData);

      final XController x = XController.to;
      final getMyPref = x.myPref;
      String? largeIconPath;

      if (notification.title != null && !kIsWeb) {
        try {
          String image = getData['image'] ?? '';
          //logPrint(keyname);
          logPrint(image);
          //logPrint(getPost);

          if (image != '' && GetPlatform.isAndroid) {
            largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
          }

          String getMember = getMyPref.pMember.val;
          logPrint(getMember);
          if (getMember != '') {
            var member = jsonDecode(getMember);
            logPrint(member['fullname']);
          }

          //logPrint(member);

        } catch (e) {
          logPrint("Error: \n $e");
        }

        var androidPlatform = androidPlatformChannelSpecifics;
        if (largeIconPath != null && largeIconPath != '') {
          androidPlatform = AndroidNotificationDetails(
            idNotif,
            titleNotif,
            channelDescription: descNotif,
            importance: Importance.max,
            priority: Priority.high,
            icon: iconNotif,
            largeIcon: FilePathAndroidBitmap(largeIconPath),
          );
        }

        var isLogged = false;

        try {
          isLogged = box.pLogin.val;
        } catch (e) {}

        if (isLogged) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: androidPlatform,
              iOS: IOSNotificationDetails(),
            ),
            payload: jsonEncode(getData),
          );

          Future.microtask(() => XController.to.asyncHome());
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logPrint('A new onMessageOpenedApp event was published!');
      logPrint(message.toString());
      if (message.data['post'] != null) {
        onSelectNotification(jsonEncode(message.data));
      }
      //Navigator.pushNamed(context, '/message',
      //    arguments: MessageArguments(message, true));
    });

    //vapidKey: 'BGpdLRsMJKvFDD9odfPk92uBg-JbQbyoiZdah0XlUyrjG4SDgUsE1iC_kdRgt4Kn0CO7K3RTswPZt61NNuO0XoA'
    firebaseMessaging
        .getToken(vapidKey: MyTheme.serverKeyFCM)
        .then((String? token) {
      logPrint("get token FCM $token");
      XController.to.saveTokenFCM(token!);
    });

    firebaseMessaging.onTokenRefresh.listen((String? newtoken) {
      logPrint("get listen token FCM $newtoken");
      XController.to.saveTokenFCM(newtoken!);
    });

    //subscribe topics

    subscribeFCMTopic(MyTheme.fcmTopicName);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  subscribeFCMTopic(String? topic) async {
    await firebaseMessaging.subscribeToTopic(topic!);
  }

  unSubcribeFCMTopic(String? topic) async {
    await firebaseMessaging.unsubscribeFromTopic(topic!);
  }

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  Future onSelectNotification(String? payload) async {
    var isLogged = false;

    try {
      isLogged = box.pLogin.val;
    } catch (e) {}

    if (isLogged) {
      if (payload != null) {
        //debugPrint('notification payload: $payload');
        try {
          Map<String, dynamic> _payload = jsonDecode(payload);
          //logPrint(_payload);
          if (_payload['post'] != null) {
            Map<String, dynamic> postData = jsonDecode(_payload['post']);
            logPrint(postData['id_post']);
            //logPrint(postData);
          }
        } catch (e) {
          logPrint("Error: parsing: $e");
        }
      }
    }
  }

  final int thisIDNotif = 0;
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    idNotif,
    titleNotif,
    channelDescription: descNotif,
    importance: Importance.max,
    priority: Priority.high,
    icon: iconNotif,
    largeIcon: DrawableResourceAndroidBitmap(iconBigNotif),
  );

  showNotif(String title, String body, String payload) async {
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
        thisIDNotif, '$title', '$body', platformChannelSpecifics,
        payload: payload);
  }
}
