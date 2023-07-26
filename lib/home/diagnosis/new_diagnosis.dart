import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/constants/enums.dart';
import 'package:smart_doctor/core/components/widgets/custom_button.dart';
import 'package:smart_doctor/core/components/widgets/custom_input.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/state/diagnosis_data_state.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../state/user_data_state.dart';

class NewDiagnosisPage extends ConsumerStatefulWidget {
  const NewDiagnosisPage({super.key});

  @override
  ConsumerState<NewDiagnosisPage> createState() => _NewDiagnosisPageState();
}

class _NewDiagnosisPageState extends ConsumerState<NewDiagnosisPage> {
  final symptomController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: secondaryColor, width: 5))),
              child: Center(
                child: Text(
                  'New Diagnosis',
                  style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // show user medical history
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          Icon(MdiIcons.medicalBag,
                              color: primaryColor, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            'Medical History',
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          const Divider(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Height: ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                '${user.height} cm',
                                style: normalText(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Divider(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Weight: ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                '${user.weight} kg',
                                style: normalText(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Divider(
                            height: 5,
                          ),
                          //blood group
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Blood Group: ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                '${user.bloodType}',
                                style: normalText(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Divider(
                            height: 5,
                          ),
                          //medical history
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Medical History: ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                '${user.medicalHistory}',
                                style: normalText(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          //covid Vaccine
                          const Divider(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Covid 19 Vaccine: ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                '${user.vaccinationStatus}',
                                style: normalText(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Icon(MdiIcons.medication,
                                  color: primaryColor, size: 20),
                              const SizedBox(width: 5),
                              Text(
                                'Symptoms',
                                style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                              'Enter a minimum of 3 symptoms and a maximum of 5 for a better diagnosis.\nEnter symptoms one after the other and press the plus button to add each symptom.',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(height: 10),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          const Divider(
                            height: 10,
                          ),
                          const SizedBox(height: 10),
                          CustomTextFields(
                            hintText: 'Enter symptoms',
                            controller: symptomController,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (symptomController.text.isNotEmpty) {
                                    //add symptom to list
                                    if (ref
                                            .watch(newDiagnosisProvider)
                                            .symptoms!
                                            .length <
                                        6) {
                                      var diagnosis =
                                          ref.watch(newDiagnosisProvider);
                                      ref
                                          .read(newDiagnosisProvider.notifier)
                                          .setDiagnosis(diagnosis.copyWith(
                                              symptoms: [
                                                ...diagnosis.symptoms!,
                                                symptomController.text
                                              ]));

                                      symptomController.clear();
                                    } else {
                                      CustomDialog.showToast(
                                          message:
                                              'You can only add a maximum of 5 symptoms',
                                          type: ToastType.error);
                                    }
                                  } else {
                                    CustomDialog.showToast(
                                        message: 'Please enter a symptom',
                                        type: ToastType.error);
                                  }
                                },
                                icon: Icon(MdiIcons.plusBox,
                                    color: primaryColor, size: 26)),
                          ),
                          const SizedBox(height: 10),
                          ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                    height: 5,
                                  ),
                              itemCount: ref
                                  .watch(newDiagnosisProvider)
                                  .symptoms!
                                  .length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var symptom = ref
                                    .watch(newDiagnosisProvider)
                                    .symptoms![index];
                                return ListTile(
                                  title: Text(symptom,
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700)),
                                  trailing: IconButton(
                                      onPressed: () {
                                        var diagnosis =
                                            ref.watch(newDiagnosisProvider);
                                        var symptoms = diagnosis.symptoms;
                                        symptoms!.removeAt(index);
                                        ref
                                            .read(newDiagnosisProvider.notifier)
                                            .setDiagnosis(diagnosis.copyWith(
                                                symptoms: symptoms));
                                      },
                                      icon: Icon(MdiIcons.close,
                                          color: primaryColor, size: 26)),
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
              text: 'Diagnose',
              onPressed: () {
                // check if symptoms are up to 3
                if (ref.watch(newDiagnosisProvider).symptoms!.length < 3) {
                  CustomDialog.showToast(
                      message: 'You need to add at least 3 symptoms',
                      type: ToastType.error);
                } else {
                  //send to diagnosis page
                  ref.read(newDiagnosisProvider.notifier).submit(ref);
                  ref.read(diagnosisIndexProvider.notifier).state = 2;
                }
              }),
        )
      ],
    );
  }
}
