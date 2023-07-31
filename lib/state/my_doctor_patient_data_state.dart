import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import 'package:smart_doctor/services/firebase_fireStore.dart';
import 'package:smart_doctor/state/data_state.dart';
import 'package:smart_doctor/state/user_data_state.dart';

import '../models/partners_model.dart';
import 'doctor_data_state.dart';

final inMyDoctorStreamProvider =
    StreamProvider.family<List<PartnerModel>, String>((ref, id) async* {
  var myId = ref.watch(userProvider).id;
  var data = FireStoreServices.getMyDoctor(myId, id);

  ref.onDispose(() {
    data.drain();
  });
  List<PartnerModel> list = [];

  await for (var item in data) {
    list = item.docs.map((e) => PartnerModel.fromMap(e.data())).toList();
    yield list;
  }
});

final myDoctorPatientProvider =
    StateNotifierProvider<MyDoctorPatientDataState, PartnerModel>((ref) {
  return MyDoctorPatientDataState();
});

class MyDoctorPatientDataState extends StateNotifier<PartnerModel> {
  MyDoctorPatientDataState() : super(PartnerModel());

  void setDoctorData(PartnerModel data) {
    state = data;
  }

  void addDoctor(DoctorModel doctor, WidgetRef ref) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Adding Doctor.. Please wait..');
    final data = ref.watch(myDoctorPatientStreamProvider);
    //check if data is not up to 3
    data.whenData((value) async {
      if (value.length >= 3) {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message: 'You can only have up to 3 doctors', title: 'Error');
      } else {
        var patient = ref.read(userProvider);
        state = state.copyWith(
          id: FireStoreServices.getDocumentId('partners'),
          patientId: patient.id,
          patientName: patient.name,
          patientPhoto: patient.profile,
          doctorId: doctor.id,
          doctorName: doctor.name,
          doctorPhoto: doctor.profile,
          doctorSpeciality: doctor.specialty,
          status: 'Pending',
          createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
          doctorData: doctor.toMap(),
          patientData: patient.toMap(),
        );
        final result = await FireStoreServices.addPartner(state);
        if (result) {
          //clear the state
          state = PartnerModel();
          CustomDialog.dismiss();
          CustomDialog.showSuccess(
              message: 'Doctor added successfully', title: 'Success');
        } else {
          CustomDialog.dismiss();
          CustomDialog.showError(
              message: 'Failed to add doctor', title: 'Error');
        }
      }
    });
  }
}

final myDoctorPatientStreamProvider =
    StreamProvider<List<PartnerModel>>((ref) async* {
  var userType = ref.watch(userTypeProvider);
  String id = userType!.toLowerCase() == 'doctor'
      ? ref.watch(doctorProvider).id!
      : ref.watch(userProvider).id!;
  String field = userType.toLowerCase() == 'doctor' ? 'doctorId' : 'patientId';

  final data = FireStoreServices.getMyDoctorPatient(id!, field);
  ref.onDispose(() {
    data.drain();
  });
  List<PartnerModel> list = [];

  await for (var item in data) {
    list = item.docs.map((e) => PartnerModel.fromMap(e.data())).toList();
    yield list;
  }
});
