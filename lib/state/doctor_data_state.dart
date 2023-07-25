import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../models/doctor_model.dart';
import '../services/firebase_auth.dart';
import '../services/firebase_fireStore.dart';
import '../services/firebase_storage.dart';
import 'data_state.dart';
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
      await FirebaseAuthService.updateUserDisplayName('doctor');
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
