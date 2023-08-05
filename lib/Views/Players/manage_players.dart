import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Constants/colors.dart';
import 'package:smpc/Controllers/players_controller.dart';
import 'package:smpc/Views/Players/add_new_player.dart';
import 'package:smpc/Views/Players/edit_player.dart';
import 'package:smpc/Views/Players/player_details.dart';

import '../../Services/services.dart';
import '../Widgets/widgets.dart';

class ManagePlayers extends StatelessWidget {
  ManagePlayers({Key? key}) : super(key: key);
  final PlayersController playersController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Players')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            children: [
              KTextHeavyButton(
                height: 50,
                isEnable: true.obs,
                lable: 'Add New Player',
                onTap: () {
                  Get.to(() => AddNewPlayer());
                },
              ),
              const SizedBox(height: 10),
              const Divider(
                thickness: 4,
                indent: 100,
                endIndent: 100,
              ),
              const KText(text: 'All Players', color: kMainColor, fontWeight: FontWeight.bold, fontSize: 22),
              const SizedBox(height: 5),
              Obx(() {
                if (playersController.players == null) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                } else if (playersController.players!.isNotEmpty) {
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: playersController.players!.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final player = playersController.players![index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ListTileNetImage(imageURL: player.image!),
                        title: KText(text: player.name!, fontWeight: FontWeight.bold, fontSize: 17),
                        onTap: () {
                          Get.to(() => PlayerDetailsView(playerId: player.uid!));
                        },
                        subtitle: KText(text: 'Roll# ${player.rollNo}'),
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
                              Get.to(() => PlayerEditView(player: player));
                            } else if (value == 2) {
                              final result = await showOkCancelAlertDialog(
                                context: context,
                                title: 'Are you sure?',
                                message: 'Do you really want to delete the ${player.name}',
                                okLabel: 'Delete',
                                isDestructiveAction: true,
                              );
                              if (result.name == 'ok') {
                                await DBServices().deletePlayer(player.uid!);
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
