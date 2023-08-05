import 'dart:developer';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> imageFromGellery() async {
    try {
      late String imagePath;
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        // imageQuality: 70,
        // maxHeight: 1500,
        // maxWidth: 1500,
      );
      return image?.path;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String> imageFromCamera() async {
    try {
      late String imagePath;
      final XFile? image =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 50, maxHeight: 1000, maxWidth: 1000);
      imagePath = image!.path;
      return imagePath;
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  // Future<String> multiImageFromGellery() async {
  //   try {
  //     late String imagePath;
  //     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //     imagePath = image!.path;
  //     return imagePath;
  //   } catch (e) {
  //     log(e.toString());
  //     return '';
  //   }
  // }
}
