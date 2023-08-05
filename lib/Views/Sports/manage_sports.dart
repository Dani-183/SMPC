import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Controllers/sports_controller.dart';
import 'package:smpc/Services/db_services.dart';
import 'package:smpc/Views/Sports/add_sports.dart';
import 'package:smpc/Views/Sports/edit_sports.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

class ManageSports extends StatelessWidget {
  ManageSports({Key? key}) : super(key: key);
  final SportsController sportsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Sports'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            children: [
              KTextHeavyButton(
                height: 50,
                isEnable: true.obs,
                lable: 'Add New Sports',
                onTap: () {
                  Get.to(() => AddSportsView());
                },
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (sportsController.sports == null) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                } else if (sportsController.sports!.isNotEmpty) {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sportsController.sports!.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final sports = sportsController.sports![index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ListTileNetImage(imageURL: sports.image!),
                        title: KText(
                          text: sports.name!,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        trailing: PopupMenuButton<int>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: const [
                                  Icon(Icons.edit_note_rounded),
                                  SizedBox(width: 10),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: const [
                                  Icon(Icons.delete),
                                  SizedBox(width: 10),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                          ],
                          elevation: 2,
                          onSelected: (value) async {
                            if (value == 1) {
                              Get.to(() => EditSports(sports: sports));
                            } else if (value == 2) {
                              final result = await showOkCancelAlertDialog(
                                context: context,
                                title: 'Are you sure?',
                                message: 'Do you really want to delete the ${sports.name}',
                                okLabel: 'Delete',
                                isDestructiveAction: true,
                              );
                              if (result.name == 'ok') {
                                await DBServices().deleteSports(sports.uid!);
                              }
                            }
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('There are no sports Added yet'),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
