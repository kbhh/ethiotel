import 'package:ethiotel/packages_controller.dart';
import 'package:ethiotel/pkgs_controller.dart';
import 'package:get/get.dart';

class PkgsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PkgsController>(() => PkgsController());
    Get.lazyPut<PackageController>(() => PackageController());
  }
}
