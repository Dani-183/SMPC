import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Constants/colors.dart';
import 'package:smpc/Controllers/admin_gallery_controller.dart';
import 'package:smpc/Views/Gallery/add_new_image.dart';
import 'package:smpc/Views/Gallery/admin_full_view_image.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

class MyGalleryView extends StatelessWidget {
  MyGalleryView({Key? key}) : super(key: key);
  final AdminGalleryController galleryController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AddNewImage());
            },
            icon: const Icon(Icons.add_a_photo_rounded, color: kMainColor),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(() {
          if (galleryController.gallery == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (galleryController.gallery!.isNotEmpty) {
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: galleryController.gallery!.length,
              itemBuilder: ((context, index) => GestureDetector(
                    onTap: () => Get.to(() => AdminFullViewImage(
                          gallery: galleryController.gallery![index],
                        )),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: NetImage(imagePath: galleryController.gallery![index].imageUrl!),
                    ),
                  )),
            );
          } else {
            return const Center(
              child: Text('There are no images'),
            );
          }
        }),
      ),
    );
  }
}
