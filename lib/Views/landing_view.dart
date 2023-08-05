import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smpc/Constants/colors.dart';
import 'package:smpc/Constants/global_var.dart';
import 'package:smpc/Controllers/controllers.dart';
import 'package:smpc/Controllers/gallery_controller.dart';
import 'package:smpc/Models/models.dart';
import 'package:smpc/Views/Auth/login.dart';
import 'package:smpc/Views/Events/event_details.dart';
import 'package:smpc/Views/Gallery/gallery_view.dart';
import 'package:smpc/Views/Widgets/k_drawer.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

import '../Utils/date_formatter.dart';

class LandingView extends StatelessWidget {
  LandingView({Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  final EventsController eventsController = Get.find();
  final GalleryController galleryController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMPC'),
        actions: [
          isSignedIn.value
              ? IconButton(
                  onPressed: () async {
                    await authController.logout();
                  },
                  icon: const Icon(Icons.logout),
                )
              : IconButton(
                  onPressed: () {
                    Get.to(() => LoginView());
                  },
                  icon: const Icon(Icons.admin_panel_settings_rounded),
                )
        ],
      ),
      drawer: isSignedIn.value ? KAdminDrawer() : const KDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                if (galleryController.gallery == null) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                } else if (galleryController.gallery!.isNotEmpty) {
                  List<String> images = [];
                  for (int i = 0; i < galleryController.gallery!.length; i++) {
                    images.add(galleryController.gallery![i].imageUrl!);
                    if (i == 8) {
                      break;
                    }
                  }
                  return CarouselSlider(
                      items: images.map((image) {
                        return Builder(builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => GalleryView());
                            },
                            child: Hero(
                              tag: image,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SizedBox(height: 200, width: double.infinity, child: NetImage(imagePath: image)),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 1.0,
                      ));
                } else {
                  return const SizedBox();
                }
              }),
              const SizedBox(height: 10),
              Obx(() {
                if (eventsController.events == null) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                } else if (eventsController.events!.isNotEmpty) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: eventsController.events!.length,
                    itemBuilder: (context, index) {
                      final EventModel event = eventsController.events![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: InkWell(
                          onTap: () => Get.to(() => EventDetailsView(eventId: event.uid!)),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [BoxShadow(spreadRadius: -3, blurRadius: 5, offset: Offset(1, 1))]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Hero(
                                    tag: event.image!,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: NetImage(imagePath: event.image!))),
                                const SizedBox(height: 8),
                                KText(text: ' ${event.title}', fontWeight: FontWeight.w600, fontSize: 15),
                                Row(
                                  children: [
                                    Expanded(
                                        child: KText(text: ' Entry Fee: ${event.entryFee}', color: kDarkGreyColor)),
                                    Expanded(
                                        child: KText(text: ' Prize: ${event.winningPrize}', color: kDarkGreyColor)),
                                  ],
                                ),
                                KText(
                                    text: ' Last Joining Date: ${dateTimeToDateString(event.lastDateToJoin!)}',
                                    fontWeight: FontWeight.w500),
                                // const Divider(),
                                // Row(
                                //   children: [
                                //     Expanded(
                                //         child: ElevatedButton(
                                //       onPressed: () async {},
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: const [
                                //           Icon(Icons.app_registration_rounded),
                                //           KText(text: ' Join Now'),
                                //         ],
                                //       ),
                                //     )),
                                //     const SizedBox(width: 8),
                                //     Expanded(
                                //         child: ElevatedButton(
                                //       onPressed: () {

                                //       },
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: const [
                                //           Icon(Icons.text_snippet_rounded),
                                //           KText(text: ' Details'),
                                //         ],
                                //       ),
                                //     )),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: LottieBuilder.asset('assets/json/events.json', width: 250)),
                        const SizedBox(height: 10),
                        const KText(text: 'There are no coming events', color: kGreyColor),
                      ],
                    ),
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
