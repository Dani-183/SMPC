import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Views/landing_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Get.off(() => LandingView());
    });
    return Scaffold(
      body: Center(child: Image.asset('assets/images/smpclogo.png')),
    );
  }
}
