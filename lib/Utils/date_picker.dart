import 'package:flutter/cupertino.dart';

Future<dynamic> dobPicker(BuildContext context, Function(DateTime) onDateChange, VoidCallback onDone) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        SizedBox(
          height: 150,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            minimumDate: DateTime(DateTime.now().year - 80),
            maximumDate: DateTime(DateTime.now().year - 18),
            initialDateTime: DateTime(DateTime.now().year - 20),
            onDateTimeChanged: onDateChange,
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: onDone,
        child: const Text('Done'),
      ),
    ),
  );
}

Future<dynamic> datePicker(BuildContext context,
    {required Function(DateTime) onDateChange, required VoidCallback onDone}) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      actions: [
        SizedBox(
          height: 150,
          child: CupertinoTheme(
            data: const CupertinoThemeData(brightness: Brightness.light),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              minimumDate: DateTime.now(),
              maximumDate: DateTime(DateTime.now().year + 2),
              initialDateTime: DateTime.now(),
              onDateTimeChanged: onDateChange,
            ),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: onDone,
        child: const Text('Done'),
      ),
    ),
  );
}
