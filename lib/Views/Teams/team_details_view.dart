import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smpc/Constants/colors.dart';
import 'package:smpc/Controllers/controllers.dart';
import 'package:smpc/Models/player_model.dart';
import 'package:smpc/Models/team_model.dart';
import 'package:smpc/Services/db_services.dart';
import 'package:smpc/Views/Teams/edit_team_view.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

import '../Players/player_details.dart';

class TeamDetailView extends StatelessWidget {
  TeamDetailView({Key? key, required this.teamId, this.sportsName}) : super(key: key);
  final String teamId;
  final String? sportsName;
  final TeamsController teamsController = Get.find();
  final PlayersController playersController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team Details')),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Obx(() {
              if (teamsController.teams!.any((element) => element.uid == teamId)) {
                final TeamModel team = teamsController.teams!.firstWhere((element) => element.uid == teamId);
                return Center(
                  child: Column(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox.square(
                            dimension: 150,
                            child: team.logo == null
                                ? const CircleAvatar(
                                    backgroundColor: kGreyColor,
                                    child: KText(text: 'LOGO', fontWeight: FontWeight.bold, fontSize: 22))
                                : ClipOval(child: NetImage(imagePath: team.logo!, isUser: true, boxfit: BoxFit.cover)),
                          ),
                          const SizedBox(height: 8),
                          KText(text: team.name!, fontWeight: FontWeight.bold, fontSize: 22),
                          KText(text: sportsName ?? 'Unknown Sports', color: kGreyColor),
                        ],
                      ),
                      const Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const KText(text: 'All Team Players', fontWeight: FontWeight.bold),
                        trailing: const Icon(Icons.edit_note_rounded),
                        onTap: () async {
                          await addTeamPlayer(context, team.playersIds!);
                        },
                      ),
                      team.playersIds!.isEmpty
                          ? const KText(text: 'There are no player in this team')
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: team.playersIds!.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final PlayerModel? player =
                                    playersController.players!.any((element) => element.uid == team.playersIds![index])
                                        ? playersController.players!
                                            .firstWhere((element) => element.uid == team.playersIds![index])
                                        : null;
                                return player == null
                                    ? ListTile(title: KText(text: team.playersIds![index]))
                                    : ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: ListTileNetImage(imageURL: player.image!),
                                        title: KText(text: player.name!, fontWeight: FontWeight.bold, fontSize: 17),
                                        onTap: () {
                                          Get.to(() => PlayerDetailsView(playerId: player.uid!));
                                        },
                                        subtitle: KText(text: 'Roll# ${player.rollNo}'));
                              },
                            ),
                    ],
                  ),
                );
              } else {
                return const Center(child: KText(text: 'Team not found'));
              }
            })),
      ),
    );
  }

  Future<dynamic> addTeamPlayer(BuildContext context, List playerIds) {
    RxList ids = playerIds.obs;
    return showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: kTransparent,
      builder: (context) => Material(
          child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: const Text('Manage Players'),
            padding: EdgeInsetsDirectional.zero,
            trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await DBServices().updateTeamPlayer(teamId, ids);
                    },
                    child: const Text('Update')))),
        child: SafeArea(
          // bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
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
                      subtitle: KText(text: 'Roll# ${player.rollNo}'),
                      trailing: Obx(() => Checkbox(
                          checkColor: kWhiteColor,
                          activeColor: kMainColor,
                          // controlAffinity: ListTileControlAffinity.leading,
                          value: ids.map((element) => element).contains(player.uid),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onChanged: (value) {
                            ids.contains(player.uid) ? ids.remove(player.uid) : ids.add(player.uid!);
                          })),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('There are no player found'),
                );
              }
            }),
          ),
        ),
      )),
    );
  }
}
