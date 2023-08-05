import 'package:get/get.dart';
import 'package:smpc/Models/team_model.dart';

import '../Services/services.dart';
import 'controllers.dart';

class TeamsController extends GetxController {
  Rxn<List<TeamModel>> teamsData = Rxn<List<TeamModel>>();
  List<TeamModel>? get teams => teamsData.value;

  @override
  void onInit() {
    String? collegeId = Get.find<AdminController>().admin?.uid;
    if (collegeId != null) {
      teamsData.bindStream(DBServices().streamTeams(collegeId));
    }
    super.onInit();
  }
}
