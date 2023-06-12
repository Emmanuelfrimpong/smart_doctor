import 'package:flutter/material.dart';

void noReturnSendToPage(BuildContext context, Widget newPage) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => newPage),
      (route) => false);
}
