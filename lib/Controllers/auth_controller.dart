import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Bindings/init_bindings.dart';
import 'package:smpc/Models/admin_model.dart';
import 'package:smpc/Views/SplashScreen/splash_screen.dart';
import '../Constants/constants.dart';
import '../Services/services.dart';
import '../Utils/utils.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  Rxn<User> firebaseUser = Rxn<User>();
  User? get user => firebaseUser.value;

  @override
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());
    log('|-----------------------------------------|');
    if (auth.currentUser != null) {
      userID.value = auth.currentUser!.uid;
      isSignedIn.value = true;
      log('| UserID: ${auth.currentUser?.uid}');
    } else {
      log('User not found');
    }
    log('|-----------------------------------------|');
    super.onInit();
  }

  Future<void> signup(BuildContext context, String email, String password, AdminModel adminModel) async {
    try {
      loadingStatusDialog(context, title: 'Authenticating');
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      String? dpUrl = await StorageService().imgageUpload('User/$uid/DP-', adminModel.image!);
      if (dpUrl != null) {
        adminModel.uid = uid;
        adminModel.image = dpUrl;
        await DBServices().createAdmin(adminModel);
      }
      onInit();
      Navigator.of(context).pop();
      Get.offAll(() => const SplashScreen(), binding: InitBindig());
    } catch (e) {
      Navigator.of(context).pop();
      log(e.toString());
      errorOverlay(context, title: 'Failed', message: e.toString());
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      loadingStatusDialog(context, title: 'Signingin');
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop();
      onInit();
      Get.offAll(() => const SplashScreen(), binding: InitBindig());
    } catch (e) {
      Get.back();
      errorOverlay(context, title: 'Signin Failed', message: e.toString());
      log(e.toString());
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    isSignedIn.value = false;
    userID.value = '';
    onInit();
    Get.offAll(() => const SplashScreen(), binding: InitBindig());
  }
}
