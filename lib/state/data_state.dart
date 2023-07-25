import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/services/firebase_auth.dart';
import 'package:smart_doctor/services/firebase_fireStore.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../models/doctor_model.dart';
import '../models/user_model.dart';
import '../services/firebase_storage.dart';
import 'navigation_state.dart';

final doctorProvider = StateNotifierProvider<DoctorProvider, DoctorModel>(
    (ref) => DoctorProvider());

class DoctorProvider extends StateNotifier<DoctorModel> {
  DoctorProvider() : super(DoctorModel());

  void setDoctor(DoctorModel doctor) {
    state = doctor;
  }

  void setUserName(String s) {
    // check if name start with Dr.
    if (s.startsWith('Dr.')) {
      state = state.copyWith(name: s);
    } else {
      state = state.copyWith(name: 'Dr. $s');
    }
    state = state.copyWith(name: s);
  }

  void setUserEmail(String s) {
    state = state.copyWith(email: s);
  }

  void setUserPhone(String s) {
    state = state.copyWith(phone: s);
  }

  void setUserGender(String g) {
    state = state.copyWith(gender: g);
  }

  void setUserAddress(String s) {
    state = state.copyWith(address: s);
  }

  void setUserPassword(String s) {
    state = state.copyWith(password: s);
  }

  void setHospital(String string) {
    state = state.copyWith(hospital: string);
  }

  void setSpecialization(String s) {
    state = state.copyWith(specialty: s);
  }

  void createDoctor(WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Creating Doctor... Please wait');
    // create user account using email and password
    state = state.copyWith(createdAt: DateTime.now().millisecondsSinceEpoch);
    final user = await FirebaseAuthService.createUserWithEmailAndPassword(
        state.email!, state.password!);
    if (user != null) {
      state = state.copyWith(id: user.uid);
      // save user profile if it is not null
      state = state.copyWith(id: user.uid);
      var profile = ref.watch(doctorImageProvider);
      if (profile != null) {
        //save user image to cloud storage
        final userImageUrl = await CloudStorageServices.saveUserImage(
            profile, state.id.toString());
        state = state.copyWith(profile: userImageUrl);
      }
      //send verification email
      await FirebaseAuthService.sendEmailVerification();
      //save doctor id and certification to firestore
      final idImage = ref.watch(idImageProvider);
      final certificateImage = ref.watch(certificateProvider);

      if (idImage != null && certificateImage != null) {
        final idImageUrl =
            await CloudStorageServices.saveFiles(idImage, state.id.toString());
        final certificateImageUrl = await CloudStorageServices.saveFiles(
            certificateImage, state.id.toString());
        state = state.copyWith(
            idImage: idImageUrl, certificateImage: certificateImageUrl);
      }
      //save user to firestore
      final String response = await FireStoreServices.saveDoctor(state);
      if (response == 'success') {
        await FirebaseAuthService.updateUserProfile(
            userType: ref.watch(userTypeProvider));
        // clear all states
        ref.read(doctorProvider.notifier).state = DoctorModel();
        await FirebaseAuthService.signOut();
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
          title: 'Success',
          message:
              'Doctor created successfully\n A verification email has been sent to your email address\n Please verify your email address to login',
        );
        ref.read(authIndexProvider.notifier).state = 1;
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
            title: 'Error',
            message: 'Error creating doctor account. Please try again');
      }
    }
  }
}

final userProvider =
    StateNotifierProvider<UserProvider, UserModel>((ref) => UserProvider());

class UserProvider extends StateNotifier<UserModel> {
  UserProvider() : super(UserModel());

  void setUser(UserModel user) {
    state = user;
  }

  void setUserName(String value) {
    state = state.copyWith(name: value);
  }

  void setUserEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setUserPhone(String value) {
    state = state.copyWith(phone: value);
  }

  void setUserPassword(String value) {
    state = state.copyWith(password: value);
  }

  void setUserGender(value) {
    state = state.copyWith(gender: value);
  }

  void setUserAddress(String value) {
    state = state.copyWith(address: value);
  }

  void setUserHeight(String s) {
    var height = double.tryParse(s);
    state = state.copyWith(height: height);
  }

  void setUserWeight(String s) {
    var weight = double.tryParse(s);
    state = state.copyWith(weight: weight);
  }

  void setUserBloodType(String value) {
    state = state.copyWith(bloodType: value);
  }

  void setUserMedicalHistory(value) {
    state = state.copyWith(medicalHistory: value);
  }

  void setUserVaccinationStatus(value) {
    state = state.copyWith(vaccinationStatus: value);
  }

  void createUser(WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Creating User... Please wait');
    final userImage = ref.watch(userImageProvider);
    state = state.copyWith(createdAt: DateTime.now().millisecondsSinceEpoch);
    //create user in firebase auth
    final user = await FirebaseAuthService.createUserWithEmailAndPassword(
        state.email!, state.password!);
    if (user != null) {
      //send verification email
      await FirebaseAuthService.sendEmailVerification();
      state = state.copyWith(id: user.uid);
      //save user image to cloud storage
      if (userImage != null) {
        final userImageUrl = await CloudStorageServices.saveUserImage(
            userImage, state.id.toString());
        state = state.copyWith(profile: userImageUrl);
      }
      //save user to firestore
      final String response = await FireStoreServices.saveUser(state);
      if (response == 'success') {
        //? UPDATE user profile
        await FirebaseAuthService.updateUserProfile(
            userType: ref.watch(userTypeProvider));
        // clear all states
        ref.read(userProvider.notifier).state = UserModel();
        await FirebaseAuthService.signOut();
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
          title: 'Success',
          message:
              'User created successfully\n A verification email has been sent to your email address\n Please verify your email address to login',
        );
        ref.read(authIndexProvider.notifier).state = 1;
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
          title: 'Error',
          message: response,
        );
      }
    }
  }
}

final userImageProvider = StateProvider<File?>((ref) => null);
final doctorImageProvider = StateProvider<File?>((ref) => null);
final idImageProvider = StateProvider<File?>((ref) => null);
final certificateProvider = StateProvider<File?>((ref) => null);
final userTypeProvider = StateProvider<String?>((ref) => null);

final searchQueryProvider = StateProvider<String>((ref) => '');