import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/constants/strings.dart';
import 'package:smart_doctor/core/components/widgets/custom_button.dart';
import 'package:smart_doctor/core/components/widgets/custom_drop_down.dart';
import 'package:smart_doctor/core/components/widgets/custom_input.dart';
import 'package:smart_doctor/state/data_state.dart';
import '../../generated/assets.dart';
import '../../state/navigation_state.dart';
import '../../state/user_data_state.dart';
import '../../styles/styles.dart';

class UserSignUp extends ConsumerStatefulWidget {
  const UserSignUp({super.key});

  @override
  ConsumerState<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends ConsumerState<UserSignUp> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(20),
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  TextButton.icon(
                      onPressed: () {
                        if (ref.watch(userSignUpPageIndexProvider) == 0) {
                          ref.read(authIndexProvider.notifier).state = 1;
                        } else {
                          ref.read(userSignUpPageIndexProvider.notifier).state =
                              0;
                        }
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
                'New User'.toUpperCase(),
                style: normalText(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: ref.watch(userSignUpPageIndexProvider) == 0
                      ? const UserPersonalInfo()
                      : const UserHealthInfo()),
            ],
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
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    // wait for widget to build before calling the function
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.read(userProvider);
      fullNameController.text = user.name ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.phone ?? '';
      addressController.text = user.address ?? '';
      passwordController.text = user.password ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Personal Information',
              style: normalText(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => _pickImage(),
                  child: Container(
                    width: 150,
                    height: 150,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                      image: ref.watch(userImageProvider) != null
                          ? DecorationImage(
                              image: FileImage(ref.watch(userImageProvider)!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: const Text('Select Image'),
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
              controller: fullNameController,
              prefixIcon: MdiIcons.account,
              onSaved: (value) {
                ref.read(userProvider.notifier).setUserName(value!);
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
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) {
                ref.read(userProvider.notifier).setUserEmail(value!);
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
              controller: phoneController,
              prefixIcon: MdiIcons.phone,
              isDigitOnly: true,
              keyboardType: TextInputType.number,
              onSaved: (value) {
                ref.read(userProvider.notifier).setUserPhone(value!);
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
              icon: MdiIcons.genderNonBinary,
              value: ref.watch(userProvider).gender,
              items: ['Male', 'Female']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              validator: (value) {
                if (value == null) {
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
              controller: addressController,
              onSaved: (value) {
                ref.read(userProvider.notifier).setUserAddress(value!);
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
              controller: passwordController,
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
              onSaved: (value) {
                ref.read(userProvider.notifier).setUserPassword(value!);
              },
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'Please enter a valid password';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                text: 'Continue',
                icon: MdiIcons.arrowRight,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    ref.read(userSignUpPageIndexProvider.notifier).state = 1;
                  }
                })
          ],
        ),
      ),
    );
  }

  _pickImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: Icon(MdiIcons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                );
                if (pickedFile != null) {
                  ref.read(userImageProvider.notifier).state =
                      File(pickedFile.path);
                }
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.image),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                );
                if (pickedFile != null) {
                  ref.read(userImageProvider.notifier).state =
                      File(pickedFile.path);
                }
              },
            ),
          ],
        ),
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
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // wait for widget to be rendered before calling the function
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.read(userProvider);
      weightController.text = user.weight != null ? user.weight.toString() : '';
      heightController.text = user.height != null ? user.height.toString() : '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Health & Location Information',
              style: normalText(
                  color: Colors.black54,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextFields(
              hintText: 'Height (cm)',
              controller: heightController,
              prefixIcon: MdiIcons.humanMaleHeight,
              isDigitOnly: true,
              keyboardType: TextInputType.number,
              onSaved: (value) {
                ref.read(userProvider.notifier).setUserHeight(value!);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your height';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFields(
              hintText: 'Weight (kg)',
              prefixIcon: MdiIcons.weight,
              controller: weightController,
              isDigitOnly: true,
              keyboardType: TextInputType.number,
              onSaved: (value) {
                ref.read(userProvider.notifier).setUserWeight(value!);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your weight';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomDropDown(
              hintText: 'Blood Type',
              icon: MdiIcons.bloodBag,
              value: ref.watch(userProvider).bloodType,
              items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Blood Type is required';
                }
                return null;
              },
              onChanged: (value) {
                ref.read(userProvider.notifier).setUserBloodType(value);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomDropDown(
              hintText: 'Medical History',
              icon: MdiIcons.history,
              value: ref.watch(userProvider).medicalHistory,
              items: [
                'None',
                'Covid 19',
                'Diabetes',
                'High Blood Pressure',
                'Heart Disease',
                'Asthma',
                'Cancer',
                'HIV',
                'Kidney Disease',
                'Liver Disease',
                'Stroke',
                'Thyroid Disease',
                'Tuberculosis',
                'Other'
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Medical History is required';
                }
                return null;
              },
              onChanged: (value) {
                ref.read(userProvider.notifier).setUserMedicalHistory(value);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomDropDown(
              hintText: 'Vaccination Status',
              icon: MdiIcons.stateMachine,
              value: ref.watch(userProvider).vaccinationStatus,
              items: ['None', 'Partial', 'Full']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Vaccination Status is required';
                }
                return null;
              },
              onChanged: (value) {
                ref.read(userProvider.notifier).setUserVaccinationStatus(value);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              text: 'Create User',
              icon: MdiIcons.accountPlus,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  ref.read(userProvider.notifier).createUser(ref);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
