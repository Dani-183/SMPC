import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';

final OutlineInputBorder outlineInputActiveBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(40), borderSide: const BorderSide(color: kMainColor, width: 2));

final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(40), borderSide: BorderSide(color: kMainColor.withOpacity(0.8), width: 2));

class KTextFieldOutline extends StatelessWidget {
  const KTextFieldOutline({
    Key? key,
    this.lable,
    this.cursorsColor = kMainColor,
    this.isRequired = true,
    this.autoFillHints,
    this.capitalization,
    this.controller,
    this.formatter,
    this.isReadOnly,
    this.maxLines,
    this.obscure,
    this.onChange,
    this.ontap,
    this.onSuffixTap,
    this.textInputType,
    this.validators,
    this.initialValue,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
  }) : super(key: key);

  final String? lable;
  final Iterable<String>? autoFillHints;
  final TextCapitalization? capitalization;
  final List<TextInputFormatter>? formatter;
  final bool? obscure, isReadOnly;
  final bool isRequired;
  final String? Function(String?)? validators;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final Color cursorsColor;
  final Function(String)? onChange;
  final int? maxLines;
  final Function()? ontap, onSuffixTap;
  final String? hintText, initialValue;
  final Widget? suffixIcon, prefixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      autofillHints: autoFillHints,
      textCapitalization: capitalization ?? TextCapitalization.none,
      inputFormatters: formatter,
      obscureText: obscure ?? false,
      readOnly: isReadOnly ?? false,
      validator: validators,
      controller: controller,
      cursorColor: cursorsColor,
      keyboardType: textInputType,
      textAlign: TextAlign.start,
      onChanged: onChange,
      maxLines: maxLines,
      onTap: ontap,
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
      decoration: InputDecoration(
        border: InputBorder.none,
        label: lable == null ? null : Text(lable!),
        // labelStyle: kH5.copyWith(color: kBlackColor),
        hintText: hintText,
        // floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.only(left: 22, right: 20),
        hintStyle: const TextStyle(color: kGreyColor),
        errorStyle: const TextStyle(color: kErrorColor),
        errorBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputActiveBorder,
        prefixIconConstraints: const BoxConstraints(),
        prefixIcon: prefixIcon != null
            ? Padding(padding: const EdgeInsets.only(left: 15.0, right: 6), child: prefixIcon)
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(onPressed: onSuffixTap, icon: suffixIcon!))
            : null,
      ),
    );
  }
}
