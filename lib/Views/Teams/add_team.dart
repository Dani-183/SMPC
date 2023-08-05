import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Models/team_model.dart';

import '../../Constants/constants.dart';
import '../../Controllers/controllers.dart';
import '../../Services/services.dart';
import '../../Utils/utils.dart';
import '../Widgets/widgets.dart';

class AddNewTeam extends StatelessWidget {
  AddNewTeam({Key? key, required this.sportsId}) : super(key: key);
  final String sportsId;
  final RxBool isValid = false.obs;
  final RxString imagePath = ''.obs;
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
          title: const Text('Add New Team'),
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
                                : const Center(
                                    child: KText(
                                      text: 'LOGO',
                                      color: kWhiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
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
                              path != null ? imagePath.value = path : null;
                              checkValidity();
                            },
                            child: const Icon(Icons.photo_library)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  KTextFieldOutline(
                    lable: 'Team Name',
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
            lable: 'Add Team',
            onTap: () async {
              try {
                loadingStatusDialog(context, title: 'Adding Team');
                String? collegeId = Get.find<AdminController>().admin?.uid;
                String? imageUrl = imagePath.value == ''
                    ? null
                    : await StorageService().imgageUpload('Players/$collegeId/', imagePath.value);
                TeamModel teamModel = TeamModel(
                  collegeId: collegeId,
                  createdAt: DateTime.now(),
                  isDeleted: false,
                  logo: imageUrl,
                  name: nameController.text,
                  playersIds: [],
                  sportsId: sportsId,
                );
                await DBServices().addNewTeam(teamModel);
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
