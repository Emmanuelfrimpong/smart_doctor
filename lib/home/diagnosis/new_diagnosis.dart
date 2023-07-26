import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/constants/enums.dart';
import 'package:smart_doctor/core/components/widgets/custom_button.dart';
import 'package:smart_doctor/core/components/widgets/custom_drop_down.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/state/diagnosis_data_state.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../core/components/constants/strings.dart';
import '../../state/user_data_state.dart';

class NewDiagnosisPage extends ConsumerStatefulWidget {
  const NewDiagnosisPage({super.key});

  @override
  ConsumerState<NewDiagnosisPage> createState() => _NewDiagnosisPageState();
}

class _NewDiagnosisPageState extends ConsumerState<NewDiagnosisPage> {
  String? selectedSymptomText;
  Map<String, dynamic>? selectedSymptom;
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
                          CustomDropDown(
                            hintText: 'Select symptoms',
                            value: selectedSymptomText,
                            onChanged: (value) {
                              setState(() {
                                selectedSymptomText = value;
                                selectedSymptom = symptomsList
                                    .where(
                                        (element) => element['Name'] == value)
                                    .first;
                              });
                            },
                            items: symptomsList
                                .map((e) => DropdownMenuItem(
                                    value: e['Name'].toString(),
                                    child: Text(e['Name'].toString())))
                                .toList(),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (selectedSymptom != null) {
                                        //check if symptoms do not exist
                                        //check if symptom is less than 5
                                        if (ref
                                                .watch(newSymptomsListProvider)
                                                .length >=
                                            5) {
                                          CustomDialog.showToast(
                                              message:
                                                  'You can only add 5 symptoms',
                                              type: ToastType.error);
                                        } else {
                                          if (ref
                                              .watch(newSymptomsListProvider)
                                              .contains(selectedSymptom)) {
                                            CustomDialog.showToast(
                                                message:
                                                    'Symptom already added',
                                                type: ToastType.error);
                                          } else {
                                            ref
                                                .read(newSymptomsListProvider)
                                                .add(selectedSymptom!);
                                            setState(() {
                                              selectedSymptom = null;
                                              selectedSymptomText = null;
                                            });
                                          }
                                        }
                                      } else {
                                        CustomDialog.showToast(
                                            message: 'Select a symptom',
                                            type: ToastType.error);
                                      }
                                    },
                                    icon: Icon(MdiIcons.plusBox,
                                        color: primaryColor, size: 32))
                              ]),
                          const SizedBox(height: 10),
                          ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount:
                                  ref.watch(newSymptomsListProvider).length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var symptoms =
                                    ref.watch(newSymptomsListProvider);
                                symptoms.reversed;
                                var symptom = symptoms[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(symptom['Name'],
                                      style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700)),
                                  trailing: IconButton(
                                      padding: EdgeInsets.zero,
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
                                          color: primaryColor, size: 18)),
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
                if (ref.watch(newSymptomsListProvider).length < 3) {
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
