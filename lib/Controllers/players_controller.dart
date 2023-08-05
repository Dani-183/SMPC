import 'package:get/get.dart';
import 'package:smpc/Models/player_model.dart';

import '../Constants/constants.dart';
import '../Services/services.dart';
import 'controllers.dart';

class PlayersController extends GetxController {
  Rxn<List<PlayerModel>> playersData = Rxn<List<PlayerModel>>();
  List<PlayerModel>? get players => playersData.value;

  @override
  void onInit() {
    if (isSignedIn.value) {
      String? collegeId = Get.find<AdminController>().admin?.uid;
      if (collegeId != null) {
        playersData.bindStream(DBServices().streamPlayers(collegeId));
      }
    }
    super.onInit();
  }
}
