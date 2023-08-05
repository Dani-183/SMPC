import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Bindings/init_bindings.dart';
import 'package:smpc/Constants/constants.dart';
import 'package:smpc/Controllers/gallery_controller.dart';
import 'package:smpc/Views/SplashScreen/splash_screen.dart';
import 'package:smpc/firebase_options.dart';

import 'Controllers/controllers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthController());
  Get.put(EventsController());
  Get.put(GalleryController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: kPrimaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(),
          centerTitle: true,
        ),
      ),
      initialBinding: InitBindig(),
      home: const SplashScreen(),
    );
  }
}
