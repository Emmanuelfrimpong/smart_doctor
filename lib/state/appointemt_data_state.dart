// ignore_for_file: empty_catches

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../core/functions.dart';
import '../models/appointment_model.dart';
import '../services/firebase_fireStore.dart';
import 'doctors_data_state.dart';

final appointmentStreamProvider =
    StreamProvider.autoDispose<List<AppointmentModel>>((ref) async* {
  var userId = ref.watch(userProvider).id;
  var doctorId = ref.watch(selectedDoctorProvider)!.id;
  var appointments = FireStoreServices.getAppointmentStream(userId!, doctorId!);
  ref.onDispose(() {
    appointments.drain();
  });
  try {
    var data = <AppointmentModel>[];
    await for (var element in appointments) {
      data =
          element.docs.map((e) => AppointmentModel.fromMap(e.data())).toList();
      yield data
          .where((element) =>
              element.status == 'Pending' || element.status == 'Accepted')
          .toList();
    }
  } catch (e) {}
});
final appointmentSearchQuery = StateProvider<String>((ref) => '');
final searchAppointmentProvider = StateProvider<List<AppointmentModel>>((ref) {
  var query = ref.watch(appointmentSearchQuery);
  var appointments =
      ref.watch(appointmentStreamProvider as AlwaysAliveProviderListenable);
  var data = <AppointmentModel>[];
  appointments.whenData((value) {
    data = value
        .where((element) =>
            element.doctorName!.toLowerCase().contains(query) ||
            element.userName!.toLowerCase().contains(query) ||
            element.status!.toLowerCase().contains(query) ||
            getDateFromDate(element.date!).toLowerCase().contains(query) ||
            getTimeFromDate(element.time!).toLowerCase().contains(query))
        .toList();
  });
  return data;
});

final singleAppointmentStreamProvider = StreamProvider.autoDispose
    .family<AppointmentModel, String>((ref, id) async* {
  var appointments = FireStoreServices.getSingleAppointment(id);
  ref.onDispose(() {
    appointments.drain();
  });
  try {
    var data = AppointmentModel();
    await for (var element in appointments) {
      data = AppointmentModel.fromMap(element.data() as Map<String, dynamic>);
      yield data;
    }
  } catch (e) {}
});

final selectedAppointmentProvider =
    StateNotifierProvider<SelectedAppointment, AppointmentModel>(
        (ref) => SelectedAppointment());

class SelectedAppointment extends StateNotifier<AppointmentModel> {
  SelectedAppointment() : super(AppointmentModel());

  void setAppointment(AppointmentModel appointment) {
    state = appointment;
  }

  void setTime(int millisecondsSinceEpoch) {
    state = state.copyWith(time: millisecondsSinceEpoch);
  }

  void rescheduleAppointment() {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Rescheduling appointment...');
    FireStoreServices.rescheduleAppointment(state).then((value) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Appointment rescheduled successfully',
      );
    }).catchError((e) {
      CustomDialog.dismiss();
      CustomDialog.showError(
        title: 'Error',
        message: 'Error rescheduling appointment',
      );
    });
  }

  void setDate(int millisecondsSinceEpoch) {
    state = state.copyWith(date: millisecondsSinceEpoch);
  }

  void updateAppointment(String status) {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Updating appointment...');
    FireStoreServices.updateAppointmentStatus(state.id!, status).then((value) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Appointment updated successfully',
      );
    }).catchError((e) {
      CustomDialog.dismiss();
      CustomDialog.showError(
        title: 'Error',
        message: 'Error updating appointment',
      );
    });
  }
}

final currentAppointmentProvider =
    StateNotifierProvider<CurrentAppointmentProvider, AppointmentModel>(
        (ref) => CurrentAppointmentProvider());

class CurrentAppointmentProvider extends StateNotifier<AppointmentModel> {
  CurrentAppointmentProvider() : super(AppointmentModel());
  void setCurrentAppointment(AppointmentModel appointment) {
    state = appointment;
  }

  void setDate(DateTime? value) {
    if (value == null) return;

    state = state.copyWith(date: value.millisecondsSinceEpoch);
  }

  void setTime(TimeOfDay? value, BuildContext context) {
    if (value == null) return;
    state = state.copyWith(time: value.toDateTime().millisecondsSinceEpoch);
  }

  void bookAppointment(BuildContext context, WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Booking Appointment... Please wait');
    var user = ref.watch(userProvider);
    var doctor = ref.watch(selectedDoctorProvider);
    state.id = FireStoreServices.getDocumentId('appointments');
    state.doctorId = doctor!.id;
    state.ids = [doctor.id, user.id];
    state.doctorName = doctor.name;
    state.doctorImage = doctor.profile;
    state.userId = user.id;
    state.userName = user.name;
    state.userImage = user.profile;
    state.doctorState = false;
    state.userState = true;
    state.status = 'Pending';
    state.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    final bool result = await FireStoreServices.bookAppointment(state);
    if (result) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(
        title: 'Success',
        message: 'Appointment booked successfully',
        onOkayPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error', message: 'Could not book appointment');
    }
  }
}
