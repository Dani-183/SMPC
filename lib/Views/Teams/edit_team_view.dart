import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Models/team_model.dart';
import 'package:smpc/Services/services.dart';
import 'package:smpc/Utils/utils.dart';

import '../../constants/constants.dart';
import '../Widgets/widgets.dart';

class EditTeamView extends StatelessWidget {
  EditTeamView({Key? key, required this.team}) : super(key: key);
  final TeamModel team;
  final RxBool isValid = true.obs;
  final RxString imagePath = ''.obs;
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String? oldLogoURL = team.logo;
    nameController.text = team.name!;
    return GestureDetector(
      onTap: (() {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }),
      child: Scaffold(
        appBar: AppBar(title: const Text('Update Team')),
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
                                : oldLogoURL != null
                                    ? NetImage(imagePath: oldLogoURL)
                                    : const Center(
                                        child: KText(
                                            text: 'LOGO',
                                            color: kWhiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30))),
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
                      // Obx(() => isUploading.value
                      //     ? const Positioned.fill(child: CircularProgressIndicator.adaptive())
                      //     : const SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 30),
                  KTextFieldOutline(
                    lable: 'Team Name',
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
            lable: 'Update Team',
            onTap: () async {
              try {
                loadingStatusDialog(context, title: 'Updating Team');
                String? imageUrl = imagePath.value != ''
                    ? await StorageService().imgageUpload('College/Teams/', imagePath.value)
                    : null;
                TeamModel teamModel = TeamModel(
                  uid: team.uid,
                  logo: imageUrl ?? oldLogoURL,
                  name: nameController.text,
                );
                await DBServices().updateTeam(teamModel);
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
