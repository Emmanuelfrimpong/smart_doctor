import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/home/home_page.dart';
import 'package:smart_doctor/home/user_home_page.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import 'package:smart_doctor/models/user_model.dart';
import 'package:smart_doctor/services/firebase_auth.dart';
import 'package:smart_doctor/services/firebase_fireStore.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../core/components/constants/strings.dart';
import '../../core/components/widgets/custom_button.dart';
import '../../core/components/widgets/custom_input.dart';
import '../../core/components/widgets/smart_dialog.dart';
import '../../core/functions.dart';
import '../../state/data_state.dart';
import '../../state/navigation_state.dart';

class UserLogin extends ConsumerStatefulWidget {
  const UserLogin({super.key});

  @override
  ConsumerState<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends ConsumerState<UserLogin> {
  final formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isPasswordVisible = true;

  final emailController =
      TextEditingController(text: 'emmanuelfrimpong07@gmail.com');
  final passwordController = TextEditingController(text: 'Fk@0548');
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          ref.read(authIndexProvider.notifier).state = 0;
                        },
                        icon: Icon(MdiIcons.arrowLeft),
                        label: const Text('Back')),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '${ref.watch(userTypeProvider)} Login'.toUpperCase(),
                  style: normalText(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFields(
                    hintText: 'Email',
                    prefixIcon: MdiIcons.email,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(emailReg).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        email = value;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFields(
                  hintText: 'Password',
                  prefixIcon: MdiIcons.lock,
                  obscureText: isPasswordVisible,
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? MdiIcons.eyeOffOutline
                          : MdiIcons.eyeOutline,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: 'Login'.toUpperCase(),
                  onPressed: () {
                    signUserIn();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    ref.read(authIndexProvider.notifier).state = 2;
                  },
                  child: Text(
                    'Forgot Password ?',
                    style: normalText(
                        fontSize: 15,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signUserIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      CustomDialog.showLoading(message: 'Signing in...');
      final user = await FirebaseAuthService().signIn(email!, password!);
      if (user != null) {
        if (user.emailVerified) {
          String? userType = user.phoneNumber;
          if (userType == 'Doctor') {
            DoctorModel? doctorModel =
                await FireStoreServices.getDoctor(user.uid);
            if (doctorModel != null) {
              ref.read(doctorProvider.notifier).setDoctor(doctorModel);
              CustomDialog.dismiss();
              if (mounted) {
                noReturnSendToPage(context, const HomePage());
              }
            } else {
              CustomDialog.showError(
                  title: 'Data Error',
                  message: 'Unable to get Doctor info, try again later');
            }
          } else {
            UserModel? userModel = await FireStoreServices.getUser(user.uid);
            if (userModel != null) {
              ref.read(userProvider.notifier).setUser(userModel);
              CustomDialog.dismiss();
              if (mounted) {
                noReturnSendToPage(context, const UserHomePage());
              }
            } else {
              CustomDialog.showError(
                  title: 'Data Error',
                  message: 'Unable to get User info, try again later');
            }
          }
        } else {
          await FirebaseAuthService.signOut();
          CustomDialog.dismiss();
          CustomDialog.showInfo(
              message:
                  'User Email account is not verified, visit you email ($email) to verify your account.',
              title: 'User Verification',
              onConfirmText: 'Send Link',
              onConfirm: () {
                sendVerification();
              });
        }
      } else {}
    }
  }

  void sendVerification() {
    FirebaseAuthService.sendEmailVerification();
    CustomDialog.dismiss();
    CustomDialog.showInfo(
        message:
            'Verification link has been sent to your email ($email), visit your email to verify your account.',
        title: 'User Verification',
        onConfirmText: 'Ok',
        onConfirm: () {
          CustomDialog.dismiss();
        });
  }
}
