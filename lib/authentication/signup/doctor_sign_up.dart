import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/state/data_state.dart';
import '../../core/components/constants/strings.dart';
import '../../core/components/widgets/custom_button.dart';
import '../../core/components/widgets/custom_drop_down.dart';
import '../../core/components/widgets/custom_input.dart';
import '../../core/components/widgets/smart_dialog.dart';
import '../../generated/assets.dart';
import '../../state/doctor_data_state.dart';
import '../../state/navigation_state.dart';
import '../../styles/styles.dart';

class DoctorSignUp extends ConsumerStatefulWidget {
  const DoctorSignUp({super.key});

  @override
  ConsumerState<DoctorSignUp> createState() => _DoctorSignUpState();
}

class _DoctorSignUpState extends ConsumerState<DoctorSignUp> {
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
                        if (ref.watch(doctorSignUpPageIndexProvider) == 0) {
                          ref.read(authIndexProvider.notifier).state = 1;
                        } else {
                          ref
                              .read(doctorSignUpPageIndexProvider.notifier)
                              .state = 0;
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
                'New Doctor'.toUpperCase(),
                style: normalText(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: ref.watch(doctorSignUpPageIndexProvider) == 0
                      ? const UserPersonalInfo()
                      : const WorkInformation()),
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
      var doctor = ref.read(doctorProvider);
      fullNameController.text = doctor.name ?? '';
      emailController.text = doctor.email ?? '';
      phoneController.text = doctor.phone ?? '';
      addressController.text = doctor.address ?? '';
      passwordController.text = doctor.password ?? '';
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
                      image: ref.watch(doctorImageProvider) != null
                          ? DecorationImage(
                              image: FileImage(ref.watch(doctorImageProvider)!),
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
                ref.read(doctorProvider.notifier).setUserName(value!);
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
                ref.read(doctorProvider.notifier).setUserEmail(value!);
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
                ref.read(doctorProvider.notifier).setUserPhone(value!);
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
              value: ref.watch(doctorProvider).gender,
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
                ref.read(doctorProvider.notifier).setUserGender(value);
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
                ref.read(doctorProvider.notifier).setUserAddress(value!);
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
                ref.read(doctorProvider.notifier).setUserPassword(value!);
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
                    ref.read(doctorSignUpPageIndexProvider.notifier).state = 1;
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
                  ref.read(doctorImageProvider.notifier).state =
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
                  ref.read(doctorImageProvider.notifier).state =
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

class WorkInformation extends ConsumerStatefulWidget {
  const WorkInformation({super.key});

  @override
  ConsumerState<WorkInformation> createState() => __WorkInformationStateState();
}

class __WorkInformationStateState extends ConsumerState<WorkInformation> {
  final formKey = GlobalKey<FormState>();
  final specializationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'License Information',
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
            InkWell(
              onTap: () => _pickIdImage(),
              child: Container(
                height: 150,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                  image: ref.watch(idImageProvider) != null
                      ? DecorationImage(
                          image: FileImage(ref.watch(idImageProvider)!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: const Text('Select ID Image'),
              ),
            ),
            Text(
              'Select a clear image of your ID card (Only front side)',
              style: normalText(color: Colors.grey, fontSize: 12),
            ),
            InkWell(
              onTap: () => _pickCertificateImage(),
              child: Container(
                height: 150,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[400],
                  image: ref.watch(certificateProvider) != null
                      ? DecorationImage(
                          image: FileImage(ref.watch(certificateProvider)!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: const Text('Select Certificate Image'),
              ),
            ),
            Text(
              'Select a clear image of your License Certificate (Only image is allowed)',
              style: normalText(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomDropDown(
              hintText: 'Select Hospital',
              icon: MdiIcons.hospitalBuilding,
              items: ['AAMUSTED Clinic', 'Kwadaso SDA Hospital']
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: normalText(),
                      )))
                  .toList(),
              onChanged: (value) {
                ref
                    .read(doctorProvider.notifier)
                    .setHospital(value!.toString());
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a hospital';
                }
                return null;
              },
              value: ref.watch(doctorProvider).hospital,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomDropDown(
              hintText: 'Specialization',
              items: ['Dentist', 'Psychiatrist', 'Surgeon', 'Physician']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              value: ref.watch(doctorProvider).specialty,
              onChanged: (value) {
                ref.read(doctorProvider.notifier).setSpecialization(value!);
              },
              validator: (value) {
                if (value == null) {
                  return 'Please enter your specialization';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              text: 'Create Account',
              icon: MdiIcons.accountPlus,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  if (ref.watch(idImageProvider) != null &&
                      ref.watch(certificateProvider) != null) {
                    ref.read(doctorProvider.notifier).createDoctor(ref);
                  } else {
                    CustomDialog.showError(
                      title: 'Incomplete data',
                      message: 'Please select ID and Certificate images',
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }

  _pickIdImage() {
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
                  ref.read(idImageProvider.notifier).state =
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
                  ref.read(idImageProvider.notifier).state =
                      File(pickedFile.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _pickCertificateImage() {
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
                  ref.read(certificateProvider.notifier).state =
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
                  ref.read(certificateProvider.notifier).state =
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
