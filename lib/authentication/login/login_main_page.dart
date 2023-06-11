import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/authentication/user_options.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../state/navigation_state.dart';
import 'login_page.dart';

class LoginMainPage extends ConsumerWidget {
  const LoginMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IndexedStack(
              index: ref.watch(authIndexProvider),
              children:const[
                UserAuthOptions(),
                UserLogin(),
              ]
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(text: TextSpan(
              text: 'Don\'t have an account? ',
              style: normalText(color: Colors.black),
              children: [
                TextSpan(
                  text: 'Sign Up',
                  recognizer: TapGestureRecognizer()..onTap=(){
                    if(ref.watch(authIndexProvider)==1){
                      ref.read(authIndexProvider.notifier).state=3;
                    }else{
                      ref.read(authIndexProvider.notifier).state=4;
                    }
                  },
                  style: normalText(color: primaryColor, fontWeight: FontWeight.bold)
                )
              ]
            ),)
          ],
        ),
      ),
    );
  }
}
