import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Constants/colors.dart';
import 'package:smpc/Constants/global_var.dart';
import 'package:smpc/Models/gallery_model.dart';
import 'package:smpc/Services/db_services.dart';
import 'package:smpc/Services/firebase_storage_service.dart';
import 'package:smpc/Utils/utils.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

class AddNewImage extends StatelessWidget {
  AddNewImage({Key? key}) : super(key: key);
  final RxString imagePath = ''.obs;
  final RxBool isValid = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Image'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GestureDetector(
          onTap: () async {
            String? img = await ImagePickerService().imageFromGellery();
            img != null ? imagePath.value = img : null;
            if (imagePath.value != '') {
              isValid.value = true;
            } else {
              isValid.value = false;
            }
          },
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 150),
            decoration: BoxDecoration(color: kGreyColor, borderRadius: BorderRadius.circular(15)),
            child: Obx(
              () => imagePath.value == ''
                  ? const Icon(Icons.add_photo_alternate_outlined)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(imagePath.value),
                      ),
                    ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: KTextHeavyButton(
        isEnable: isValid,
        lable: 'Upload Image',
        height: 47,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        onTap: () async {
          loadingStatusDialog(context, title: 'Uploading Image');
          String? imgUrl = await StorageService().imgageUpload('Gallery/', imagePath.value);
          if (imgUrl != null) {
            GalleryModel galleryModel = GalleryModel(
              imageUrl: imgUrl,
              uploadedAt: DateTime.now(),
              uploadedBy: userID.value,
            );
            await DBServices().createGalleryImage(galleryModel);
            Get.back();
            Get.back();
          }
        },
      )),
    );
  }
}
