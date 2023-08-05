import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Models/admin_model.dart';
import '../../../constants/constants.dart';
import '../../Controllers/controllers.dart';
import '../../Utils/utils.dart';
import '../Widgets/widgets.dart';

class SignupView extends StatelessWidget {
  SignupView({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isValid = false.obs;
  final RxString dpImgPath = ''.obs;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }),
      child: Scaffold(
        appBar: AppBar(title: const Text('Signup')),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        width: 200,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: kGreyColor),
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: ClipOval(
                            child: Obx(() => dpImgPath.value != ''
                                ? Image.file(File(dpImgPath.value), fit: BoxFit.cover)
                                : Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Image.asset('assets/images/college.png', color: kWhiteColor),
                                  )),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: MaterialButton(
                            padding: const EdgeInsets.all(10),
                            elevation: 0,
                            shape: const CircleBorder(),
                            color: kGreyColor,
                            onPressed: () async {
                              String? path = await ImagePickerService().imageFromGellery();
                              path != null ? dpImgPath.value = path : null;
                              checkValidity();
                            },
                            child: const Icon(Icons.photo_library)),
                      ),
                      // Obx(() => isUploading.value
                      //     ? const Positioned.fill(child: CircularProgressIndicator.adaptive())
                      //     : const SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 30),
                  KTextFieldOutline(
                    lable: 'College Name',
                    controller: nameController,
                    autoFillHints: const [AutofillHints.name],
                    textInputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                    prefixIcon: const Icon(Icons.person),
                    onChange: (value) {
                      checkValidity();
                    },
                  ),
                  const SizedBox(height: 15),
                  KTextFieldOutline(
                    lable: 'College Address',
                    controller: locationController,
                    capitalization: TextCapitalization.words,
                    autoFillHints: const [AutofillHints.location],
                    textInputType: TextInputType.streetAddress,
                    prefixIcon: const Icon(Icons.location_city_rounded),
                    onChange: (value) {
                      checkValidity();
                    },
                  ),
                  const SizedBox(height: 15),
                  KTextFieldOutline(
                    lable: 'College Phone #',
                    controller: phoneNoController,
                    autoFillHints: const [AutofillHints.telephoneNumber],
                    textInputType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.call),
                    onChange: (value) {
                      checkValidity();
                    },
                  ),
                  const SizedBox(height: 15),
                  KTextFieldOutline(
                    lable: 'Email',
                    controller: emailController,
                    autoFillHints: const [AutofillHints.email],
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    onChange: (value) {
                      checkValidity();
                    },
                  ),
                  const SizedBox(height: 15),
                  KTextFieldOutline(
                    lable: 'Password',
                    controller: passwordController,
                    obscure: true,
                    maxLines: 1,
                    textInputType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(Icons.password),
                    onChange: (value) {
                      checkValidity();
                    },
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                  KTextHeavyButton(
                    isEnable: isValid,
                    lable: 'SIGNUP AS COLLEGE ADMIN',
                    height: 47,
                    activeColor: kMainColor,
                    onTap: () async {
                      AdminModel adminModel = AdminModel(
                        email: emailController.text,
                        isDeleted: false,
                        isVerified: true,
                        joinedAt: DateTime.now(),
                        location: locationController.text,
                        name: nameController.text,
                        phoneNo: phoneNoController.text,
                        image: dpImgPath.value,
                      );
                      await Get.find<AuthController>()
                          .signup(context, emailController.text, passwordController.text, adminModel);
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const KText(text: 'Already have an account? '),
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Login Now'))
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkValidity() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        dpImgPath.value != '') {
      isValid.value = true;
    } else {
      isValid.value = false;
    }
  }
}
