import 'package:badges/badges.dart';
import 'package:homerental/chat/models/ext_chat_message.dart';
import 'package:homerental/chat/models/userchat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:homerental/chat/widgets/message_row.dart';
import 'package:homerental/chat/widgets/photo_hero.dart';
import 'package:homerental/theme.dart';
import 'package:homerental/widgets/icon_back.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart' as intl;
import 'package:homerental/core/size_config.dart';
import 'package:homerental/core/xcontroller.dart';

class ChatScreen extends StatelessWidget {
  final isActive = true.obs;

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
    SizeConfig().init(context);

    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            mainBackgroundcolor,
            mainBackgroundcolor2,
            mainBackgroundcolor3,
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: mainBackgroundcolor,
          title: topIcon(),
          elevation: 0.1,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: createRowBody(x),
            ),
          ],
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
              "chat".tr,
              style: TextStyle(
                fontSize: 18,
                color: colorTrans2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                MyTheme.showToast('Dummy action...');
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
                    FontAwesome.search,
                    size: 16,
                    color: Get.theme.disabledColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createRowBody(final XController x) {
    return Container(
      height: Get.height,
      child: Obx(
        () => Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: getProportionateScreenHeight(20)),
                child: rowMenus(selectedOpt.value, x)),
            Flexible(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: createListScreen(
                      x,
                      x.userLogin.value.userChatMessages!,
                      x.userLogin.value.userChats!,
                      selectedOpt.value == 0)),
            ),
          ],
        ),
      ),
    );
  }

  final selectedOpt = 0.obs;
  final List<String> catOptions = ["friend".tr, "explore".tr];
  Widget rowMenus(final int selectedOption, final XController x) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: catOptions.map(
                (e) {
                  final index = catOptions.indexOf(e);
                  return InkWell(
                    onTap: () {
                      selectedOpt.value = index;
                      print("index:  ${selectedOpt.value}");
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$e",
                            style: TextStyle(
                                fontSize: (index == selectedOption) ? 15 : 14,
                                color: (index == selectedOption)
                                    ? Colors.black87
                                    : Colors.grey[400],
                                fontWeight: (index == selectedOption)
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                          if (index == selectedOption)
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              color: Get.theme.primaryColor,
                              height: 3,
                              width: 25,
                            )
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget createListScreen(
      final XController x,
      final List<ExtChatMessage>? datas,
      final List<UserChat>? users,
      final bool? isActive) {
    //print(users);

    bool ifEmpty = false;
    if (isActive!) {
      if (datas == null || datas.length < 1) {
        ifEmpty = true;
      }
    } else {
      if (users == null || users.length < 1) {
        ifEmpty = true;
      }
    }

    return ifEmpty
        ? Container(
            child: SizedBox(
              width: Get.width,
              height: Get.height / 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isActive
                      ? Container(
                          width: Get.width / 1.2,
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: colorBoxShadow,
                                blurRadius: 1.0,
                                offset: Offset(1, 1),
                              )
                            ],
                          ),
                          child: Text(
                            "empty_data".tr,
                            style: Get.theme.textTheme.headline6!
                                .copyWith(fontSize: 14),
                          ),
                        )
                      : Container(
                          width: Get.width / 1.2,
                          margin:
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: colorBoxShadow,
                                blurRadius: 1.0,
                                offset: Offset(1, 1),
                              )
                            ],
                          ),
                          child: Text(
                            "empty_data".tr,
                            style: Get.theme.textTheme.headline6!
                                .copyWith(fontSize: 14),
                          ),
                        ),
                  spaceHeight10,
                ],
              ),
            ),
          )
        : ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 0, top: 22),
            children: isActive
                ? createUserMessages(x, datas!)
                : (users == null || users.length < 1)
                    ? [
                        Container(
                            child: Center(child: CircularProgressIndicator()))
                      ]
                    : createUserChats(x, users),
          );
  }

  List<Widget> createUserMessages(
      final XController x, final List<ExtChatMessage> datas) {
    return datas.map((item) {
      return MessageRow(extChat: item);
    }).toList();
  }

  List<Widget> createUserChats(
      final XController x, final List<UserChat>? users) {
    return users!.map((UserChat? userChat) {
      String timeagoo = "";
      String timeChat = "";

      String? photoUrl = "";
      if (userChat != null) {
        if (userChat.photoUrl != null && userChat.photoUrl != '') {
          photoUrl = userChat.photoUrl!;
        }
      }

      int diff = 10000;
      try {
        DateTime dateUpdate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(userChat!.updatedAt!),
        ).toLocal();

        timeagoo = timeago.format(dateUpdate);
        //'KK:mm a'
        timeChat = intl.DateFormat('HH:mm').format(dateUpdate);
        diff = DateTime.now().difference(dateUpdate).inMinutes;
      } catch (e) {}

      return Container(
        margin: EdgeInsets.only(left: 3, right: 3, bottom: 16, top: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(22),
            ),
          ),
          child: ListTile(
            onTap: () {
              clickToChat(x, userChat!);
            },
            contentPadding:
                EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 0),
            leading: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    color: Get.theme.accentColor.withOpacity(0.5),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (photoUrl != null && photoUrl != '') {
                        Get.to(
                          MyTheme.photoView(photoUrl),
                          transition: Transition.zoom,
                        );
                      }
                    },
                    child: (photoUrl.isEmpty || photoUrl == '')
                        ? CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                              "assets/def_profile.png",
                            ),
                          )
                        : Container(
                            width: 50.0,
                            height: 50.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: PhotoHero(
                                photo: photoUrl,
                                //isHero: true,
                                onTap: () {
                                  Get.to(
                                    MyTheme.photoView(photoUrl),
                                    transition: Transition.zoom,
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                ),
                if (diff < 10)
                  Positioned(
                    right: 0,
                    bottom: 5,
                    child: Badge(
                      badgeColor: Colors.lightGreen,
                      position: BadgePosition.topEnd(top: 10, end: 10),
                      badgeContent: null,
                    ),
                  ),
              ],
            ),
            title: Text(
              userChat!.nickname ?? "",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Get.theme.primaryColor,
                  fontSize: 12),
            ),
            subtitle: Text(
              userChat.email ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorGrey),
            ),
            trailing: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeagoo,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey[800], fontSize: 9),
                  ),
                  Text(
                    "$timeChat",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Get.theme.accentColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  clickToChat(final XController x, final UserChat userChat) {
    print("click to chat...");
    print(userChat.toJson());
    x.gotoChatApp(userChat);
  }
}
