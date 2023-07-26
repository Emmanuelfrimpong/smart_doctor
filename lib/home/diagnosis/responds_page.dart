import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_doctor/core/components/widgets/custom_button.dart';
import 'package:smart_doctor/models/diagnosis_model.dart';
import 'package:smart_doctor/models/disease_model.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../state/diagnosis_data_state.dart';

class DiagnoseResponsePage extends ConsumerStatefulWidget {
  const DiagnoseResponsePage({super.key});

  @override
  ConsumerState<DiagnoseResponsePage> createState() =>
      _DiagnoseResponsePageState();
}

class _DiagnoseResponsePageState extends ConsumerState<DiagnoseResponsePage> {
  @override
  Widget build(BuildContext context) {
    var diagnosis = ref.watch(newDiagnosisProvider);
    var size = MediaQuery.of(context).size;
    print('========================================');
    print(diagnosis.toMap());
    print('========================================');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: size.height,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                    color: secondaryColor,
                    child: Text(
                      'Possible Diseases',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
            //show list of symptoms
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Wrap(
                      children: diagnosis.symptoms!
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Chip(
                                  label: Text(
                                    e['Name'],
                                    style: normalText(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      primaryColor.withOpacity(0.8),
                                ),
                              ))
                          .toList(),
                    ),
                    if (diagnosis.responses!.isEmpty)
                      const SizedBox(
                        height: 20,
                      ),
                    if (diagnosis.responses!.isEmpty)
                      Chip(
                          backgroundColor: Colors.red,
                          label: Text('No Disease Found',
                              style: normalText(
                                  fontWeight: FontWeight.w600, fontSize: 16))),
                    if (diagnosis.responses!.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No disease found with the given symptoms.\n We are working on our AI to improve the accuracy of our diagnosis.',
                          style: normalText(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black45),
                        ),
                      ),
                    if (diagnosis.responses!.isEmpty)
                      const SizedBox(
                        height: 20,
                      ),
                    if (diagnosis.responses!.isEmpty)
                      //Try again button
                      CustomButton(
                          icon: Icons.refresh,
                          text: 'Try Again',
                          onPressed: () {
                            ref.read(diagnosisIndexProvider.notifier).state = 1;
                          }),
                    if (diagnosis.responses!.isNotEmpty)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: diagnosis.responses!.length,
                          itemBuilder: (context, index) {
                            var map = diagnosis.responses![index];
                            DiseaseModel diseaseModel =
                                DiseaseModel.fromMap(map);
                            //re expandable card
                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: ExpansionTile(
                                expandedAlignment: Alignment.centerLeft,
                                title: Text(
                                  diseaseModel.name,
                                  style: normalText(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19),
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
                              ),
                            );
                          }),
                  ],
                ),
              ),
            ),

            if (diagnosis.responses!.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        text: 'Delete',
                        onPressed: () {
                          //clear diagnosis
                          ref.read(newDiagnosisProvider.notifier).delete(ref);
                        }),
                  ),
                  if (!diagnosis.isSaved!)
                    const SizedBox(
                      width: 10,
                    ),
                  if (!diagnosis.isSaved!)
                    Expanded(
                        flex: 2,
                        child: CustomButton(
                            icon: Icons.save,
                            text: 'Save Diagnosis',
                            onPressed: () {
                              //save diagnosis
                              ref
                                  .read(newDiagnosisProvider.notifier)
                                  .saveToFirebase(ref);
                            })),
                ],
              )
          ],
        ),
      ),
    );
  }
}
