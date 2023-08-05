import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Constants/constants.dart';
import 'package:smpc/Controllers/controllers.dart';
import 'package:smpc/Models/models.dart';
import 'package:smpc/Views/Events/create_event.dart';
import 'package:smpc/Views/Events/my_event_detail.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

class ManageEvents extends StatelessWidget {
  ManageEvents({Key? key}) : super(key: key);
  final MyEventsController eventsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Events')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            children: [
              KTextHeavyButton(
                height: 50,
                isEnable: true.obs,
                lable: 'Create New Event',
                onTap: () {
                  Get.to(() => CreateEvent());
                },
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 4, indent: 100, endIndent: 100),
              const KText(text: 'All My Events', color: kMainColor, fontWeight: FontWeight.bold, fontSize: 22),
              const SizedBox(height: 5),
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
                          onTap: () => Get.to(() => MyEventDetailsView(eventId: event.uid!)),
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
                                    text: ' No of joined Colleges: ${event.joinedList!.length}',
                                    fontWeight: FontWeight.w500),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No data found.'),
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
