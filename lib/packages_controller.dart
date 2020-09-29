import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PackageController extends GetxController {
  TextEditingController phoneNumberInput = TextEditingController();
  final formKey = GlobalKey<FormState>();

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    childDirected: false,
    testDevices: <String>[],
  );
  InterstitialAd myInterstitial;

  @override
  @override
  void onInit() {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-3113752444908190~6099025448');

    myInterstitial = InterstitialAd(
      adUnitId: "ca-app-pub-3113752444908190/8377187508",
      targetingInfo: targetingInfo,
    );
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
  }
}
