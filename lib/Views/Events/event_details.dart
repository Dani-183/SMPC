import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smpc/Controllers/controllers.dart';
import 'package:smpc/Models/models.dart';
import 'package:smpc/Services/db_services.dart';
import 'package:smpc/Utils/date_formatter.dart';
import 'package:smpc/Views/Auth/login.dart';
import 'package:smpc/Views/Widgets/widgets.dart';
import '../../Constants/constants.dart';

class EventDetailsView extends StatelessWidget {
  EventDetailsView({Key? key, required this.eventId}) : super(key: key);
  final String eventId;
  final EventsController eventsController = Get.find();
  final AdminController adminController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
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
                      fontWeight: FontWeight.w300,
                      color: event.lastDateToJoin!.isBefore(DateTime.now()) ? kErrorColor : kBlackColor,
                    ),
                    KText(text: ' Event End: ${dateTimeToDateString(event.endDate!)}', fontWeight: FontWeight.w300),
                    const SizedBox(height: 8),
                    KText(text: ' Location: ${event.location}', fontWeight: FontWeight.w500),
                    const Divider(),
                    const KText(text: 'Description:', fontWeight: FontWeight.w700),
                    KText(text: event.description!),
                    const Divider(),
                    const KText(text: 'Terms:', fontWeight: FontWeight.w700),
                    KText(text: event.terms != null ? event.terms! : 'There are no terms and conditions'),
                    const SizedBox(height: 20),
                    isSignedIn.value && event.joinedList!.any((element) => element == adminController.admin?.uid)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const KText(text: 'Joined', fontWeight: FontWeight.bold, fontSize: 16, color: kMainColor),
                              const KText(text: 'Your college is the part of this event'),
                              const Divider(),
                              const KText(text: 'Payment information', fontWeight: FontWeight.w600, fontSize: 14),
                              const SizedBox(height: 4),
                              KText(text: 'Account Title: ${adminController.admin?.bankAccountTitle}'),
                              KText(text: 'Account IBAN: ${adminController.admin?.bankIBAN}'),
                              KText(text: 'Bank Name: ${adminController.admin?.bankName}'),
                            ],
                          )
                        : KTextHeavyButton(
                            isEnable: true.obs,
                            lable: 'Join Now',
                            onTap: () async {
                              if (isSignedIn.value) {
                                final result = await showOkCancelAlertDialog(
                                    context: context,
                                    title: 'Terms',
                                    message:
                                        'Event entry fee is Rs: ${event.entryFee}\nYou must have to pay after joining and send the screenshot of payment to email address or WhatsApp',
                                    okLabel: 'Join');
                                if (result.name == 'ok') {
                                  await DBServices().joinEvent(eventId, adminController.admin!.uid!);

                                  await showOkAlertDialog(
                                      context: context,
                                      title: 'Successful',
                                      message: 'You\'ve joined the event successfuly');
                                }
                              } else {
                                final result = await showOkCancelAlertDialog(
                                    context: context,
                                    title: 'Alert',
                                    message:
                                        'Ask your sports Admin to login and join the event or if you are the Admin then login now',
                                    okLabel: 'Login');
                                if (result.name == 'ok') {
                                  Get.to(() => LoginView());
                                }
                              }
                            },
                            height: 40,
                            width: double.infinity,
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
