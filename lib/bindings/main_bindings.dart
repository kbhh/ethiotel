import 'package:ethiotel/pkgs_controller.dart';
import 'package:get/get.dart';

import '../home_controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
