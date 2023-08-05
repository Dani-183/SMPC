import 'package:get/get.dart';

import '../Controllers/players_controller.dart';

class PlayersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlayersController()).onInit();
  }
}
