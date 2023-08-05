import 'dart:developer';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smpc/Constants/constants.dart';
import 'package:smpc/Controllers/controllers.dart';
import 'package:smpc/Models/sports_model.dart';
import 'package:smpc/Views/Teams/add_team.dart';
import 'package:smpc/Views/Teams/edit_team_view.dart';
import 'package:smpc/Views/Teams/team_details_view.dart';

import '../../Services/services.dart';
import '../Widgets/widgets.dart';

class ManageTeam extends StatelessWidget {
  ManageTeam({Key? key}) : super(key: key);
  final SportsController sportsController = Get.find();
  final PlayersController playersController = Get.find();
  final TeamsController teamsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Team')),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            KTextHeavyButton(
              height: 50,
              isEnable: true.obs,
              lable: 'Add New Team',
              onTap: () async {
                await selectSports(context);
              },
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 4, indent: 100, endIndent: 100),
            const KText(text: 'All Teams', color: kMainColor, fontWeight: FontWeight.bold, fontSize: 22),
            const SizedBox(height: 5),
            Obx(() {
              if (teamsController.teams == null) {
                return const Center(child: CircularProgressIndicator.adaptive());
              } else if (teamsController.teams!.isNotEmpty) {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: teamsController.teams!.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final team = teamsController.teams![index];
                    SportsModel? sports = sportsController.sports!.any((element) => element.uid == team.sportsId)
                        ? sportsController.sports!.firstWhere((element) => element.uid == team.sportsId)
                        : null;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ListTileNetImage(imageURL: team.logo ?? ''),
                      title: KText(text: team.name!, fontWeight: FontWeight.bold, fontSize: 17),
                      subtitle: KText(text: sports != null ? sports.name! : 'Unknown Sports'),
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
                            Get.to(() => EditTeamView(team: team));
                          } else if (value == 2) {
                            final result = await showOkCancelAlertDialog(
                              context: context,
                              title: 'Are you sure?',
                              message: 'Do you really want to delete the ${team.name}',
                              okLabel: 'Delete',
                              isDestructiveAction: true,
                            );
                            if (result.name == 'ok') {
                              await DBServices().deleteTeam(team.uid!);
                            }
                          }
                        },
                      ),
                      onTap: () => Get.to(() => TeamDetailView(teamId: team.uid!, sportsName: sports?.name)),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('There are no teams added yet'),
                );
              }
            }),
          ],
        ),
      )),
    );
  }

  Future<dynamic> selectSports(BuildContext context) {
    RxString sportsId = ''.obs;
    return showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: kTransparent,
      builder: (context) => Material(
          child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Select Sports'),
          padding: EdgeInsetsDirectional.zero,
          trailing: Obx(() => sportsId.value != ''
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Get.to(() => AddNewTeam(sportsId: sportsId.value));
                      },
                      child: const Text('Next')))
              : const SizedBox()),
        ),
        child: SafeArea(
          // bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              if (sportsController.sports == null) {
                return const Center(child: CircularProgressIndicator.adaptive());
              } else if (sportsController.sports!.isNotEmpty) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sportsController.sports!.length,
                  itemBuilder: (context, index) {
                    final sports = sportsController.sports![index];
                    return Obx(() => Container(
                          decoration: BoxDecoration(
                              color: sportsId.value == sports.uid ? kMainColor : kTransparent,
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                            onTap: () {
                              sportsId.value == sports.uid ? sportsId.value = '' : sportsId.value = sports.uid!;
                              log('id: ${sports.uid}');
                            },
                            title: KText(
                              text: sports.name!,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: sportsId.value == sports.uid ? kWhiteColor : kBlackColor,
                            ),
                            leading: ListTileNetImage(imageURL: sports.image!),
                          ),
                        ));
                  },
                );
              } else {
                return const Center(
                  child: Text('There are no sports added yet'),
                );
              }
            }),
          ),
        ),
      )),
    );
  }
}
