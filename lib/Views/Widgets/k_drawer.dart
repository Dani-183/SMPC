import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Bindings/bindings.dart';
import 'package:smpc/Views/Admin/details_edit_view.dart';
import 'package:smpc/Views/Auth/login.dart';
import 'package:smpc/Views/Events/manage_events.dart';
import 'package:smpc/Views/Gallery/my_gallery.dart';
import 'package:smpc/Views/Players/manage_players.dart';
import 'package:smpc/Views/Sports/manage_sports.dart';
import 'package:smpc/Views/Teams/manage_teams.dart';
import 'package:smpc/Views/Widgets/widgets.dart';
import '../../../constants/constants.dart';
import '../../Bindings/gallery_binding.dart';
import '../../Controllers/controllers.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 40),
              const Icon(Icons.lock, size: 80, color: kGreyColor),
              const SizedBox(height: 20),
              const KText(text: 'Are you Admin of College?', fontWeight: FontWeight.bold, fontSize: 16),
              const SizedBox(height: 20),
              KTextHeavyButton(
                isEnable: true.obs,
                lable: 'Login - Signup',
                height: 40,
                onTap: () {
                  Get.back();
                  Get.to(() => LoginView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KAdminDrawer extends StatelessWidget {
  KAdminDrawer({Key? key}) : super(key: key);

  final AdminController adminController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SafeArea(
        child: Column(
          children: [
            adminController.admin != null
                ? SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            alignment: Alignment.topRight,
                            child: TextButton(
                                onPressed: () {
                                  Get.back();
                                  Get.to(() => AdminDetailEditView(admin: adminController.admin!));
                                },
                                child: const KText(
                                  text: 'Edit Profile',
                                  textDecoration: TextDecoration.underline,
                                  color: kMainColor,
                                ))),
                        InkWell(
                          onTap: () {
                            Get.back();
                            Get.to(() => AdminDetailEditView(admin: adminController.admin!));
                          },
                          child: UserCircularImage(
                            radius: 120,
                            imageURL: adminController.admin!.image,
                          ),
                        ),
                        const SizedBox(height: 10),
                        KText(
                          text: adminController.admin!.name!,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              onTap: () {
                Get.back();
                Get.to(() => ManageSports(), binding: SportsBinding());
              },
              title: const KText(text: 'Manage Sports'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              onTap: () {
                Get.back();
                Get.to(() => ManageTeam(), binding: TeamsBinding());
              },
              title: const KText(text: 'Manage Teams'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              onTap: () {
                Get.back();
                Get.to(() => ManagePlayers(), binding: PlayersBinding());
              },
              title: const KText(text: 'Manage Players'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              onTap: () {
                Get.back();
                Get.to(() => ManageEvents(), binding: MyEventsBinding());
              },
              title: const KText(text: 'Manage Events'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              onTap: () {
                Get.back();
                Get.to(() => MyGalleryView(), binding: AdminGalleryBinding());
              },
              title: const KText(text: 'Manage Gallery'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: kMainColor),
              title: const Text('Logout', style: TextStyle(color: kMainColor)),
              onTap: () async {
                await Get.find<AuthController>().logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
