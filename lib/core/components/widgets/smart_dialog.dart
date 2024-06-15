import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../styles/colors.dart';
import '../constants/enums.dart';

class CustomDialog {
  static void showLoading({required String message}) {
    SmartDialog.showLoading(
      msg: message,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 10),
          Text(
            message,
            style: GoogleFonts.openSans(
              color: primaryColor,
            ),
          ),
        ]),
      ),
    );
  }

  static void dismiss() {
    SmartDialog.dismiss();
  }

  static void showToast({
    required String message,
    ToastType type = ToastType.success,
  }) {
    SmartDialog.showToast(
      message,
      alignment:
         Alignment.bottomCenter,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(
            type == ToastType.success
                ? Icons.check_circle
                : type == ToastType.error
                    ? Icons.error
                    : type == ToastType.warning
                        ? Icons.warning
                        : Icons.info,
            color: type == ToastType.success
                ? Colors.green
                : type == ToastType.error
                    ? Colors.red
                    : type == ToastType.warning
                        ? Colors.yellow
                        : Colors.blue,
          ),
          const SizedBox(width: 10),
          Text(
            message,
            style: GoogleFonts.openSans(
              color: type == ToastType.success
                  ? Colors.green
                  : type == ToastType.error
                      ? Colors.red
                      : type == ToastType.warning
                          ? Colors.yellow
                          : Colors.blue,
            ),
          ),
        ]),
      ),
    );
  }

  static void showError({required String title, String? message}) {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: 320,
          height: 180,
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                if (message != null)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style:
                        GoogleFonts.openSans(color: Colors.black, fontSize: 16),
                  ),
                const Spacer(),
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black26, width: 1.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: TextButton(
                        onPressed: () => SmartDialog.dismiss(),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.all(10)),
                        ),
                        child: Text(
                          'Okay',
                          style: GoogleFonts.openSans(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showSuccess(
      {required String title, String? message, Function? onOkayPressed}) {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: 320,
          height: 180,
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                if (message != null)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style:
                        GoogleFonts.openSans(color: Colors.black, fontSize: 16),
                  ),
                const Spacer(),
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black26, width: 1.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: TextButton(
                        onPressed: () {
                          SmartDialog.dismiss();
                          if (onOkayPressed != null) {
                            onOkayPressed();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.all(10)),
                        ),
                        child: Text(
                          'Okay',
                          style: GoogleFonts.openSans(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showInfo(
      {required String title,
      String? message,
      VoidCallback? onConfirm,
      required String onConfirmText,
      String? buttonText2,
      VoidCallback? onPressed2}) async {
    SmartDialog.show(
      maskColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: 320,
          height: 180,
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style:
                        GoogleFonts.openSans(color: Colors.black, fontSize: 16),
                  ),
                ),
              const Spacer(),
              Container(
                height: 40,
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black26, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: onConfirm,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
                        padding:
                            WidgetStateProperty.all(const EdgeInsets.all(10)),
                      ),
                      child: Text(
                        onConfirmText,
                        style: GoogleFonts.openSans(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    const VerticalDivider(
                      color: Colors.black26,
                      thickness: 1.5,
                    ),
                    Expanded(
                        child: TextButton(
                      onPressed: () => SmartDialog.dismiss(),
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
                        padding:
                            WidgetStateProperty.all(const EdgeInsets.all(10)),
                      ),
                      child: Text(
                        buttonText2 ?? 'Cancel',
                        style: GoogleFonts.openSans(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showCustom(
      {required Widget ui, SmartDialogController? controller}) async {
    SmartDialog.show(
      controller: controller,
      maskColor: Colors.transparent,
      builder: (_) {
        return ui;
      },
    );
  }

  static Future<void> showImageDialog({String? path}) async {
    SmartDialog.show(
      builder: (_) {
        return SafeArea(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        CustomDialog.dismiss();
                      },
                      child: Text('Close',
                          style: GoogleFonts.openSans(color: Colors.red, fontSize: 22))),
                  const SizedBox(height: 10),
                  Image.network(path!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
