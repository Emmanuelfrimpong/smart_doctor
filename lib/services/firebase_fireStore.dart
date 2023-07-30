// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_doctor/models/consultation_model.dart';
import 'package:smart_doctor/models/diagnosis_model.dart';
import 'package:smart_doctor/models/user_model.dart';

import '../models/appointment_model.dart';
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

  static updateUserOnlineStatus(String uid, bool bool) async {
    await _fireStore.collection('users').doc(uid).update({'isOnline': bool});
  }

  static updateDoctorOnlineStatus(String uid, bool bool) async {
    await _fireStore.collection('doctors').doc(uid).update({'isOnline': bool});
  }

  static String getDocumentId(String s,
      {CollectionReference<Map<String, dynamic>>? collection}) {
    if (collection == null) {
      return _fireStore.collection(s).doc().id;
    } else {
      return collection.doc().id;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllUsersMap() async {
    final users = await _fireStore.collection('users').get();
    List<Map<String, dynamic>> usersMap = [];
    for (var element in users.docs) {
      usersMap.add(element.data());
    }
    return usersMap;
  }

  static updateUserRating(String userId, double rating) async {
    await _fireStore.collection('users').doc(userId).update({'rating': rating});
  }

  static Future<List<UserModel>> getCounsellors() async {
    final counsellors = await _fireStore
        .collection('users')
        .where('userType', isEqualTo: 'Counsellor')
        .get();
    List<UserModel> counsellorsList = [];
    for (var element in counsellors.docs) {
      counsellorsList.add(UserModel.fromMap(element.data()));
    }
    return counsellorsList;
  }

  static Future<bool> bookAppointment(AppointmentModel state) {
    return _fireStore
        .collection('appointments')
        .doc(state.id)
        .set(state.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAppointmentStream(
      String userId, String counsellorId) {
    try {
      return _fireStore
          .collection('appointments')
          .where('doctorId', isEqualTo: counsellorId)
          .where('userId', isEqualTo: userId)
          .where('status', isNotEqualTo: 'Ended')
          .snapshots();
    } on FirebaseException {
      return const Stream.empty();
    }
  }

  // static Future<void> addQuestion(QuestionsModel state) async {
  //   await _fireStore.collection('questions').doc(state.id).set(state.toMap());
  // }
  //
  // static Future<void> updateQuestion(QuestionsModel state) async {
  //   await _fireStore
  //       .collection('questions')
  //       .doc(state.id)
  //       .update(state.updateMap());
  // }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getComments(String id) {
  //   return _fireStore
  //       .collection('questions')
  //       .doc(id)
  //       .collection('comments')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots();
  // }

  // static saveComment(CommentModel state) {
  //   _fireStore
  //       .collection('questions')
  //       .doc(state.postId)
  //       .collection('comments')
  //       .doc(state.id)
  //       .set(state.toMap());
  // }
  //
  // static void updateComment(CommentModel state) {
  //   _fireStore
  //       .collection('questions')
  //       .doc(state.postId)
  //       .collection('comments')
  //       .doc(state.id)
  //       .update(state.updateMap());
  // }
  //
  // static deleteComment(String id, String postId) async {
  //   await _fireStore
  //       .collection('questions')
  //       .doc(postId)
  //       .collection('comments')
  //       .doc(id)
  //       .delete();
  // }

  // static Future<List<QuestionsModel>> getAllQuestions() async {
  //   final questions = await _fireStore.collection('questions').get();
  //   List<QuestionsModel> questionsList = [];
  //   for (var element in questions.docs) {
  //     questionsList.add(QuestionsModel.fromMap(element.data()));
  //   }
  //   return questionsList;
  // }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getActiveServices(
  //     {String? userId, required String counsellorId}) {
  //   try {
  //     return _fireStore
  //         .collection('sessions')
  //         .where('counsellorId', isEqualTo: counsellorId)
  //         .where('userId', isEqualTo: userId)
  //         .where('status', isNotEqualTo: 'Ended')
  //         .snapshots();
  //   } on FirebaseException {
  //     return const Stream.empty();
  //   }
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserConsultations(
      String? userId) {
    try {
      return _fireStore
          .collection('consultations')
          .where('ids', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } on FirebaseException {
      return const Stream.empty();
    }
  }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getUserSessionsMessages(
  //     String id) {
  //   try {
  //     return _fireStore
  //         .collection('sessions')
  //         .doc(id)
  //         .collection('messages')
  //         .orderBy('createdAt', descending: false)
  //         .snapshots();
  //   } on FirebaseException {
  //     return const Stream.empty();
  //   }
  // }

  // static Stream<DocumentSnapshot<Map<String, dynamic>>> getCounsellor(
  //     String id) {
  //   try {
  //     return _fireStore.collection('users').doc(id).snapshots();
  //   } on FirebaseException {
  //     return const Stream.empty();
  //   }
  // }

  // static Future<bool> addSessionMessages(
  //     SessionMessagesModel messagesModel) async {
  //   try {
  //     await _fireStore
  //         .collection('sessions')
  //         .doc(messagesModel.sessionId)
  //         .collection('messages')
  //         .doc(messagesModel.id)
  //         .set(messagesModel.toMap());
  //     return true;
  //   } on FirebaseException {
  //     return false;
  //   }
  // }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAppointments(String? id,
      {String userType = 'userId'}) {
    try {
      return _fireStore
          .collection('appointments')
          .where(userType, isEqualTo: id)
          .snapshots();
    } on FirebaseException {
      return const Stream.empty();
    }
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getSingleAppointment(
      String id) {
    try {
      return _fireStore.collection('appointments').doc(id).snapshots();
    } on FirebaseException {
      return const Stream.empty();
    }
  }

  static Future<void> rescheduleAppointment(AppointmentModel state) async {
    await _fireStore
        .collection('appointments')
        .doc(state.id)
        .update(state.rescheduleMap());
  }

  static updateAppointmentStatus(String s, String status) async {
    await _fireStore
        .collection('appointments')
        .doc(s)
        .update({'status': status});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllDoctors() {
    try {
      return _fireStore.collection('doctors').snapshots();
    } on FirebaseException {
      return const Stream.empty();
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserDiagnosticHistory(
      String? id) {
    try {
      return _fireStore
          .collection('diagnosis')
          .where('senderId', isEqualTo: id)
          .orderBy('createAt', descending: true)
          .snapshots();
    } on FirebaseException {
      return const Stream.empty();
    }
  }

  static Future<bool> saveDiagnosis(DiagnosisModel state) {
    return _fireStore
        .collection('diagnosis')
        .doc(state.id)
        .set(state.toMap())
        .then((value) => true)
        .catchError((error) {
      return false;
    });
  }

  static Future<DiagnosisModel?> getDiagnosis(String s) async {
    var data = await _fireStore.collection('diagnosis').doc(s).get();
    return DiagnosisModel.fromMap(data.data()!);
  }

  static Future<bool> deleteDiagnosis(String id) async {
    return _fireStore
        .collection('diagnosis')
        .doc(id)
        .delete()
        .then((value) => true)
        .catchError((error) {
      return false;
    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getSingleDoctor(
      String id) {
    try {
      return _fireStore.collection('doctors').doc(id).snapshots();
    } on FirebaseException {
      return const Stream.empty();
    }
  }

  static updateConsultationStatus(String id, String status) {}

  static getUserConsultationMessages(String id) {}

  static Stream<QuerySnapshot<Map<String, dynamic>>> getActiveConsultation(
      {String? userId, required String doctorId}) {
    try {
      return _fireStore
          .collection('consultations')
          .where('doctorId', isEqualTo: doctorId)
          .where('userId', isEqualTo: userId)
          .where('status', isNotEqualTo: 'Ended')
          .snapshots();
    } on FirebaseException {
      return const Stream.empty();
    }
  }

  static Future<bool> bookConsultation(ConsultationModel state) async {
    try {
      await _fireStore
          .collection('consultations')
          .doc(state.id)
          .set(state.toMap());
      return true;
    } on FirebaseException {
      return false;
    }
  }

  static addConsultationMessages(messagesModel) {}

  static updateConsultationMessageReadStatus(String id, String s, bool bool) {}

  static Future<bool> updateDoctor(DoctorModel state) async {
    try {
      await _fireStore
          .collection('doctors')
          .doc(state.id)
          .update(state.updateMap());
      return true;
    } on FirebaseException {
      return false;
    }
  }

  // static Future<bool> updateUser(UserModel state) async {
  //   try {
  //     await _fireStore
  //         .collection('users')
  //         .doc(state.id)
  //         .update(state.updateUserMap());
  //     return true;
  //   } on FirebaseException {
  //     return false;
  //   }
}
  //get app