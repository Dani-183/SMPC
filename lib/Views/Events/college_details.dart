import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:smpc/Models/admin_model.dart';
import 'package:smpc/Views/Widgets/widgets.dart';

import '../../constants/constants.dart';

class CollegeDetails extends StatelessWidget {
  const CollegeDetails({Key? key, required this.admin}) : super(key: key);
  final AdminModel admin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('College Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              UserCircularImage(imageURL: admin.image, radius: 150),
              KeyValueRow(title: 'Name', text: admin.name, isDecorated: true),
              KeyValueRow(title: 'Location', text: admin.location),
              KeyValueRow(title: 'Phone #', text: admin.phoneNo, isDecorated: true),
              KeyValueRow(title: 'Email', text: admin.email),
              KeyValueRow(title: 'About', text: admin.aboutCollege, isDecorated: true),
            ],
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
            child: KText(text: '$title', fontSize: 14),
          ),
          Expanded(
            child: KText(text: '$text', fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
