import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ethiotel/initial_packages.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PkgsController extends GetxController {
  var _pkgsList = [].obs;
  var _errorMessage = "".obs;
  var _isReady = false.obs;

  //pkgs setter
  set setPkgsList(value) => this._pkgsList.value = value;
  get pkgsList => this._pkgsList;

  //error setter
  set setErrorMessage(value) => this._errorMessage.value = value;
  get errorMessage => this._errorMessage.value;

  //isready setter
  set setIsReady(value) => this._isReady.value = value;
  get isReady => this._isReady.value;
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
    initPkgs();
    super.onInit();
  }

  initPkgs() async {
    try {
      await Hive.initFlutter();
      var box = await Hive.openBox('etlbox');
      var etlPkgs = await box.get("etlpkgs");
      if (etlPkgs == null) {
        box.put("etlpkgs", packages_list);
        setPkgsList = packages_list;
      } else {
        // print(this.pkgsList);
        setPkgsList = etlPkgs;
      }
      await Firebase.initializeApp();
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        CollectionReference packages = firestore.collection('packages');
        DocumentSnapshot snap =
            await packages.doc('El582p8hHDHEVYOyLmP5').get();
        if (DateTime.parse(etlPkgs['lastUpdated'])
            .isBefore(DateTime.parse(snap.data()['lastUpdated']))) {
          box.put("etlpkgs", snap.data());
          setPkgsList = snap.data();
        }
        print(snap.data());
      }
      setIsReady = true;
    } catch (e) {
      setErrorMessage = "Cant get available packages";
    }
  }
}
