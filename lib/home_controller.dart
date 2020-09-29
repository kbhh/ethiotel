import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxString _currentTime = DateFormat.jms('am')
      .format(DateTime.now().add(Duration(hours: 6)))
      .toString()
      .obs;
  TextEditingController cardPattern = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  List<bool> selectedLang = [true, false].obs;

  set setSelectedLang(int index) {
    this.selectedLang[index] = true;
    if (index != 0) {
      this.selectedLang[0] = false;
      Get.updateLocale(Locale("en"));
    } else {
      this.selectedLang[1] = false;
      Get.updateLocale(Locale("am"));
    }
  }

  set setCurrentTime(newTime) => this._currentTime.value = newTime;
  get currentTime => this._currentTime.value;
  TextEditingController phoneNumberInput = TextEditingController();
  TextEditingController amountInput = TextEditingController();

  //ads
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    childDirected: false,
    testDevices: <String>[],
  );
  BannerAd myBanner;
  InterstitialAd myInterstitial;

  @override
  void onInit() {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-3113752444908190~6099025448');
    myBanner = BannerAd(
      adUnitId: "ca-app-pub-3113752444908190/5018712216",
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
    );
    myInterstitial = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
    );

    myBanner
      // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        // anchorOffset: 60.0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        // horizontalCenterOffset: 10.0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );
    this.setCurrentTime = DateFormat.jms('am')
        .format(DateTime.now().add(Duration(hours: 6)))
        .toString();
    Timer.periodic(Duration(seconds: 1), (timer) => setNewTime());

    super.onInit();
  }

  void setNewTime() {
    this.setCurrentTime = DateFormat.jms('am')
        .format(DateTime.now().add(Duration(hours: 6)))
        .toString();
    // update();
  }
}
