import 'package:flutter/material.dart';

class KText extends StatelessWidget {
  const KText({
    Key? key,
    required this.text,
    this.maxLine,
    this.textAlign,
    this.textDirection,
    this.textOverflow,
    this.color,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.letterSpacing,
    this.textDecoration,
    this.wordSpacing,
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? textOverflow;
  final int? maxLine;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize, letterSpacing, wordSpacing;
  final TextDecoration? textDecoration;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        textDirection: textDirection,
        overflow: textOverflow,
        maxLines: maxLine,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          decoration: textDecoration,
          fontFamily: fontFamily,
        ));
  }
}
