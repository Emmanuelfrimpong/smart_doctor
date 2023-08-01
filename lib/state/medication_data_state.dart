import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/core/components/constants/enums.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import '../models/medication_model.dart';
import '../services/firebase_fireStore.dart';

final newMedicationProvider =
    StateNotifierProvider<NewMedicationProvider, MedicationModel>(
        (ref) => NewMedicationProvider());

class NewMedicationProvider extends StateNotifier<MedicationModel> {
  NewMedicationProvider() : super(MedicationModel());

  void setMedicineName(String? name) {
    state = state.copyWith(medicationName: name);
  }

  void setMedicineDosage(double parse) {
    state = state.copyWith(medicationDosage: parse.toString());
  }

  void setMedicineNote(String? note) {
    state = state.copyWith(medicationNote: note);
  }

  void saveMedication(
      String userId, BuildContext context, WidgetRef ref) async {
    var listOfDays = ref.watch(medicationDaysListProvider);
    var listOfTimes = ref.watch(medicationTimeListProvider);
    var type = ref.watch(medicationTypeProvider);
    var measurement = ref.watch(medicationMeasurementProvider);
    //validate data
    if (type.isEmpty) {
      CustomDialog.showToast(
          message: 'Please select medication type', type: ToastType.error);
    } else if (measurement.isEmpty) {
      CustomDialog.showToast(
          message: 'Please select medication measurement',
          type: ToastType.error);
    } else if (listOfDays.isEmpty) {
      CustomDialog.showToast(
          message: 'Please select medication days', type: ToastType.error);
    } else if (listOfTimes.isEmpty) {
      CustomDialog.showToast(
          message: 'Please select medication times', type: ToastType.error);
    } else {
      CustomDialog.showLoading(message: 'Saving medication.....');
      //! check if days contains today and tomorrow then convert to Date format
      if (listOfDays.contains('Today') && listOfDays.contains('Tomorrow')) {
        listOfDays.remove('Today');
        listOfDays.remove('Tomorrow');
        listOfDays.add(DateTime.now().toUtc().toString());
        listOfDays.add(
            DateTime.now().add(const Duration(days: 1)).toUtc().toString());
      } else if (listOfDays.contains('Today')) {
        listOfDays.remove('Today');
        listOfDays.add(DateTime.now().toUtc().toString());
      } else if (listOfDays.contains('Tomorrow')) {
        listOfDays.remove('Tomorrow');
        listOfDays.add(
            DateTime.now().add(const Duration(days: 1)).toUtc().toString());
      }
      //! check if times contains morning, afternoon and evening then convert to TimeOfDay format
      if (listOfTimes.contains('Morning') &&
          listOfTimes.contains('Afternoon') &&
          listOfTimes.contains('Evening')) {
        listOfTimes.remove('Morning');
        listOfTimes.remove('Afternoon');
        listOfTimes.remove('Evening');
        listOfTimes.add('08:00:00 AM');
        listOfTimes.add('12:00:00 PM');
        listOfTimes.add('18:00:00 PM');
      } else if (listOfTimes.contains('Morning') &&
          listOfTimes.contains('Afternoon')) {
        listOfTimes.remove('Morning');
        listOfTimes.remove('Afternoon');
        listOfTimes.add('08:00:00 AM');
        listOfTimes.add('12:00:00 PM');
      } else if (listOfTimes.contains('Morning') &&
          listOfTimes.contains('Evening')) {
        listOfTimes.remove('Morning');
        listOfTimes.remove('Evening');
        listOfTimes.add('08:00:00 AM');
        listOfTimes.add('18:00:00 PM');
      } else if (listOfTimes.contains('Afternoon') &&
          listOfTimes.contains('Evening')) {
        listOfTimes.remove('Afternoon');
        listOfTimes.remove('Evening');
        listOfTimes.add('12:00:00 PM');
        listOfTimes.add('18:00:00 PM');
      } else if (listOfTimes.contains('Morning')) {
        listOfTimes.remove('Morning');
        listOfTimes.add('08:00:00 AM');
      } else if (listOfTimes.contains('Afternoon')) {
        listOfTimes.remove('Afternoon');
        listOfTimes.add('12:00:00 PM');
      } else if (listOfTimes.contains('Evening')) {
        listOfTimes.remove('Evening');
        listOfTimes.add('18:00:00 PM');
      }
      state = state.copyWith(
        medicationType: type,
        id: FireStoreServices.getDocumentId('medication'),
        patientId: userId,
        isMedicationActive: true,
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        duration: {
          'days': listOfDays,
          'times': listOfTimes,
        },
        medicationDosage: '${state.medicationDosage} $measurement',
      );
      var results = await FireStoreServices.saveMedication(state);
      if (results) {
        //clear all data
        ref.read(medicationDaysListProvider.notifier).clearList();
        ref.read(medicationTimeListProvider.notifier).clearList();
        ref.read(medicationTypeProvider.notifier).state = 'Syrup';
        ref.read(medicationMeasurementProvider.notifier).state = 'ml';
        ref.read(newMedicationProvider.notifier).state = MedicationModel();
        CustomDialog.dismiss();
        CustomDialog.showToast(
            message: 'Medication saved successfully', type: ToastType.success);
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        CustomDialog.dismiss();
        CustomDialog.showToast(
            message: 'Failed to save medication', type: ToastType.error);
      }
    }
  }
}

final medicationStreamProvider =
    StreamProvider<List<MedicationModel>>((ref) async* {
  final id = ref.watch(userProvider).id;
  var data = FireStoreServices.getMedication(id);
  ref.onDispose(() {
    data.drain();
  });
  List<MedicationModel> list = [];
  await for (var item in data) {
    list = item.docs.map((e) => MedicationModel.fromMap(e.data())).toList();
    yield list;
  }
});

final medicationSearchStringProvider = StateProvider<String>((ref) {
  return '';
});

final medicationTypeProvider = StateProvider<String>((ref) {
  return 'Syrup';
});
final medicationMeasurementProvider = StateProvider<String>((ref) {
  return 'ml';
});

final medicationDaysListProvider =
    StateNotifierProvider<MedicationDaysList, List<String>>((ref) {
  return MedicationDaysList();
});

class MedicationDaysList extends StateNotifier<List<String>> {
  MedicationDaysList() : super([]);

  void addDay(String day) {
    state = [...state, day];
  }

  void removeDay(String day) {
    state = state.where((element) => element != day).toList();
  }

  void clearList() {
    state = [];
  }
}

final medicationTimeListProvider =
    StateNotifierProvider<MedicationTimesList, List<String>>((ref) {
  return MedicationTimesList();
});

class MedicationTimesList extends StateNotifier<List<String>> {
  MedicationTimesList() : super([]);

  void addTme(String time) {
    state = [...state, time];
  }

  void removeTime(String time) {
    state = state.where((element) => element != time).toList();
  }

  void clearList() {
    state = [];
  }
}
