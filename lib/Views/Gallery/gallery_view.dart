import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Controllers/gallery_controller.dart';
import 'package:smpc/Views/Gallery/full_view_image.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

import '../../constants/constants.dart';

class GalleryView extends StatelessWidget {
  GalleryView({Key? key}) : super(key: key);
  final GalleryController galleryController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery View'),
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
              itemBuilder: ((context, index) => Hero(
                  tag: galleryController.gallery![index].imageUrl!,
                  child: GestureDetector(
                    onTap: () => Get.to(() => FullViewImage(gallery: galleryController.gallery![index])),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: NetImage(imagePath: galleryController.gallery![index].imageUrl!)),
                  ))),
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
