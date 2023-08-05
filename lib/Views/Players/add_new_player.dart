import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Models/player_model.dart';

import '../../Controllers/controllers.dart';
import '../../Services/services.dart';
import '../../Utils/utils.dart';
import '../../constants/constants.dart';
import '../Widgets/widgets.dart';

class AddNewPlayer extends StatelessWidget {
  AddNewPlayer({Key? key}) : super(key: key);

  final RxBool isValid = false.obs;
  final RxString imagePath = ''.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

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
          title: const Text('Add New Player'),
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
                            child: Obx(() => imagePath.value != ''
                                ? Image.file(File(imagePath.value), fit: BoxFit.cover)
                                : Image.asset('assets/images/User.png', color: kWhiteColor)),
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
                              String? imgPath = await ImagePickerService().imageFromGellery();
                              imgPath != null ? imagePath.value = imgPath : null;
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
                    lable: 'Player Name',
                    controller: nameController,
                    capitalization: TextCapitalization.words,
                    autoFillHints: const [AutofillHints.name],
                    textInputType: TextInputType.name,
                    prefixIcon: const Icon(Icons.person),
                    onChange: (value) {
                      checkValidity();
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: KTextFieldOutline(
                          lable: 'Class',
                          controller: classController,
                          textInputType: TextInputType.text,
                          capitalization: TextCapitalization.words,
                          prefixIcon: const Icon(Icons.class_rounded),
                          onChange: (value) {
                            checkValidity();
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: KTextFieldOutline(
                          lable: 'Roll #',
                          controller: rollNoController,
                          textInputType: TextInputType.text,
                          capitalization: TextCapitalization.words,
                          prefixIcon: const Icon(Icons.numbers),
                          onChange: (value) {
                            checkValidity();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  KTextFieldOutline(
                    lable: 'Phone #',
                    controller: phoneNoController,
                    autoFillHints: const [AutofillHints.telephoneNumber],
                    textInputType: TextInputType.phone,
                    capitalization: TextCapitalization.none,
                    prefixIcon: const Icon(Icons.phone),
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
            lable: 'Add Player',
            onTap: () async {
              try {
                loadingStatusDialog(context, title: 'Adding Player');
                String? collegeId = Get.find<AdminController>().admin?.uid;
                String? imageUrl = await StorageService().imgageUpload('Players/$collegeId/', imagePath.value);
                PlayerModel playerModel = PlayerModel(
                  collegeId: collegeId,
                  addedAt: DateTime.now(),
                  image: imageUrl,
                  isDeleted: false,
                  name: nameController.text,
                  phoneNo: phoneNoController.text,
                  rollNo: rollNoController.text,
                );
                await DBServices().addNewPlayer(playerModel);
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
    if (imagePath.value != '' &&
        nameController.text.isNotEmpty &&
        classController.text.isNotEmpty &&
        rollNoController.text.isNotEmpty &&
        phoneNoController.text.isNotEmpty) {
      isValid.value = true;
    } else {
      isValid.value = false;
    }
  }
}
