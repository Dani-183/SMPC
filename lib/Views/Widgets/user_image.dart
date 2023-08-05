import 'package:flutter/material.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

class UserCircularImage extends StatelessWidget {
  const UserCircularImage({
    Key? key,
    this.radius,
    this.imageURL,
  }) : super(key: key);

  final double? radius;
  final String? imageURL;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: radius,
      child: ClipOval(
          child: NetImage(
              imagePath: imageURL ??
                  'https://firebasestorage.googleapis.com/v0/b/rentlou-957e5.appspot.com/o/User.png?alt=media',
              isUser: true,
              boxfit: BoxFit.cover)),
    );
  }
}
