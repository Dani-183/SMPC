import 'package:get/get.dart';
import 'package:smpc/Models/models.dart';

import '../Services/db_services.dart';
import 'controllers.dart';

class EventsController extends GetxController {
  Rxn<List<EventModel>> eventsData = Rxn<List<EventModel>>();
  List<EventModel>? get events => eventsData.value;

  @override
  void onInit() {
    eventsData.bindStream(DBServices().streamEvents());
    super.onInit();
  }
}

class MyEventsController extends GetxController {
  Rxn<List<EventModel>> eventsData = Rxn<List<EventModel>>();
  List<EventModel>? get events => eventsData.value;

  @override
  void onInit() {
    String? collegeId = Get.find<AdminController>().admin?.uid;
    if (collegeId != null) {
      eventsData.bindStream(DBServices().streamMyEvents(collegeId));
    }

    super.onInit();
  }
}
