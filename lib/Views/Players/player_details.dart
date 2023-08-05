import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Constants/colors.dart';
import 'package:smpc/Controllers/players_controller.dart';
import 'package:smpc/Models/player_model.dart';
import 'package:smpc/Views/Players/edit_player.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

class PlayerDetailsView extends StatelessWidget {
  const PlayerDetailsView({Key? key, required this.playerId}) : super(key: key);
  final String playerId;

  @override
  Widget build(BuildContext context) {
    final PlayerModel? player = Get.find<PlayersController>().players!.any((element) => element.uid == playerId)
        ? Get.find<PlayersController>().players!.firstWhere((element) => element.uid == playerId)
        : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Player Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: player != null
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      UserCircularImage(imageURL: player.image, radius: 150),
                      const SizedBox(height: 20),
                      KeyValueRow(title: 'Name: ', text: player.name!, isDecorated: true),
                      KeyValueRow(title: 'Roll #: ', text: player.rollNo!),
                      KeyValueRow(title: 'Phone #: ', text: player.phoneNo!, isDecorated: true),
                    ],
                  )
                : const KText(text: 'Player is not available'),
          ),
        ),
      ),
    );
  }
}

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({Key? key, required this.title, required this.text, this.isDecorated}) : super(key: key);

  final String? title, text;
  final bool? isDecorated;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: isDecorated ?? false
          ? BoxDecoration(color: kGreyColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8))
          : null,
      child: Row(
        children: [
          Expanded(
            child: KText(text: '$title', fontSize: 18),
          ),
          Expanded(
            child: KText(text: '$text', fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
