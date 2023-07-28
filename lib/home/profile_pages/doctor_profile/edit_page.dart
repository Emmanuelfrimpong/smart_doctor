import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/state/doctor_data_state.dart';
import '../../../core/components/widgets/custom_button.dart';
import '../../../core/components/widgets/custom_input.dart';
import '../../../state/data_state.dart';

class DoctorProfileEditPage extends ConsumerStatefulWidget {
  const DoctorProfileEditPage({super.key});

  @override
  ConsumerState<DoctorProfileEditPage> createState() =>
      _DoctorProfileEditPageState();
}

class _DoctorProfileEditPageState extends ConsumerState<DoctorProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _aboutController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  String? region;
  File? imageFile;
  String? userProfile;
  @override
  void initState() {
    //check if widget is build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.read(doctorProvider);
      _nameController.text = user.name ?? '';
      _aboutController.text = user.about ?? '';
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
      setState(() {
        userProfile = user.profile ?? '';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            //edit profile image,name,phone number, and bio only
            const SizedBox(height: 20),
            //circle avatar image
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
                        image: userProfile != null && imageFile == null
                            ? DecorationImage(
                                image: NetworkImage(userProfile!),
                                fit: BoxFit.cover,
                              )
                            : imageFile != null
                                ? DecorationImage(
                                    image: FileImage(imageFile!),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                    child: const Text('Profile Image'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: SizedBox(
                    height: 150,
                    child: Text(
                      'Choose a clear and high-quality photo: Your profile picture should be sharp, well-lit, and visually appealing.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
              controller: _nameController,
              onSaved: (name) {
                ref.read(doctorProvider.notifier).setUserName(name!);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid name';
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
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onSaved: (phone) {
                ref.read(doctorProvider.notifier).setUserPhone(phone!);
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
            CustomTextFields(
              hintText: 'Address',
              prefixIcon: MdiIcons.home,
              controller: _addressController,
              onSaved: (address) {
                ref.read(doctorProvider.notifier).setUserAddress(address!);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid address';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFields(
              hintText: 'About you',
              controller: _aboutController,
              prefixIcon: MdiIcons.account,
              maxLines: 4,
              keyboardType: TextInputType.text,
              onSaved: (value) {
                ref.read(doctorProvider.notifier).setAbout(value!);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                  text: 'Update Profile',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ref.read(doctorProvider.notifier).updateUser(
                            ref,
                            imageFile: imageFile,
                            name: _nameController.text,
                            dob: _dobController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                            city: _cityController.text,
                            region: region!,
                            about: _aboutController.text,
                          );
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
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
