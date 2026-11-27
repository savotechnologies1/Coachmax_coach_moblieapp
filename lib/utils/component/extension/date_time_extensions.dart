import 'package:flutter/foundation.dart';

extension DateTimeApp on DateTime {
  bool isToday() {
    var now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  bool isYesterday() {
    var now = DateTime.now();
    return day == now.day - 1 && month == now.month && year == now.year;
  }

  bool isTomorrow() {
    var now = DateTime.now();
    return day == now.day + 1 && month == now.month && year == now.year;
  }

  bool isSameDay(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }
}

extension StringApp on String {
  DateTime toDateTime() {
    try {
      return DateTime.parse(this).toLocal();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return DateTime.now();
    }
  }
}
