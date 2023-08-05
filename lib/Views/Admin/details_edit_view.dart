import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Controllers/admin_controller.dart';
import 'package:smpc/Models/admin_model.dart';
import 'package:smpc/Utils/utils.dart';

import '../../Constants/constants.dart';
import '../../Services/services.dart';
import '../Widgets/widgets.dart';

class AdminDetailEditView extends StatelessWidget {
  AdminDetailEditView({Key? key, required this.admin}) : super(key: key);
  final AdminModel admin;
  final RxBool isValid = true.obs;
  final RxString imagePath = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController bankAccountTitleController = TextEditingController();
  final TextEditingController bankIBANController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String? oldImageUrl = admin.image;
    nameController.text = admin.name ?? '';
    phoneNoController.text = admin.phoneNo ?? '';
    locationController.text = admin.location ?? '';
    aboutController.text = admin.aboutCollege ?? '';
    bankAccountTitleController.text = admin.bankAccountTitle ?? '';
    bankIBANController.text = admin.bankIBAN ?? '';
    bankNameController.text = admin.bankName ?? '';

    return GestureDetector(
      onTap: (() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            Obx(
              () => isValid.value
                  ? TextButton(
                      onPressed: () async {
                        loadingStatusDialog(context, title: 'Updating');
                        String? newImgUrl = imagePath.value != ''
                            ? await StorageService().imgageUpload('User/${admin.uid}/DP-', imagePath.value)
                            : null;

                        AdminModel adminModel = AdminModel(
                          uid: admin.uid,
                          aboutCollege: aboutController.text,
                          bankAccountTitle: bankAccountTitleController.text,
                          bankIBAN: bankIBANController.text,
                          bankName: bankNameController.text,
                          image: newImgUrl ?? oldImageUrl,
                          location: locationController.text,
                          name: nameController.text,
                          phoneNo: phoneNoController.text,
                        );
                        await DBServices().updateAdmin(adminModel);
                        Get.find<AdminController>().onInit();
                        Get.back();
                        Get.back();
                      },
                      child: const KText(text: 'SAVE'))
                  : const SizedBox(),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
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
                          child: Obx(() => imagePath.value != ''
                              ? Image.file(File(imagePath.value), fit: BoxFit.cover)
                              : oldImageUrl != null
                                  ? NetImage(imagePath: oldImageUrl)
                                  : Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Image.asset('assets/images/college.png', color: kWhiteColor))),
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
                            path != null ? imagePath.value = path : null;
                            checkValidity();
                          },
                          child: const Icon(Icons.photo_library)),
                    ),
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
                  lable: 'About',
                  controller: aboutController,
                  textInputType: TextInputType.text,
                  prefixIcon: const Icon(Icons.texture_rounded),
                  onChange: (value) {
                    checkValidity();
                  },
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      KText(text: 'Bank Details', fontWeight: FontWeight.bold, fontSize: 16),
                      KText(text: 'This detail will be used for the funds transfer of an event.'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                KTextFieldOutline(
                  lable: 'Bank Account Title',
                  controller: bankAccountTitleController,
                  textInputType: TextInputType.text,
                  prefixIcon: const Icon(Icons.text_fields_rounded),
                  onChange: (value) {
                    checkValidity();
                  },
                ),
                const SizedBox(height: 15),
                KTextFieldOutline(
                  lable: 'Bank Account / IBAN #',
                  controller: bankIBANController,
                  textInputType: TextInputType.number,
                  prefixIcon: const Icon(Icons.numbers),
                  onChange: (value) {
                    checkValidity();
                  },
                ),
                const SizedBox(height: 15),
                KTextFieldOutline(
                  lable: 'Bank Name',
                  controller: bankNameController,
                  textInputType: TextInputType.text,
                  prefixIcon: const Icon(Icons.account_balance),
                  onChange: (value) {
                    checkValidity();
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkValidity() {
    if (nameController.text.isNotEmpty && locationController.text.isNotEmpty && phoneNoController.text.isNotEmpty) {
      isValid.value = true;
    } else {
      isValid.value = false;
    }
  }
}
