import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/components/constants/strings.dart';
import 'package:smart_doctor/components/widgets/custom_input.dart';
import 'package:smart_doctor/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/services/firebase_auth.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../components/widgets/custom_button.dart';
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
                    TextButton.icon(onPressed: (){
                      ref.read(authIndexProvider.notifier).state=0;
                    }, icon: Icon(MdiIcons.arrowLeft), label:const Text('Back')),
                  ],
                ),
                SizedBox(
                  height: 30,),
                Text(
                  'User Login'.toUpperCase(),
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
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, forgotPasswordRoute);
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
      final user= await FirebaseAuthService().signIn(email!, password!);
      if(user!=null){

      }else{
        CustomDialog.dismiss();
      }
    }
  }
}