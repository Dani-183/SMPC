import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../constants/constants.dart';
import 'k_text.dart';

class KTextHeavyButton extends StatelessWidget {
  const KTextHeavyButton({
    Key? key,
    this.activeColor = kMainColor,
    this.height,
    required this.isEnable,
    required this.lable,
    this.margin,
    this.onTap,
    this.onDisableTap,
    this.padding,
    this.width,
  }) : super(key: key);

  final RxBool isEnable;
  final EdgeInsetsGeometry? margin, padding;
  final double? height, width;
  final String lable;
  final Color activeColor;
  final VoidCallback? onTap, onDisableTap;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: isEnable.value ? onTap : onDisableTap,
        child: Container(
          height: height,
          alignment: Alignment.center,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: isEnable.value ? activeColor : kGreyColor,
          ),
          child: KText(
              text: lable,
              color: isEnable.value ? kWhiteColor : kBlackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class KHeavyButton extends StatelessWidget {
  const KHeavyButton({
    Key? key,
    this.height,
    this.margin,
    this.onTap,
    this.padding,
    this.width,
    this.color,
    this.child,
  }) : super(key: key);

  final EdgeInsetsGeometry? margin, padding;
  final double? height, width;
  final VoidCallback? onTap;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        alignment: Alignment.center,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color,
        ),
        child: child,
      ),
    );
  }
}
