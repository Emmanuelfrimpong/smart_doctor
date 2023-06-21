import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/constants/strings.dart';
import 'package:smart_doctor/core/components/widgets/custom_input.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/services/firebase_auth.dart';
import '../../core/components/widgets/custom_button.dart';
import '../../generated/assets.dart';
import '../../state/navigation_state.dart';
import '../../styles/styles.dart';

class PasswordReset extends ConsumerStatefulWidget {
  const PasswordReset({super.key});

  @override
  ConsumerState<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends ConsumerState<PasswordReset> {
  final formKey = GlobalKey<FormState>();
  String? email;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          elevation: 10,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            ref.read(authIndexProvider.notifier).state = 1;
                          },
                          icon: Icon(MdiIcons.arrowLeft),
                          label: const Text('Back')),
                    ],
                  ),
                  Image.asset(
                    Assets.logoLogoLarge,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Password Reset'.toUpperCase(),
                    style: normalText(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    hintText: 'Email',
                    prefixIcon: MdiIcons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(emailReg).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: 'Reset',
                    onPressed: () {
                      resetPassword();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void resetPassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      CustomDialog.showLoading(
        message: 'Sending password reset link...',
      );
      await FirebaseAuthService().resetPassword(email!);
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Password Reset',
        message: 'Password reset link sent to $email',
      );
    }
  }
}
