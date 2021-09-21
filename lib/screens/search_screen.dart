import 'package:dropdown_search/dropdown_search.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homerental/core/my_pref.dart';
import 'package:homerental/core/size_config.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/models/rental_model.dart';
import 'package:homerental/pages/detail_rental.dart';
import 'package:homerental/pages/nearby_map.dart';
import 'package:homerental/theme.dart';
import 'package:homerental/widgets/icon_back.dart';
import 'package:homerental/widgets/info_square.dart';

class SearchScreen extends StatelessWidget {
  final XController x = XController.to;
  final MyPref myPref = MyPref.to;

  SearchScreen() {
    datas.value = x.itemHome.value.nearbys ?? [];
  }

  final datas = <RentalModel>[].obs;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(5)),
            inputSearch(),
            SizedBox(height: getProportionateScreenHeight(15)),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(10)),
                    Obx(() => listSearchs(datas)),
                    SizedBox(height: getProportionateScreenHeight(55)),
                    SizedBox(height: getProportionateScreenHeight(155)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listSearchs(final List<RentalModel> rentals) {
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

  Widget createListDropdown() {
    final List<RentalModel> latests = x.itemHome.value.latests!;
    return DropdownSearch<RentalModel>(
      label: "Name",
      itemAsString: (RentalModel? u) => u!.title!,
      onFind: (String? filter) async {
        var models = latests.where((RentalModel element) {
          return element.title!
              .toLowerCase()
              .contains(filter!.trim().toLowerCase());
        }).toList();
        return models;
      },
      onChanged: (RentalModel? data) {
        print(data);
      },
    );
  }

  final TextEditingController _query = new TextEditingController();
  Widget inputSearch() {
    final List<RentalModel> latests = x.itemHome.value.latests!;
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
        child: TextField(
          controller: _query,
          onChanged: (String? text) {
            if (text!.isNotEmpty && text.length > 0) {
              var models = latests.where((RentalModel element) {
                return element.title!
                    .toLowerCase()
                    .contains(text.trim().toLowerCase());
              }).toList();

              if (models.length > 0) {
                datas.value = models;
              }
            } else {
              datas.value = latests;
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
                datas.value = latests;
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
              "search".tr,
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

                List<RentalModel> rentals = x.itemHome.value.nearbys!;

                if (rentals.length > 1 && rentals[0].distance != 0) {
                  rentals.sort((a, b) => a.distance!.compareTo(b.distance!));
                }
                Get.to(NearbyMap(rentals: rentals, markerIcon: _markerIcon));
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
