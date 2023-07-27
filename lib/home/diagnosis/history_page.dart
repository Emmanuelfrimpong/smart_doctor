import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/core/functions.dart';
import 'package:smart_doctor/services/firebase_fireStore.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import 'package:smart_doctor/styles/styles.dart';
import '../../models/disease_model.dart';
import '../../state/diagnosis_data_state.dart';
import '../../styles/colors.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);
    var diagnosis = ref.watch(diagnosisStreamProvider(user.id!));
    return Center(
      child: diagnosis.when(data: (data) {
        if (data.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No diagnosis history',
                style: normalText(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    ref.read(diagnosisIndexProvider.notifier).state = 1;
                  },
                  child: Text(
                    'Start a diagnosis',
                    style: normalText(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ))
            ],
          );
        } else {
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var symptoms = data[index].symptoms;
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Row(
                        children: [
                          const Icon(
                            Icons.date_range,
                            color: primaryColor,
                            size: 22,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(getDateFromDate(data[index].createAt),
                              style: normalText(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: primaryColor)),
                          const Spacer(),
                          //delete diagnosis if user is sender
                          if (data[index].senderId == user.id)
                            IconButton(
                              onPressed: () {
                                CustomDialog.showInfo(
                                  title: 'Delete Diagnosis',
                                  message:
                                      'Are you sure you want to delete this diagnosis?',
                                  onConfirmText: 'Delete',
                                  onConfirm: () async {
                                    deleteDiagnosis(data[index].id!, ref);
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                        ],
                      ),
                      subtitle: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: ExpansionTile(
                          expandedAlignment: Alignment.centerLeft,
                          collapsedBackgroundColor: Colors.white,
                          title: Row(
                            children: [
                              const Icon(
                                Icons.medical_services,
                                color: primaryColor,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Symptoms',
                                style: normalText(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: primaryColor),
                              ),
                            ],
                          ),
                          children: symptoms!
                              .map((e) => Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        const Icon(
                                          Icons.circle,
                                          color: primaryColor,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          e['Name'],
                                          style: normalText(),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                        subtitle: ListTile(
                          title: Row(
                            children: [
                              Icon(
                                MdiIcons.medication,
                                color: primaryColor,
                                size: 22,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Possible Diseases',
                                style: normalText(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: primaryColor),
                              ),
                            ],
                          ),
                          subtitle: Column(
                              children: data[index].responses!.map((e) {
                            Map<String, dynamic> map = e;
                            DiseaseModel diseaseModel =
                                DiseaseModel.fromMap(map);
                            //re expandable card
                            return ExpansionTile(
                              expandedAlignment: Alignment.centerLeft,
                              collapsedBackgroundColor: Colors.white,
                              title: Text(
                                diseaseModel.name,
                                style: normalText(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Colors.grey),
                              ),
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Row(
                                      children: [
                                        const Icon(
                                          Icons.info,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Description',
                                          style:
                                              normalText(color: primaryColor),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      diseaseModel.note,
                                      style: normalText(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                  ),
                                ),
                                ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Row(
                                      children: [
                                        const Icon(
                                          Icons.medical_services,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Treatments',
                                          style:
                                              normalText(color: primaryColor),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(diseaseModel.treatments!,
                                        style: normalText(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17))),
                              ],
                            );
                          }).toList()),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
      }, error: (error, stack) {
        return Center(
            child: Text(
          'Something went wrong',
          style: normalText(color: Colors.grey),
        ));
      }, loading: () {
        return const Center(
            child: SizedBox(
                height: 20, width: 20, child: CircularProgressIndicator()));
      }),
    );
  }

  void deleteDiagnosis(String id, WidgetRef ref) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Deleting diagnosis....');
    await FireStoreServices.deleteDiagnosis(id);
    var user = ref.watch(userProvider);
    ref.invalidate(diagnosisStreamProvider(user.id!));
    CustomDialog.dismiss();
    CustomDialog.showToast(message: 'Diagnosis Deleted successfully');
  }
}
