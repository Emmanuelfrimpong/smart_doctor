import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/constants/strings.dart';
import 'package:smart_doctor/core/components/widgets/custom_drop_down.dart';
import 'package:smart_doctor/core/components/widgets/custom_input.dart';
import 'package:smart_doctor/state/data_state.dart';

import '../../state/navigation_state.dart';
import '../../styles/styles.dart';

class UserSignup extends ConsumerStatefulWidget {
  const UserSignup({super.key});

  @override
  ConsumerState<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends ConsumerState<UserSignup> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(20),
      child: Container(
        constraints:  BoxConstraints( maxHeight: size.height *0.8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListTile(
            title: Column(
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
                  height: 10,
                ),
                Text(
                  'New User'.toUpperCase(),
                  style: normalText(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),

              ],
            ),
            subtitle: SingleChildScrollView(
              child:index==0? const UserPersonalInfo(): const UserHealthInfo(),
            ),
          ),
        ),
      ),
    );
  }
}

class UserPersonalInfo extends ConsumerStatefulWidget {
  const UserPersonalInfo({super.key});

  @override
  ConsumerState<UserPersonalInfo> createState() => _UserPersonalInfoState();
}

class _UserPersonalInfoState extends ConsumerState<UserPersonalInfo> {
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Text(
            'Personal Information',
            style: normalText(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 2,color: Colors.grey,),

          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Expanded(
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Choose a clear and high-quality photo: Your profile picture should be sharp, well-lit, and visually appealing.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Update your picture periodically: As time goes by, you may want to update your profile picture to reflect any changes in your appearance or personal branding.',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFields(
            hintText: 'Full Name',
            prefixIcon: MdiIcons.account,
            onChanged: (value) {
              ref.read(userProvider.notifier).setUserName(value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFields(
            hintText: 'Email Address',
            prefixIcon: MdiIcons.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              ref.read(userProvider.notifier).setUserEmail(value);
            },
            validator: (value) {
              if (value!.isEmpty || !RegExp(emailReg).hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFields(
            hintText: 'Phone Number',
            prefixIcon: MdiIcons.phone,
            isDigitOnly: true,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              ref.read(userProvider.notifier).setUserPhone(value);
            },
            validator: (value) {
              if (value!.length != 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          CustomDropDown(
            hintText: 'User Gender',
              items: ['Male', 'Female']

                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
            validator: (value){
                if(value==null){
                  return 'User Gender is required';
                }
                return null;
            },
            onChanged: (value) {
              ref.read(userProvider.notifier).setUserGender(value);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFields(
            hintText: 'Living Address',
            prefixIcon: MdiIcons.home,
            maxLines: 2,
            onChanged: (value) {
              ref.read(userProvider.notifier).setUserAddress(value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your living address';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFields(
            hintText: 'Password',
            prefixIcon: MdiIcons.lock,
            obscureText: passwordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? MdiIcons.eye : MdiIcons.eyeOff,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
            onChanged: (value) {
              ref.read(userProvider.notifier).setUserPassword(value);
            },
            validator: (value) {
              if (value!.isEmpty || value.length < 6) {
                return 'Please enter a valid password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class UserHealthInfo extends ConsumerStatefulWidget {
  const UserHealthInfo({super.key});

  @override
  ConsumerState<UserHealthInfo> createState() => _UserHealthInfoState();
}

class _UserHealthInfoState extends ConsumerState<UserHealthInfo> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
