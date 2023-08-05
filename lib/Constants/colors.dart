import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(255, 255, 255, .1),
  100: const Color.fromRGBO(255, 255, 255, .2),
  200: const Color.fromRGBO(255, 255, 255, .3),
  300: const Color.fromRGBO(255, 255, 255, .4),
  400: const Color.fromRGBO(255, 255, 255, .5),
  500: const Color.fromRGBO(255, 255, 255, .6),
  600: const Color.fromRGBO(255, 255, 255, .7),
  700: const Color.fromRGBO(255, 255, 255, .8),
  800: const Color.fromRGBO(255, 255, 255, .9),
  900: const Color.fromRGBO(255, 255, 255, 1),
};

const int _mainColor = 0xFF3B1455;
MaterialColor kPrimaryColor = MaterialColor(_mainColor, color);

const Color kMainColor = Color(_mainColor);
const Color kGreenColor = Colors.green;
const Color kBlueColor = Color(0xFF323FDA);
const Color kLightBlueColor = Color(0xFF14C9E7);
const Color kOrangeColor = Color(0xFFFE6F1D);
const Color kBlackDarkColor = Color(0xFF252525);
const Color kGreyColor = Color(0xFFCECECE);
const Color kDarkGreyColor = Color.fromARGB(255, 150, 150, 150);
const Color kTransparent = Colors.transparent;
const Color kBlackColor = Colors.black;
const Color kErrorColor = Color(0xFF8B231B);
const Color kWhiteColor = Color(0xffffffff);

const IconThemeData iconDarkTheme = IconThemeData(color: kBlackColor);
