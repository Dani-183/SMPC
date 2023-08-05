import 'package:get/get.dart';
import 'package:smpc/Constants/global_var.dart';
import 'package:smpc/Models/admin_model.dart';
import 'package:smpc/Services/db_services.dart';

class AdminController extends GetxController {
  Rxn<AdminModel> adminData = Rxn<AdminModel>();
  AdminModel? get admin => adminData.value;

  @override
  void onInit() {
    if (isSignedIn.value) {
      adminData.bindStream(Stream.fromFuture(DBServices().getAdmin(userID.value)));
    }
    super.onInit();
  }
}
