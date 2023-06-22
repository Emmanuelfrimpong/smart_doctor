import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_doctor/models/user_model.dart';

import '../models/doctor_model.dart';
import '../models/health_tips.dart';

class FireStoreServices {
  static final _fireStore = FirebaseFirestore.instance;

  static Future<DoctorModel?> getDoctor(String id) async {
    final doctor = await _fireStore.collection('doctors').doc(id).get();
    return DoctorModel.fromMap(doctor.data()!);
  }

  static Future<UserModel?> getUser(String uid) async {
    final user = await _fireStore.collection('users').doc(uid).get();
    return UserModel.fromMap(user.data()!);
  }

  // save user to firebase
  static Future<String> saveUser(UserModel user) async {
    final response = await _fireStore
        .collection('users')
        .doc(user.id)
        .set(user.toMap())
        .then((value) => 'success')
        .catchError((error) => error.toString());
    return response;
  }

  // get tips from firebase
  static Future<TipsModel> getTips() async {
    var data = await _fireStore.collection('tips').get();
    // randomly get a tip
    var random = data.docs.toList()[0];
    return TipsModel.fromMap(random.data());
  }

  // save tips to firebase
  static Future<String> saveTips(TipsModel tips) async {
    final response = await _fireStore
        .collection('tips')
        .doc(tips.id)
        .set(tips.toMap())
        .then((value) => 'success')
        .catchError((error) => error.toString());
    return response;
  }

  static Future<String> saveDoctor(DoctorModel state) async {
    final response = await _fireStore
        .collection('doctors')
        .doc(state.id)
        .set(state.toMap())
        .then((value) => 'success')
        .catchError((error) => error.toString());
    return response;
  }

  //get app
}
