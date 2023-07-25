import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doctor_model.dart';
import '../services/firebase_fireStore.dart';

final doctorsStreamProvider =
    StreamProvider.autoDispose<List<DoctorModel>>((ref) async* {
  final doctors = FireStoreServices.getAllDoctors();
  ref.onCancel(() {
    doctors.drain();
  });
  try {
    List<DoctorModel> data = [];
    await for (var item in doctors) {
      data = item.docs.map((e) => DoctorModel.fromMap(e.data())).toList();
      yield data;
    }
  } catch (e) {}
});

final selectedDoctorProvider = StateProvider<DoctorModel?>((ref) => null);
