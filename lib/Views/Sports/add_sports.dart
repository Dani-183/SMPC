import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Models/sports_model.dart';
import 'package:smpc/Services/db_services.dart';
import 'package:smpc/Services/firebase_storage_service.dart';
import 'package:smpc/Utils/utils.dart';

import '../../Controllers/controllers.dart';
import '../../constants/constants.dart';
import '../Widgets/widgets.dart';

class AddSportsView extends StatelessWidget {
  AddSportsView({Key? key}) : super(key: key);

  final RxBool isValid = false.obs;
  final RxString logoPath = ''.obs;
  final TextEditingController nameController = TextEditingController();

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
        appBar: AppBar(
          title: const Text('Add New Sports'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                            child: Obx(() => logoPath.value != ''
                                ? Image.file(File(logoPath.value), fit: BoxFit.cover)
                                : const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Icon(Icons.sports_rounded, size: 50, color: kWhiteColor))),
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
                              path != null ? logoPath.value = path : null;
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
                    lable: 'Sports Name',
                    controller: nameController,
                    autoFillHints: const [AutofillHints.name],
                    textInputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                    prefixIcon: const Icon(Icons.sports),
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
        bottomNavigationBar: SafeArea(
          child: KTextHeavyButton(
            margin: const EdgeInsets.all(10),
            height: 50,
            isEnable: isValid,
            lable: 'Add Sports',
            onTap: () async {
              try {
                String? collegeId = Get.find<AdminController>().admin?.uid;
                loadingStatusDialog(context, title: 'Adding Sports');
                String? imageUrl = await StorageService().imgageUpload('College/Sports/$collegeId/', logoPath.value);
                SportsModel sportsModel = SportsModel(
                  collegeId: collegeId,
                  createdAt: DateTime.now(),
                  image: imageUrl,
                  isDeleted: false,
                  name: nameController.text,
                );
                await DBServices().addNewSports(sportsModel);
                Get.back();
                Get.back();
              } catch (e) {
                errorOverlay(context, title: 'Failed', message: e.toString());
              }
            },
          ),
        ),
      ),
    );
  }

  checkValidity() {
    if (logoPath.value != '' && nameController.text.isNotEmpty) {
      isValid.value = true;
    } else {
      isValid.value = false;
    }
  }
}
