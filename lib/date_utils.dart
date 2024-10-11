import 'package:intl/intl.dart';

class DateTimeUtils {
  static final dateFormat = DateFormat.yMd();
  static final monthFormat = DateFormat.yM();
  static final yearFormat = DateFormat.y();

  static String getFormattedDateFromMilli(int milliseconds) {
    var date =
    DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return getFormattedDateFromDateTime(date);
  }

  static String getFormattedDateFromDateTime(DateTime dateTime) {
    var formattedDate = dateFormat.format(dateTime);
    return formattedDate;
  }

  static String getFormattedMonthFromMilli(int milliseconds) {
    var date =
    DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return getFormattedMonthFromDateTime(date);
  }

  static String getFormattedMonthFromDateTime(DateTime dateTime) {
    var formattedMonth = monthFormat.format(dateTime);
    return formattedMonth;
  }
}