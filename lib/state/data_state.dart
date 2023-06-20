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
