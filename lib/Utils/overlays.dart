import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

import '../constants/constants.dart';

Future<OkCancelResult> errorOverlay(BuildContext context, {String? title, String? message, String? okLabel}) async {
  return await showOkAlertDialog(context: context, title: title, message: message, okLabel: okLabel);
}

Future<dynamic> loadingOverlay(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
          backgroundColor: kTransparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: CircleAvatar(
              radius: 60, backgroundColor: kWhiteColor, child: Lottie.asset('assets/icons/loading.json'))));
}

Future<dynamic> loadingStatusDialog(BuildContext context, {required String title}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
          backgroundColor: kWhiteColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const LoadingWidget(height: 70),
            KText(text: title, fontWeight: FontWeight.bold, fontSize: 16),
            const SizedBox(width: 8)
          ])));
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.height}) : super(key: key);
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/images/loading.json', height: height);
  }
}
