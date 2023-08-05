import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smpc/Models/models.dart';
import 'package:smpc/Utils/date_formatter.dart';

import '../../Controllers/controllers.dart';
import '../../Services/services.dart';
import '../../Utils/utils.dart';
import '../../constants/constants.dart';
import '../Widgets/widgets.dart';

class CreateEvent extends StatelessWidget {
  CreateEvent({Key? key}) : super(key: key);
  final RxString image = ''.obs;
  final RxBool isValid = false.obs;

  late DateTime lastDate;
  late DateTime lastJoinDate;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController termsController = TextEditingController();
  final TextEditingController entryFeeController = TextEditingController();
  final TextEditingController prizeController = TextEditingController();
  final TextEditingController lastJoinDateController = TextEditingController();
  final TextEditingController lastDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  String? imagePath = await ImagePickerService().imageFromGellery();
                  if (imagePath != null) {
                    image.value = imagePath;
                  }
                  checkValidity();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                      color: kGreyColor.withOpacity(0.4),
                      width: double.infinity,
                      height: 200,
                      alignment: Alignment.center,
                      child: Obx(() => image.value != ''
                          ? SizedBox(width: double.infinity, child: Image.file(File(image.value), fit: BoxFit.cover))
                          : const Icon(Icons.image, size: 40))),
                ),
              ),
              const SizedBox(height: 15),
              KTextFieldOutline(
                lable: 'Event Title',
                controller: titleController,
                capitalization: TextCapitalization.words,
                textInputType: TextInputType.text,
                onChange: (value) {
                  checkValidity();
                },
              ),
              const SizedBox(height: 15),
              KTextFieldOutline(
                lable: 'Description',
                controller: descController,
                capitalization: TextCapitalization.sentences,
                textInputType: TextInputType.text,
                onChange: (value) {
                  checkValidity();
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: KTextFieldOutline(
                      lable: 'Entry Fee',
                      controller: entryFeeController,
                      capitalization: TextCapitalization.none,
                      textInputType: TextInputType.number,
                      formatter: [FilteringTextInputFormatter.digitsOnly],
                      onChange: (value) {
                        checkValidity();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: KTextFieldOutline(
                      lable: 'Winning Prize',
                      controller: prizeController,
                      capitalization: TextCapitalization.none,
                      textInputType: TextInputType.number,
                      onChange: (value) {
                        checkValidity();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: KTextFieldOutline(
                      lable: 'Last Joining Date',
                      controller: lastJoinDateController,
                      capitalization: TextCapitalization.none,
                      textInputType: TextInputType.datetime,
                      isReadOnly: true,
                      ontap: () {
                        datePicker(context,
                            onDateChange: (value) {
                              lastJoinDate = value;
                              lastJoinDateController.text = dateTimeToDateString(value);
                            },
                            onDone: () => Get.back());
                      },
                      onChange: (value) {
                        checkValidity();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: KTextFieldOutline(
                      lable: 'Event End Date',
                      controller: lastDateController,
                      capitalization: TextCapitalization.none,
                      textInputType: TextInputType.datetime,
                      isReadOnly: true,
                      ontap: () {
                        datePicker(context,
                            onDateChange: (value) {
                              lastDate = value;
                              lastDateController.text = dateTimeToDateString(value);
                            },
                            onDone: () => Get.back());
                      },
                      onChange: (value) {
                        checkValidity();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              KTextFieldOutline(
                lable: 'Location',
                controller: locationController,
                capitalization: TextCapitalization.sentences,
                textInputType: TextInputType.text,
                onChange: (value) {
                  checkValidity();
                },
              ),
              const SizedBox(height: 15),
              KTextFieldOutline(
                lable: 'Event Terms',
                controller: termsController,
                capitalization: TextCapitalization.sentences,
                textInputType: TextInputType.text,
                onChange: (value) {
                  checkValidity();
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: KTextHeavyButton(
          margin: const EdgeInsets.all(10),
          height: 50,
          isEnable: isValid,
          lable: 'Create Event',
          onTap: () async {
            try {
              loadingStatusDialog(context, title: 'Creating Event');
              String? collegeId = Get.find<AdminController>().admin?.uid;
              String? imageUrl = await StorageService().imgageUpload('Events/$collegeId/', image.value);
              EventModel eventModel = EventModel(
                createdAt: DateTime.now(),
                createdBy: collegeId,
                description: descController.text,
                endDate: lastDate,
                entryFee: num.parse(entryFeeController.text),
                image: imageUrl,
                isDeleted: false,
                joinedList: [],
                lastDateToJoin: lastJoinDate,
                location: locationController.text,
                terms: termsController.text,
                title: titleController.text,
                winningPrize: prizeController.text,
              );
              await DBServices().createNewEvent(eventModel);
              Get.back();
              Get.back();
            } catch (e) {
              errorOverlay(context, title: 'Failed', message: e.toString());
            }
          },
        ),
      ),
    );
  }

  void checkValidity() {
    if (image.value != '' &&
        titleController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        entryFeeController.text.isNotEmpty &&
        prizeController.text.isNotEmpty &&
        lastDateController.text.isNotEmpty &&
        lastJoinDateController.text.isNotEmpty &&
        locationController.text.isNotEmpty) {
      isValid.value = true;
    } else {
      isValid.value = false;
    }
  }
}
