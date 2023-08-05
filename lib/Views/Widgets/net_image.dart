import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/constants.dart';

class NetImage extends StatelessWidget {
  const NetImage({Key? key, required this.imagePath, this.boxfit, this.isUser = false}) : super(key: key);

  final String imagePath;
  final BoxFit? boxfit;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      fit: boxfit ?? BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: SizedBox(
          height: 300,
          child: Shimmer.fromColors(
            baseColor: kGreyColor.withOpacity(0.1),
            highlightColor: kWhiteColor,
            child: Container(color: kWhiteColor, height: double.infinity, width: double.infinity),
          ),
        ),
      ),
      errorWidget: (context, url, error) => isUser
          ? Image.asset(
              'assets/images/User.png',
            )
          : const Icon(Icons.image_not_supported_rounded),
    );
  }
}

class ListTileNetImage extends StatelessWidget {
  const ListTileNetImage({Key? key, required this.imageURL, this.dimension}) : super(key: key);
  final String imageURL;
  final double? dimension;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension ?? 60,
      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: NetImage(imagePath: imageURL)),
    );
  }
}
