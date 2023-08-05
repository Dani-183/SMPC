import 'package:get/get.dart';
import 'package:smpc/Models/gallery_model.dart';
import 'package:smpc/Services/db_services.dart';

class AdminGalleryController extends GetxController {
  Rxn<List<GalleryModel>> galleryData = Rxn<List<GalleryModel>>();
  List<GalleryModel>? get gallery => galleryData.value;

  @override
  void onInit() {
    galleryData.bindStream(DBServices().streamAdminGallery());
    super.onInit();
  }
}
