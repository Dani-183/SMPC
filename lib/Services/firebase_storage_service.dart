import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> imgageUpload(String path, String image) async {
    try {
      late String imgUrl;
      Reference ref = storage.ref().child(path + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(File(image));
      await uploadTask.whenComplete(() async {
        String imgUrll = (await ref.getDownloadURL()).toString();
        imgUrl = imgUrll;
      });
      return imgUrl;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
