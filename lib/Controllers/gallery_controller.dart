import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smpc/Models/gallery_model.dart';
import 'package:smpc/Services/db_services.dart';

class GalleryController extends GetxController {
  Rxn<List<GalleryModel>> galleryData = Rxn<List<GalleryModel>>();
  List<GalleryModel>? get gallery => galleryData.value;

  @override
  void onInit() {
    galleryData.bindStream(DBServices().streamGallery());
    super.onInit();
  }
}
