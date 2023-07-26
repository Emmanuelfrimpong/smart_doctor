import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doctor_model.dart';
import '../services/firebase_fireStore.dart';

final doctorsStreamProvider =
    StreamProvider.autoDispose<List<DoctorModel>>((ref) async* {
  final doctors = await FireStoreServices.getAllDoctors();
  ref.onDispose(() {
    doctors.drain();
  });

  List<DoctorModel> data = [];
  await for (var item in doctors) {
    data = item.docs.map((e) => DoctorModel.fromMap(e.data())).toList();
    yield data;
  }
});

final selectedDoctorProvider = StateProvider<DoctorModel?>((ref) => null);

final doctorSearchQueryProvider = StateProvider<String>((ref) => '');
final doctorSearchQueryList =
    Provider.family<List<DoctorModel>, List<DoctorModel>>((ref, list) {
  final query = ref.watch(doctorSearchQueryProvider);
  if (query.isEmpty) {
    return [];
  } else {
    return list
        .where((element) =>
            element.name!.toLowerCase().contains(query.toLowerCase()) ||
            element.hospital!.toLowerCase().contains(query.toLowerCase()) ||
            element.specialty!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
});
