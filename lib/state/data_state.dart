import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doctor_model.dart';
import '../models/user_model.dart';

final doctorProvider = StateNotifierProvider<DoctorProvider, DoctorModel>(
    (ref) => DoctorProvider());

class DoctorProvider extends StateNotifier<DoctorModel> {
  DoctorProvider() : super(DoctorModel());

  void setDoctor(DoctorModel doctor) {
    state = doctor;
  }
}

final userProvider = StateNotifierProvider<UserProvider, UserModel>(
    (ref) => UserProvider());

class UserProvider  extends StateNotifier<UserModel> {
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

}