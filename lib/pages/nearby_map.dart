import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:homerental/core/my_pref.dart';
import 'package:homerental/core/xcontroller.dart';
import 'package:homerental/models/rental_model.dart';
import 'package:homerental/pages/detail_rental.dart';
import 'package:homerental/screens/home_screen.dart';
import 'package:homerental/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyMap extends StatelessWidget {
  final List<RentalModel> rentals;
  final BitmapDescriptor? markerIcon;
  final XController x = XController.to;
  final myPref = MyPref.to;

  NearbyMap({required this.rentals, this.markerIcon}) {
    if (this.rentals.length > 1 && this.rentals[0].distance != 0) {
      this.rentals.sort((a, b) => a.distance!.compareTo(b.distance!));
    }
    items.value = this.rentals;

    this.rentals.forEach((RentalModel rental) {
      final String markerIdVal = 'marker_id_$_markerIdCounter';
      _markerIdCounter.value++;
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        position: MyTheme.createLatLngFromString(rental.latitude!),
        icon: this.markerIcon!,
        infoWindow: InfoWindow(
            title: "${rental.title!}",
            snippet: "${rental.description!}",
            onTap: () {
              Get.to(DetailRental(rental: rental));
            }),
        onTap: () {
          //_onMarkerTapped(markerId);
        },
        //onDragEnd: (LatLng position) {
        //  _onMarkerDragEnd(markerId, position);
        //},
      );

      markers[markerId] = marker;
    });
  }

  final _markerIdCounter = 1.obs;
  static final items = <RentalModel>[].obs;
  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _firstRental = CameraPosition(
    target: MyTheme.createLatLngFromString(items[0].latitude!),
    zoom: 9.10,
  );

  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _firstRental,
              zoomControlsEnabled: true,
              markers: Set<Marker>.of(markers.values),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              top: Get.mediaQuery.padding.top,
              left: 0,
              child: InkWell(
                onTap: () {
                  print("clicked here...");
                },
                child: Column(
                  children: [
                    dropDownSearch()
                    //inputSearch(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: Get.mediaQuery.padding.bottom,
              left: 0,
              child: Container(
                width: Get.width,
                child: HomeScreen.listNearbyMap(
                  myPref,
                  rentals,
                  (index) {
                    goToRental(rentals[index]);
                    //Get.to(DetailRental(rental: rentals[index]),
                    //    transition: Transition.cupertinoDialog);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDownSearch() {
    List<String> items = [];
    rentals.forEach((element) {
      items.add(element.title!);
    });
    return Container(
      width: Get.width / 1.1,
      height: 50,
      alignment: FractionalOffset.center,
      margin: EdgeInsets.only(top: 10, left: 22, right: 22),
      padding: EdgeInsets.only(left: 15, right: 10, top: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Get.theme.canvasColor,
            Get.theme.canvasColor.withOpacity(.98)
          ],
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              FontAwesome.chevron_left,
              size: 14,
              color: Get.theme.backgroundColor,
            ),
          ),
          Expanded(
            child: DropdownSearch<String>(
              validator: (v) => v == null ? "required field" : null,
              hint: "Choose One",
              mode: Mode.MENU,
              popupBackgroundColor: Get.theme.canvasColor,
              dropdownSearchDecoration: InputDecoration(
                filled: true,
                fillColor: Get.theme.canvasColor,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Get.theme.canvasColor),
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              popupShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              showAsSuffixIcons: true,
              clearButtonBuilder: (_) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesome.remove,
                  size: 18,
                  color: Get.theme.backgroundColor,
                ),
              ),
              dropdownButtonBuilder: (_) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesome.chevron_down,
                  size: 14,
                  color: Get.theme.backgroundColor,
                ),
              ),
              popupItemBuilder:
                  (BuildContext context, String item, bool isSelected) =>
                      MediaQuery.removePadding(
                removeLeft: true,
                removeTop: true,
                removeBottom: true,
                context: context,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Row(
                    children: [
                      spaceWidth15,
                      Text("$item"),
                    ],
                  ),
                ),
              ),
              showSelectedItem: true,
              items: items,
              //label: "Menu mode *",
              showClearButton: true,
              onChanged: (text) {
                var rental =
                    rentals.firstWhere((element) => element.title == text);
                goToRental(rental);
              },
              //popupItemDisabled: (String s) => s.startsWith('I'),
              //selectedItem: "Tunisia",
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _query = new TextEditingController();
  Widget inputSearch() {
    final List<RentalModel> nearbys = x.itemHome.value.nearbys!;
    _query.text = '';

    return Container(
      width: Get.width / 1.1,
      alignment: FractionalOffset.center,
      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
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
              var models = nearbys.where((RentalModel element) {
                return element.title!
                    .toLowerCase()
                    .contains(text.trim().toLowerCase());
              }).toList();

              if (models.length > 0) {
                items.value = models;
              }
            } else {
              items.value = nearbys;
            }
          },
          style: TextStyle(fontSize: 15),
          textInputAction: TextInputAction.search,
          onSubmitted: (String? text) {
            if (text!.isNotEmpty) {}
          },
          decoration: InputDecoration(
            prefixIcon: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                FontAwesome.chevron_left,
                size: 14,
                color: Get.theme.backgroundColor,
              ),
            ),
            border: InputBorder.none,
            hintText: "type_keyword".tr,
            suffixIcon: InkWell(
              onTap: () {
                _query.text = '';
                items.value = nearbys;
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

  Future<void> goToRental(final RentalModel rental) async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition _lat = CameraPosition(
      target: MyTheme.createLatLngFromString(rental.latitude!),
      zoom: 14.12,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_lat));
  }
}
