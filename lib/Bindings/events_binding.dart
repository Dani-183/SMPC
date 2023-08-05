import 'package:get/get.dart';

import '../Controllers/controllers.dart';

class MyEventsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyEventsController()).onInit();
  }
}
