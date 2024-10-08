import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homerental/core/my_pref.dart';
import 'package:homerental/core/size_config.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/models/category_model.dart';
import 'package:homerental/models/rental_model.dart';
import 'package:homerental/pages/detail_rental.dart';
import 'package:homerental/pages/nearby_map.dart';
import 'package:homerental/theme.dart';
import 'package:homerental/widgets/icon_back.dart';
import 'package:homerental/widgets/info_square.dart';

class ByCategory extends StatelessWidget {
  final CategoryModel? categoryModel;
  final List<RentalModel>? rentals;
  final String? title;
  ByCategory({this.categoryModel, this.rentals, this.title}) {
    int duration = 1500;
    if (rentals != null && rentals!.length > 0) {
      duration = 0;
    }
    Future.delayed(Duration(milliseconds: duration), () {
      final XController x = XController.to;
      if (x.itemPass.value.result != null) {
        datas.value = x.itemPass.value.rents!;
        temps.value = x.itemPass.value.rents!;
      } else if (rentals != null && rentals!.length > 0) {
        datas.value = rentals!;
        temps.value = rentals!;
      } else {
        //try to push one more time
        if (categoryModel!.id != null) {
          Future.microtask(() => x.getRentByCategory("${categoryModel!.id!}"));
          Future.delayed(Duration(milliseconds: duration), () {
            if (x.itemPass.value.result != null) {
              datas.value = x.itemPass.value.rents!;
              temps.value = x.itemPass.value.rents!;
            }
          });
        }
      }

      isLoading.value = false;
    });
  }

  final datas = <RentalModel>[].obs;
  final temps = <RentalModel>[].obs;
  final isLoading = true.obs;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    final MyPref myPref = MyPref.to;

    return Container(
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
          title: topIcon(x),
          elevation: 0.1,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getProportionateScreenHeight(5)),
              Obx(
                () => !isLoading.value && temps.length > 0
                    ? inputSearch(x)
                    : SizedBox.shrink(),
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Obx(() => isLoading.value
                          ? MyTheme.loadingCircular()
                          : datas.length < 1
                              ? noDataFound()
                              : listRents(datas, myPref)),
                      SizedBox(height: getProportionateScreenHeight(55)),
                      SizedBox(height: getProportionateScreenHeight(155)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget noDataFound() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: Get.width / 1.2,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              child: Image.asset(
                "assets/nodata_found.png",
                height: Get.height / 3,
              ),
            ),
            Text("No data found!",
                style: TextStyle(color: Get.theme.primaryColor)),
          ],
        ),
      ),
    );
  }

  Widget listRents(final List<RentalModel> rentals, final MyPref myPref) {
    final double thisWidth = Get.width;
    return Container(
      width: Get.width,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: rentals.map((e) {
          return InkWell(
            onTap: () {
              Get.to(DetailRental(rental: e));
            },
            child: Container(
              width: thisWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: colorBoxShadow,
                    blurRadius: 1.0,
                    offset: Offset(1, 1),
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ExtendedImage.network(
                        "${e.image}",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        cache: true,
                      ),
                    ),
                  ),
                  Container(
                    width: GetPlatform.isAndroid
                        ? thisWidth / 1.65
                        : thisWidth / 1.55,
                    padding:
                        EdgeInsets.only(top: 10, left: 0, right: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: thisWidth / 2.8,
                                child: Text(
                                  "${e.title}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      height: 1.1,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Text(
                                "${myPref.pCurrency.val} ${e.price}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          //width: Get.width / 1.90,
                          color: Colors.transparent,
                          margin: EdgeInsets.only(bottom: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(MaterialIcons.location_pin,
                                      color: Colors.black45, size: 14),
                                  SizedBox(width: 5),
                                  Text(
                                    "${e.address}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black45),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Row(
                                  children: [
                                    Icon(MaterialIcons.star,
                                        color: Colors.amber, size: 12),
                                    SizedBox(width: 1),
                                    Text(
                                      "${e.rating}",
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: InfoSquare(
                            rental: e,
                            iconSize: 12,
                            spaceWidth: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  final TextEditingController _query = new TextEditingController();
  Widget inputSearch(final XController x) {
    _query.text = '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
          controller: _query,
          onChanged: (String? text) {
            final List<RentalModel> latests = x.itemPass.value.rents!;
            if (text!.isNotEmpty &&
                text.trim().length > 0 &&
                latests.length > 0) {
              var models = latests.where((RentalModel element) {
                return element.title!
                    .toLowerCase()
                    .contains(text.trim().toLowerCase());
              }).toList();

              if (models.length > 0) {
                datas.value = models;
              } else {
                datas.value = [];
              }
            } else {
              datas.value = temps;
            }
          },
          style: TextStyle(fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(
              FontAwesome.search,
              size: 14,
              color: Get.theme.backgroundColor,
            ),
            border: InputBorder.none,
            hintText: "type_keyword".tr,
            suffixIcon: InkWell(
              onTap: () {
                _query.text = '';
                datas.value = temps;
              },
              child: Icon(
                FontAwesome.remove,
                size: 14,
                color: Get.theme.backgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget topIcon(final XController x) {
    return Container(
      padding: EdgeInsets.only(top: 10),
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
              "${this.title ?? categoryModel!.title}",
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
              onTap: () async {
                final ImageConfiguration imageConfiguration =
                    createLocalImageConfiguration(Get.context!,
                        size: Size.square(48));
                final _markerIcon = await BitmapDescriptor.fromAssetImage(
                    imageConfiguration, 'assets/icon_marker.png');
                Get.to(NearbyMap(
                    rentals: x.itemHome.value.nearbys!,
                    markerIcon: _markerIcon));
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
                    FontAwesome.map_marker,
                    size: 16,
                    color: Get.theme.accentColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
