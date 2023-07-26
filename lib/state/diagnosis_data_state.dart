import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/services/firebase_fireStore.dart';
import 'package:smart_doctor/state/user_data_state.dart';

import '../core/components/constants/strings.dart';
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
  var openAI = OpenAI.instance.build(
      token: OpenAIKey,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 18)),
      enableLog: true);
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
    state = state.copyWith(
      id: FireStoreServices.getDocumentId('diagnosis'),
      senderId: user.id,
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
    String prompt =
        "What is the diagnosis of this patient?\n symptoms: ${state.symptoms!.map((e) => '$e,')}. \n medicalInfo: ${state.medicalInfo!.map((key, value) => MapEntry(key, value))}";

    final request = CompleteText(
        prompt: prompt, model: TextDavinci3Model(), maxTokens: 200);
    final response = await openAI.onCompletion(request: request);
    if (response != null) {
      state = state.copyWith(
        responses: response.choices,
      );
      CustomDialog.dismiss();
    } else {
      CustomDialog.dismiss();
      CustomDialog.showError(
          title: 'Error',
          message: 'Unable to submit diagnosis, try again later');
      ref.read(diagnosisIndexProvider.notifier).state = 1;
    }
  }
}
