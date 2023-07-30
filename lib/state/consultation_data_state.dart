// ignore_for_file: empty_catches
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/models/consultation_messages_model.dart';
import 'package:smart_doctor/models/consultation_model.dart';
import 'package:smart_doctor/state/data_state.dart';
import 'package:smart_doctor/state/doctor_data_state.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../services/firebase_fireStore.dart';

//get a stream of consultation where status is not ended
final activeConsultationStream = StreamProvider.autoDispose
    .family<List<ConsultationModel>, String>((ref, doctorId) async* {
  var userId = ref.watch(userProvider).id;
  final consultations = FireStoreServices.getActiveConsultation(
      userId: userId, doctorId: doctorId);

  ref.onDispose(() {
    consultations.drain();
  });
  var data = <ConsultationModel>[];
  await for (var element in consultations) {
    data =
        element.docs.map((e) => ConsultationModel.fromMap(e.data())).toList();
    yield data;
  }
});

final currentConsultationProvider =
    StateNotifierProvider<CurrentConsultationProvider, ConsultationModel>(
        (ref) => CurrentConsultationProvider());

class CurrentConsultationProvider extends StateNotifier<ConsultationModel> {
  CurrentConsultationProvider() : super(ConsultationModel());
  void setCurrentConsultation(ConsultationModel consultation) {
    state = consultation;
  }

  void bookConsultation(BuildContext context, WidgetRef ref) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Booking Consultation... Please wait');
    var user = ref.watch(userProvider);
    var doctor = ref.watch(selectedDoctorProvider);
    state.id = FireStoreServices.getDocumentId('consultations');
    state.doctorId = doctor!.id;
    state.doctorName = doctor.name;
    state.doctorImage = doctor.profile;
    state.doctorSpecialty = doctor.specialty;
    state.userId = user.id;
    state.ids = [doctor.id, user.id];
    state.userName = user.name;
    state.userImage = user.profile;
    state.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    state.status = 'Pending';
    final bool result = await FireStoreServices.bookConsultation(state);
    if (result) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Consultation booked successfully',
        onOkayPressed: () {
          Navigator.pop(context);
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

final consultationsStreamProvider =
    StreamProvider.autoDispose<List<ConsultationModel>>((ref) async* {
  String? userType = ref.watch(userTypeProvider);
  String? id;
  if (userType != null && userType.toLowerCase() == 'user') {
    id = ref.watch(userProvider).id!;
  } else {
    id = ref.watch(doctorProvider).id;
  }

  var consultations = FireStoreServices.getUserConsultations(id);
  ref.onDispose(() {
    if(consultations!=null) {
      consultations.drain();
    }
  });
  var data = <ConsultationModel>[];
  await for (var element in consultations) {
    data =
        element.docs.map((e) => ConsultationModel.fromMap(e.data())).toList();
    yield data;
  }
});

final consultationSearchQuery = StateProvider<String>((ref) => '');

final selectedConsultationProvider =
    StateNotifierProvider<SelectedConsultationProvider, ConsultationModel>(
        (ref) => SelectedConsultationProvider());

class SelectedConsultationProvider extends StateNotifier<ConsultationModel> {
  SelectedConsultationProvider() : super(ConsultationModel());
  void setSelectedConsultation(ConsultationModel consultation) {
    state = consultation;
  }

  void updateConsultationStatus(String id, String status) async {
    CustomDialog.showLoading(
        message: 'Updating Consultation Status... Please wait');
    var result = await FireStoreServices.updateConsultationStatus(id, status);
    if (result) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Consultation status updated successfully',
      );
    }
  }
}

final consultationMessagesStreamProvider = StreamProvider.autoDispose
    .family<List<ConsultationMessagesModel>, String>((ref, id) async* {
  var consultations = FireStoreServices.getUserConsultationMessages(id);
  ref.onDispose(() {
    if(consultations!=null) {
      consultations.drain();
    }
  });
  try {
    var data = <ConsultationMessagesModel>[];
    await for (var element in consultations) {
      data = element.docs
          .map((e) => ConsultationMessagesModel.fromMap(e.data()))
          .toList();
      yield data;
    }
  } catch (e) {}
});

final consultationsListProvider = StateNotifierProvider.family<
    ConsultationListProvider,
    List<ConsultationModel>,
    String>((ref, id) => ConsultationListProvider(id));

class ConsultationListProvider extends StateNotifier<List<ConsultationModel>> {
  ConsultationListProvider(this.id) : super([]) {
    getUserConsultation(id);
  }
  final String id;
  void setConsultations(List<ConsultationModel> consultation) {
    state = consultation;
  }

  void getUserConsultation(String id) async {
    var consultations = FireStoreServices.getUserConsultations(id);
    try {
      var data = <ConsultationModel>[];
      await for (var element in consultations) {
        data = element.docs
            .map((e) => ConsultationModel.fromMap(e.data()))
            .toList();
        state = data;
      }
    } catch (e) {}
  }
}

final searchConsultationProvider =
    Provider.family.autoDispose<List<ConsultationModel>, String>((ref, id) {
  var query = ref.watch(consultationSearchQuery);
  var consultations = ref.watch(consultationsListProvider(id));
  if (query.isEmpty) {
    return [];
  } else {
    return consultations
        .where((element) =>
            element.doctorName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
});

final selectedHospitalProvider = StateProvider<String>((ref) => 'All');
final selectedSpecialtyProvider = StateProvider<String>((ref) => 'All');
