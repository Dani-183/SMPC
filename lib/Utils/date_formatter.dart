import 'package:intl/intl.dart';

String dateTimeToString(DateTime dateTime) {
  return DateFormat('hh:mm:a dd-MM-yyyy').format(dateTime);
}

String dateTimeToDateString(DateTime dateTime) {
  return DateFormat('dd-MM-yyyy').format(dateTime);
}
