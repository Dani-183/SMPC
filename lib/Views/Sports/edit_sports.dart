import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Models/sports_model.dart';
import 'package:smpc/Services/services.dart';
import 'package:smpc/Utils/utils.dart';

import '../../Constants/constants.dart';
import '../Widgets/widgets.dart';

class EditSports extends StatelessWidget {
  EditSports({Key? key, required this.sports}) : super(key: key);
  final SportsModel sports;
  final RxBool isValid = true.obs;
  final RxString logoPath = ''.obs;
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? oldLogoURL = sports.image;
    nameController.text = sports.name!;
    return GestureDetector(
      onTap: (() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }),
      child: Scaffold(
        appBar: AppBar(title: const Text('Update Sports')),
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
                                : oldLogoURL != null
                                    ? NetImage(imagePath: oldLogoURL)
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
            lable: 'Update Sports',
            onTap: () async {
              try {
                loadingStatusDialog(context, title: 'Updating Sports');
                String? imageUrl = logoPath.value != ''
                    ? await StorageService().imgageUpload('College/Sports/', logoPath.value)
                    : null;
                SportsModel sportsModel = SportsModel(
                  uid: sports.uid,
                  image: imageUrl ?? oldLogoURL,
                  name: nameController.text,
                );
                await DBServices().updateSports(sportsModel);
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
    if (nameController.text.isNotEmpty) {
      isValid.value = true;
    } else {
      isValid.value = false;
    }
  }
}
