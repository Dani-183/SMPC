import 'package:get/get.dart';
import 'package:smpc/Controllers/sports_controller.dart';

class SportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SportsController()).onInit();
  }
}
