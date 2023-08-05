import 'package:get/get.dart';
import 'package:smpc/Constants/global_var.dart';
import 'package:smpc/Controllers/admin_controller.dart';
import 'package:smpc/Models/sports_model.dart';
import 'package:smpc/Services/db_services.dart';

class SportsController extends GetxController {
  Rxn<List<SportsModel>> sportsData = Rxn<List<SportsModel>>();
  List<SportsModel>? get sports => sportsData.value;

  @override
  void onInit() {
    if (isSignedIn.value) {
      String? collegeId = Get.find<AdminController>().admin?.uid;
      if (collegeId != null) {
        sportsData.bindStream(DBServices().streamSports(collegeId));
      }
    }
    super.onInit();
  }
}
