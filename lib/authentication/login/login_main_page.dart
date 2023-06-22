import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/authentication/login/password_reset.dart';
import 'package:smart_doctor/authentication/user_options.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../generated/assets.dart';
import '../../state/navigation_state.dart';
import '../signup/doctor_sign_up.dart';
import '../signup/user_sign_up.dart';
import 'login_page.dart';

class LoginMainPage extends ConsumerWidget {
  const LoginMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ref.watch(authIndexProvider) == 0) const UserAuthOptions(),
                if (ref.watch(authIndexProvider) == 1) const UserLogin(),
                if (ref.watch(authIndexProvider) == 2) const PasswordReset(),
                if (ref.watch(authIndexProvider) == 3) const UserSignUp(),
                if (ref.watch(authIndexProvider) == 4) const DoctorSignUp(),
                if (ref.watch(authIndexProvider) == 1)
                  RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: normalText(color: Colors.black),
                        children: [
                          TextSpan(
                              text: 'Sign Up',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (ref.watch(authIndexProvider) == 1 &&
                                      ref.watch(userTypeProvider) == 'User') {
                                    ref.read(authIndexProvider.notifier).state =
                                        3;
                                  } else {
                                    ref.read(authIndexProvider.notifier).state =
                                        4;
                                  }
                                },
                              style: normalText(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold))
                        ]),
                  ),
                if (ref.watch(authIndexProvider) == 3)
                  RichText(
                    text: TextSpan(
                        text: 'Already have an account? ',
                        style: normalText(color: Colors.black),
                        children: [
                          TextSpan(
                              text: 'Login',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  ref.read(authIndexProvider.notifier).state =
                                      1;
                                },
                              style: normalText(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold))
                        ]),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
