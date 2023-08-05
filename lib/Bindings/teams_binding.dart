import 'package:get/get.dart';

import '../Controllers/controllers.dart';

class TeamsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SportsController());
    Get.lazyPut(() => PlayersController());
    Get.lazyPut(() => TeamsController());
  }
}
