import 'package:get/get.dart';

import '../Controllers/controllers.dart';

class InitBindig extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminController()).onInit();
  }
}
