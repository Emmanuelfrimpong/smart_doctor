import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/core/components/constants/strings.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/models/disease_model.dart';
import 'package:smart_doctor/services/firebase_fireStore.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import '../core/functions.dart';
import '../models/diagnosis_model.dart';

final diagnosisIndexProvider = StateProvider<int>((ref) => 0);
final diagnosisStreamProvider = StreamProvider.family
    .autoDispose<List<DiagnosisModel>, String>((ref, id) async* {
  var stream = FireStoreServices.getUserDiagnosticHistory(id);
  ref.onDispose(() {
    stream.drain();
  });
  List<DiagnosisModel> list = [];
  await for (var snapshot in stream) {
    for (var doc in snapshot.docs) {
      list.add(DiagnosisModel.fromMap(doc.data()));
    }
    yield list;
  }
});

final newDiagnosisProvider =
    StateNotifierProvider<NewDiagnosisNotifier, DiagnosisModel>((ref) {
  return NewDiagnosisNotifier();
});

class NewDiagnosisNotifier extends StateNotifier<DiagnosisModel> {
  NewDiagnosisNotifier() : super(DiagnosisModel());

  void setDiagnosis(DiagnosisModel diagnosis) {
    state = diagnosis;
  }

  void clear() {
    state = state.clear();
  }

  void submit(WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Submitting Diagnosis...');
    ref.read(diagnosisIndexProvider.notifier).state = 2;
    var user = ref.watch(userProvider);
    var symptoms = ref.watch(newSymptomsListProvider);
    state = state.copyWith(
      id: FireStoreServices.getDocumentId('diagnosis'),
      senderId: user.id,
      symptoms: symptoms,
      medicalInfo: {
        'height': user.height,
        'weight': user.weight,
        'bloodType': user.bloodType,
        'history': user.medicalHistory,
        'vaccination': user.vaccinationStatus,
      },
      createAt: DateTime.now().toUtc().millisecondsSinceEpoch,
    );
    //create chatGPT prompt from medicalInfo and symptoms

    try {
      var diseases = ref.watch(diagnosisDiseaseProvider);
      List<DiseaseModel> foundDiseases = [];
      for (var disease in diseases) {
        int count = 0;
        for (var symptom in state.symptoms!) {
          if (disease.symptom.contains(symptom['ID'])) {
            count++;
          }
        }
        if (count >= 3) {
          foundDiseases.add(disease);
        }
      }
      List<Map<String, dynamic>> responses = [];
      for (var disease in foundDiseases) {
        responses.add(disease.toMap());
      }
      state = state.copyWith(responses: responses);
      ref.read(newSymptomsListProvider.notifier).state = [];
      // delay to show loading
      await Future.delayed(const Duration(seconds: 5));
      CustomDialog.dismiss();
    } catch (e) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error', message: 'Something went wrong, try again');
    }
  }

  void saveToFirebase(WidgetRef ref) async {
    CustomDialog.showLoading(message: 'Saving Diagnosis...');
    try {
      state = state.copyWith(isSaved: true);
      final results = await FireStoreServices.saveDiagnosis(state);
      if (results) {
        //get diagnosis from firebase
        var diagnosis = await FireStoreServices.getDiagnosis(state.id!);
        if (diagnosis != null) {
          setDiagnosis(diagnosis);
        }
        CustomDialog.dismiss();
        CustomDialog.showSuccess(
            message: 'Diagnosis Saved Successfully', title: 'Success');
      } else {
        CustomDialog.dismiss();
        CustomDialog.showError(
            message: 'Unable to save diagnosis, try again later',
            title: 'Error');
      }
    } catch (error) {
      CustomDialog.dismiss();
      CustomDialog.showError(
          message: 'Unable to save diagnosis, try again later', title: 'Error');
    }
  }
}

final newSymptomsListProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);

final diagnosisDiseaseProvider = StateProvider<List<DiseaseModel>>((ref) {
  List<DiseaseModel> newDiseasesList = [];
  final symptoms = symptomsList;
  for (var disease in diseaseList) {
    //get 5 random related symptoms
    final randomSymptoms = getRandomList(symptoms, 50);
    //add symptoms to disease
    newDiseasesList.add(DiseaseModel(
        name: disease['name']!,
        note: disease['note']!,
        symptom: randomSymptoms,
        treatments: disease['treatments']!));
  }
  return newDiseasesList;
});
