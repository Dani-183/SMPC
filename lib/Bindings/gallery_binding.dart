import 'package:get/get.dart';
import 'package:smpc/Controllers/admin_gallery_controller.dart';

class AdminGalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminGalleryController());
  }
}
