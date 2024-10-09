import 'package:intl/intl.dart';

String convertDateDotFormat(DateTime? dateToConvert) {
  final dateFormat = DateFormat('dd.MM.yyyy');
  if (dateToConvert == null) {
    return '00.00.00';
  } else {
    return dateFormat.format(dateToConvert);
  }
}

String convertDateDashFormat(DateTime? dateToConvert) {
  final dateFormat = DateFormat('dd-MM-yyyy');
  if (dateToConvert == null) {
    return '00-00-00';
  } else {
    return dateFormat.format(dateToConvert);
  }
}

String getDayName(String dateToUse) {
  DateTime date = DateTime.parse(dateToUse);
  String dayName = DateFormat('EEEE').format(date);

  return dayName;
}
