import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Controllers/controllers.dart';
import 'package:smpc/Models/models.dart';
import 'package:smpc/Services/db_services.dart';
import 'package:smpc/Utils/date_formatter.dart';
import 'package:smpc/Views/Events/college_details.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

import '../../Constants/constants.dart';

class MyEventDetailsView extends StatelessWidget {
  MyEventDetailsView({Key? key, required this.eventId}) : super(key: key);
  final String eventId;
  final MyEventsController eventsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
              onPressed: () async {
                final result = await showOkCancelAlertDialog(
                  context: context,
                  title: 'Warning',
                  message: 'Are you sure to delete the event?',
                  okLabel: 'Delete',
                  isDestructiveAction: true,
                );
                if (result.name == 'ok') {
                  await DBServices().deleteEvent(eventId);
                  Get.back();
                }
              },
              icon: const Icon(Icons.delete, color: kErrorColor)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Obx(() {
              if (eventsController.events!.any((element) => element.uid == eventId)) {
                final EventModel event = eventsController.events!.firstWhere((element) => element.uid == eventId);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                        tag: event.image!,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15), child: NetImage(imagePath: event.image!))),
                    const SizedBox(height: 8),
                    KText(text: ' ${event.title}', fontWeight: FontWeight.w700, fontSize: 16),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(child: KText(text: ' Entry Fee: ${event.entryFee}', color: kDarkGreyColor)),
                        Expanded(child: KText(text: ' Prize: ${event.winningPrize}', color: kDarkGreyColor)),
                      ],
                    ),
                    KText(
                        text: ' Last Joining Date: ${dateTimeToDateString(event.lastDateToJoin!)}',
                        fontWeight: FontWeight.w300),
                    KText(text: ' Event End: ${dateTimeToDateString(event.endDate!)}', fontWeight: FontWeight.w300),
                    const SizedBox(height: 8),
                    KText(text: ' Location: ${event.location}', fontWeight: FontWeight.w500),
                    const Divider(),
                    const KText(text: 'Description:', fontWeight: FontWeight.w700),
                    KText(text: event.description!),
                    const Divider(),
                    const KText(text: 'Terms:', fontWeight: FontWeight.w700),
                    KText(text: event.terms != null ? event.terms! : 'There are no terms and conditions'),
                    const Divider(),
                    const KText(text: 'All Joined Colleges', fontWeight: FontWeight.bold, fontSize: 16),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: event.joinedList!.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return FutureBuilder<AdminModel?>(
                            future: DBServices().getAdmin(event.joinedList![index]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator.adaptive());
                              } else if (snapshot.hasData) {
                                final admin = snapshot.data!;
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: ListTileNetImage(imageURL: admin.image!),
                                  title: KText(text: admin.name!),
                                  subtitle: KText(text: admin.location!),
                                  onTap: () {
                                    Get.to(() => CollegeDetails(admin: admin));
                                  },
                                );
                              } else {
                                return KText(text: 'Data not found: ${event.joinedList?[index]}');
                              }
                            });
                      },
                    ),
                  ],
                );
              } else {
                return const KText(text: 'Event not found');
              }
            })),
      ),
    );
  }
}
