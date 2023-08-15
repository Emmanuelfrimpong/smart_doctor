import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import 'package:url_launcher/url_launcher.dart';

void noReturnSendToPage(BuildContext context, Widget newPage) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => newPage),
      (route) => false);
}

void sendToPage(BuildContext context, Widget newPage) {
  Navigator.push(
      context, MaterialPageRoute(builder: (BuildContext context) => newPage));
}

//send to transparent page
void sendToTransparentPage(BuildContext context, Widget newPage) {
  Navigator.push(
      context,
      PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return newPage;
          }));
}

final listCat = [
  'hope',
  'marriage',
  'fear',
  'equality',
  'family',
  'faith',
  'failure'
];
String getRandomCat() {
  final random = Random();
  return listCat[random.nextInt(listCat.length)];
}

double getRandomRating() {
  final random = Random();
  // return random rating less than 10 and greater than 0.9 and with 1 decimal place
  return double.tryParse((random.nextDouble() * 9.1 + 0.9).toStringAsFixed(1))!;
}

List<DoctorModel> sortUsersByRating(List<DoctorModel> users) {
  users.sort((a, b) => b.rating!.compareTo(a.rating!));
  // return in descending order
  return users;
}

String getNumberOfTime(int dateTime) {
  final now = DateTime.now();
  final difference =
      now.difference(DateTime.fromMillisecondsSinceEpoch(dateTime));
  //get yesterday

  if (difference.inDays > 0 && difference.inDays < 2) {
    return "${difference.inDays} days ago";
  } else if (difference.inHours > 0 && difference.inHours < 24) {
    return "${difference.inHours} hours ago";
  } else if (difference.inMinutes > 0 && difference.inMinutes < 60) {
    return "${difference.inMinutes} minutes ago";
  } else if (difference.inSeconds > 0 && difference.inSeconds < 60) {
    return "${difference.inSeconds} seconds ago";
  } else if (difference.inSeconds == 0) {
    return "Just now";
  } else {
    //return date with format EEE, MMM d, yyyy
    return DateFormat('EEE, MMM d, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dateTime));
  }
}

extension TOD on TimeOfDay {
  DateTime toDateTime() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, 1, hour, minute);
  }
}

String getDateFromDate(int? dateTime) {
  if (dateTime != null) {
    return DateFormat('EEE, MMM d, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dateTime));
  } else {
    return '';
  }
}

String getTimeFromDate(int? dateTime) {
  if (dateTime != null) {
    return DateFormat('hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(dateTime));
  } else {
    return '';
  }
}

List<int> getRandomList(List<Map<String, dynamic>> data, int length) {
  final random = Random();
  List<int> list = [];
  for (int i = 0; i < length; i++) {
    list.add(data[random.nextInt(data.length)]['ID']);
  }
  return list;
}

// url launcher

void launchURL(String url) async {
  if (url.isNotEmpty) {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      CustomDialog.showError(title: 'Error', message: 'Could not launch $url');
    }
  }
}

String? dueIn(Map<String, dynamic> duration, BuildContext context) {
  List<dynamic> daysList = duration['days'];
  List<String> days = [];
  //loop through days and convert to DateTime String to only day name
  for (var day in daysList) {
    if (day != 'Monday' &&
        day != 'Tuesday' &&
        day != 'Wednesday' &&
        day != 'Thursday' &&
        day != 'Friday' &&
        day != 'Saturday' &&
        day != 'Sunday') {
      day = DateFormat('EEEE').format(DateTime.parse(day));
      days.add(day);
    } else {
      days.add(day);
    }
  }
  List<dynamic> times = duration['times'];
  // check days and get the nearest day
  final now = DateTime.now();
  final todayName = DateFormat('EEEE').format(now);
  final tomorrowName =
      DateFormat('EEEE').format(now.add(const Duration(days: 1))).toString();
  String day = '';
  for (var val in days) {
    if (val == todayName) {
      day = 'Today';
      break;
    } else if (val == tomorrowName) {
      day = 'Tomorrow';
      break;
    } else {
      day = val;
    }
  }
  // get earliest time from list
  TimeOfDay time = TimeOfDay(
      hour: int.parse(times[0].split(':')[0]),
      minute: int.parse(times[0].split(':')[1].toString().split(' ')[0] ));
  final timeNow = TimeOfDay.now();
  //convert String to TimeOfDay with format hh:mm a
  for (var val in times) {
    final timeOfDay = TimeOfDay(
        hour: int.parse(val.split(':')[0]),
        minute: int.parse(val.split(':')[1].toString().split(' ')[0]));
    //get find difference between time now and time of day
    final difference = timeOfDay.toDateTime().difference(timeNow.toDateTime());
    final difference2 = time.toDateTime().difference(timeNow.toDateTime());
    if (!difference.isNegative && (difference.inHours < difference2.inHours)) {
      time = timeOfDay;
      break;
    }
  }
  return 'Due in $day at ${time.format(context)}';
}

String getDueIn(TimeOfDay time) {
  // return due in hours, minutes or seconds or time of day
  final now = DateTime.now();
  final timeOfDay = time.toDateTime();
  final difference = timeOfDay.difference(now);
  if (difference.inDays > 0 && difference.inDays < 2) {
    return "Due in ${difference.inDays} days";
  } else if (difference.inHours > 0 && difference.inHours < 24) {
    return "Due in ${difference.inHours} hours";
  } else if (difference.inMinutes > 0 && difference.inMinutes < 60) {
    return "Due in ${difference.inMinutes} minutes";
  } else if (difference.inSeconds > 0 && difference.inSeconds < 60) {
    return "Due in ${difference.inSeconds} seconds";
  } else if (difference.inSeconds == 0) {
    return "Due now";
  } else {
    //return date with format EEE, MMM d, yyyy
    return "Due in ${DateFormat('EEE, MMM d, yyyy').format(timeOfDay)}";
  }
}

String getDay(String date) {
  if (date != 'Monday' &&
      date != 'Tuesday' &&
      date != 'Wednesday' &&
      date != 'Thursday' &&
      date != 'Friday' &&
      date != 'Saturday' &&
      date != 'Sunday') {
    date = DateFormat('EEEE').format(DateTime.parse(date));
    //return first 3 letters of day
    return date.substring(0, 3);
  } else {
    return date.substring(0, 3);
  }
}
