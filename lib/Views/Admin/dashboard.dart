import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Controllers/controllers.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: [
        IconButton(
            onPressed: () async {
              authController.logout();
            },
            icon: const Icon(Icons.logout))
      ]),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            KTextHeavyButton(isEnable: true.obs, lable: 'Add Sports'),
          ],
        ),
      )),
    );
  }
}
