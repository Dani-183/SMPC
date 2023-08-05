import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smpc/Constants/colors.dart';
import 'package:smpc/Models/gallery_model.dart';

class FullViewImage extends StatelessWidget {
  const FullViewImage({Key? key, required this.gallery}) : super(key: key);
  final GalleryModel gallery;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 333),
                curve: Curves.fastOutSlowIn,
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4,
                  child: Hero(tag: gallery.imageUrl!, child: CachedNetworkImage(imageUrl: gallery.imageUrl!)),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: MaterialButton(
                padding: const EdgeInsets.all(15),
                elevation: 0,
                color: Colors.black12,
                highlightElevation: 0,
                minWidth: double.minPositive,
                height: double.minPositive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back,
                  color: kBlackColor,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
