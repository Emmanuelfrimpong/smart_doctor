import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/core/functions.dart';
import 'package:smart_doctor/home/consultation/consultation_chat_page.dart';
import 'package:smart_doctor/models/consultation_model.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import 'package:smart_doctor/models/user_model.dart';
import 'package:smart_doctor/services/firebase_fireStore.dart';
import 'package:smart_doctor/state/consultation_data_state.dart';
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

  final data = FireStoreServices.getMyDoctorPatient(id, field);
  ref.onDispose(() {
    data.drain();
  });
  List<PartnerModel> list = [];

  await for (var item in data) {
    list = item.docs.map((e) => PartnerModel.fromMap(e.data())).toList();
    yield list;
  }
});

final selectedPartnersProvider =
    StateNotifierProvider<SelectedPartner, PartnerModel>((ref) {
  return SelectedPartner();
});

class SelectedPartner extends StateNotifier<PartnerModel> {
  SelectedPartner() : super(PartnerModel());

  void setPartner(PartnerModel data) {
    state = data;
  }

  void acceptRequest() async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Accepting Request...');
    state = state.copyWith(status: 'Accepted');
    await FireStoreServices.updatePartnerStatus(state).then((value) {
      if (value) {
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: 'Request Accepted Successfully', title: 'Success');
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message: 'Failed to accept request', title: 'Error');
      }
    });
  }

  void rejectRequest() async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Rejecting Request...');
    state = state.copyWith(status: 'Rejected');
    await FireStoreServices.updatePartnerStatus(state).then((value) {
      if (value) {
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: 'Request Rejected Successfully', title: 'Success');
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message: 'Failed to reject request', title: 'Error');
      }
    });
  }

  void removePatient(BuildContext context) async {
    //delete the partner and close page
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Removing Patient/Doctor...');
    await FireStoreServices.deletePartner(state).then((value) {
      if (value) {
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: 'Patient/Doctor Removed Successfully', title: 'Success');
        Navigator.pop(context);
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message: 'Failed to remove patient/doctor', title: 'Error');
      }
    });
  }

  void openChat(BuildContext context, WidgetRef ref) async {
    //open chat page
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Opening Chat...');
    String userId = state.patientId!;
    String doctorId = state.doctorId!;
    // check if pending or active consultation exist
    List<ConsultationModel> data =
        await FireStoreServices.getActiveConsultationList(
            doctorId: doctorId, userId: userId);

    if (data.isNotEmpty) {
      ConsultationModel singleData = data[0];
      ref
          .read(selectedConsultationProvider.notifier)
          .setSelectedConsultation(singleData);
      CustomDialog.dismiss();
      if (mounted) {
        sendToPage(context, const ConsultationChatPage());
      }
    } else {
      CustomDialog.dismiss();
      CustomDialog.showInfo(
          title: 'New Consultation',
          onConfirm: () {
            bookConsultation(context, ref);
          },
          message:
              'You have not started a consultation with this patient/Doctor. Do you want to start a new consultation?',
          onConfirmText: 'Create');
    }
  }

  void bookConsultation(BuildContext context, WidgetRef ref) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Booking Consultation... Please wait');
    ConsultationModel model = ConsultationModel();
    var user = UserModel.fromMap(state.patientData!);
    var doctor = DoctorModel.fromMap(state.doctorData!);
    model.id = FireStoreServices.getDocumentId('consultations');
    model.doctorId = doctor.id;
    model.doctorName = doctor.name;
    model.doctorImage = doctor.profile;
    model.doctorSpecialty = doctor.specialty;
    model.userId = user.id;
    model.ids = [doctor.id, user.id];
    model.userName = user.name;
    model.userImage = user.profile;
    model.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    model.status = 'Pending';
    final bool result = await FireStoreServices.bookConsultation(model);
    if (result) {
      CustomDialog.dismiss();
      ref
          .read(selectedConsultationProvider.notifier)
          .setSelectedConsultation(model);
      CustomDialog.dismiss();

      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Consultation booked successfully',
        onOkayPressed: () {
          if (mounted) {
            sendToPage(context, const ConsultationChatPage());
          }
        },
      );
      //send to chat page
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error', message: 'Could not book consultation');
    }
  }
}
