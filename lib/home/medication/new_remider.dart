import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/widgets/custom_button.dart';
import 'package:smart_doctor/core/components/widgets/custom_drop_down.dart';
import 'package:smart_doctor/core/components/widgets/custom_input.dart';
import 'package:smart_doctor/state/medication_data_state.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import 'medication_type.dart';

class NewMedicationPage extends ConsumerStatefulWidget {
  const NewMedicationPage(this.id, {super.key});
  final String? id;

  @override
  ConsumerState<NewMedicationPage> createState() => _NewMedicationPageState();
}

class _NewMedicationPageState extends ConsumerState<NewMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  String? scheduleType = 'week';
  String? timeType = 'timeOfDay';
  @override
  Widget build(BuildContext context) {
    var id = widget.id ?? ref.watch(userProvider).id;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'New Medication',
          style: normalText(fontSize: 22, color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MedicationType(
                    title: 'Syrup',
                    icon: Icons.medication_liquid,
                    isSelected: ref.watch(medicationTypeProvider) == 'Syrup',
                    onTap: () {
                      ref.read(medicationTypeProvider.notifier).state = 'Syrup';
                    },
                  ),
                  MedicationType(
                    title: 'Tablet',
                    icon: Icons.apps,
                    isSelected: ref.watch(medicationTypeProvider) == 'Tablet',
                    onTap: () {
                      ref.read(medicationTypeProvider.notifier).state =
                          'Tablet';
                      ref.read(medicationMeasurementProvider.notifier).state =
                          'Tablets';
                    },
                  ),
                  MedicationType(
                    title: 'Capsule',
                    isSelected: ref.watch(medicationTypeProvider) == 'Capsule',
                    icon: MdiIcons.pill,
                    onTap: () {
                      ref.read(medicationTypeProvider.notifier).state =
                          'Capsule';
                      ref.read(medicationMeasurementProvider.notifier).state =
                          'Capsules';
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Medicine Name',
                prefixIcon: Icons.medication,
                validator: (name) {
                  if (name!.isEmpty) {
                    return 'Medicine name is required';
                  }
                  return null;
                },
                onSaved: (name) {
                  ref
                      .read(newMedicationProvider.notifier)
                      .setMedicineName(name);
                },
              ),
              const SizedBox(height: 20),
              //dosage
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextFields(
                      label: 'Medicine Dosage',
                      prefixIcon: Icons.scale,
                      keyboardType: TextInputType.number,
                      isDigitOnly: true,
                      validator: (dosage) {
                        if (dosage!.isEmpty) {
                          return 'Medicine dosage is required';
                        }
                        return null;
                      },
                      onSaved: (dosage) {
                        ref
                            .read(newMedicationProvider.notifier)
                            .setMedicineDosage(double.parse(dosage!));
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (ref.watch(medicationTypeProvider) == 'Syrup')
                    Expanded(
                      flex: 1,
                      child: CustomDropDown(
                          value: ref.watch(medicationMeasurementProvider),
                          validator: (value) {
                            if (ref.watch(medicationTypeProvider) == 'Syrup' &&
                                value == null) {
                              return 'Measurement is required';
                            }
                            return null;
                          },
                          items: [
                            'ml',
                            'tsp',
                          ]
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            ref
                                .read(medicationMeasurementProvider.notifier)
                                .state = value.toString();
                          }),
                    ),
                  if (ref.watch(medicationTypeProvider) == 'Tablet')
                    Text(
                      'Tablets',
                      style:
                          normalText(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  if (ref.watch(medicationTypeProvider) == 'Capsule')
                    Text(
                      'Capsules',
                      style:
                          normalText(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                ],
              ),
              const SizedBox(height: 20),
              //add note
              CustomTextFields(
                label: 'Add Note',
                prefixIcon: Icons.note,
                maxLines: 2,
                onSaved: (note) {
                  ref
                      .read(newMedicationProvider.notifier)
                      .setMedicineNote(note);
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Medicine Schedule (Day)'.toUpperCase(),
                style: GoogleFonts.poppins(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // horizontal list of days
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Radio(
                      activeColor: primaryColor,
                      groupValue: scheduleType,
                      value: 'week',
                      onChanged: (value) {
                        //clear list
                        ref
                            .read(medicationDaysListProvider.notifier)
                            .clearList();
                        setState(() {
                          scheduleType = value;
                        });
                      },
                    ),
                    Text(
                      'Use Time of the week',
                      style: normalText(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: scheduleType == 'week'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 40),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationDaysListProvider)
                                  .contains('Today')) {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .removeDay('Today');
                              } else {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .addDay('Today');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationDaysListProvider)
                                        .contains('Today')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Today',
                                style: normalText(
                                    color: ref
                                            .watch(medicationDaysListProvider)
                                            .contains('Today')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationDaysListProvider)
                                  .contains('Tomorrow')) {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .removeDay('Tomorrow');
                              } else {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .addDay('Tomorrow');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationDaysListProvider)
                                        .contains('Tomorrow')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Tomorrow',
                                style: normalText(
                                    color: ref
                                            .watch(medicationDaysListProvider)
                                            .contains('Tomorrow')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      )
                    : null,
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Radio(
                      activeColor: primaryColor,
                      groupValue: scheduleType,
                      value: 'days',
                      onChanged: (value) {
                        //clear list
                        ref
                            .read(medicationDaysListProvider.notifier)
                            .clearList();
                        setState(() {
                          scheduleType = value;
                        });
                      },
                    ),
                    Text(
                      'Use Days',
                      style: normalText(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: scheduleType == 'days'
                    ? Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        runSpacing: 10,
                        children: [
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationDaysListProvider)
                                  .contains('Monday')) {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .removeDay('Monday');
                              } else {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .addDay('Monday');
                              }
                            },
                            child: Container(
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationDaysListProvider)
                                        .contains('Monday')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Mon',
                                style: normalText(
                                    color: ref
                                            .watch(medicationDaysListProvider)
                                            .contains('Monday')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationDaysListProvider)
                                  .contains('Tuesday')) {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .removeDay('Tuesday');
                              } else {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .addDay('Tuesday');
                              }
                            },
                            child: Container(
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationDaysListProvider)
                                        .contains('Tuesday')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Tue',
                                style: normalText(
                                    color: ref
                                            .watch(medicationDaysListProvider)
                                            .contains('Tuesday')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationDaysListProvider)
                                  .contains('Wednesday')) {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .removeDay('Wednesday');
                              } else {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .addDay('Wednesday');
                              }
                            },
                            child: Container(
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationDaysListProvider)
                                        .contains('Wednesday')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Wed',
                                style: normalText(
                                    color: ref
                                            .watch(medicationDaysListProvider)
                                            .contains('Wednesday')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationDaysListProvider)
                                  .contains('Thursday')) {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .removeDay('Thursday');
                              } else {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .addDay('Thursday');
                              }
                            },
                            child: Container(
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationDaysListProvider)
                                        .contains('Thursday')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Thu',
                                style: normalText(
                                    color: ref
                                            .watch(medicationDaysListProvider)
                                            .contains('Thursday')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationDaysListProvider)
                                  .contains('Friday')) {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .removeDay('Friday');
                              } else {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .addDay('Friday');
                              }
                            },
                            child: Container(
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationDaysListProvider)
                                        .contains('Friday')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Fri',
                                style: normalText(
                                    color: ref
                                            .watch(medicationDaysListProvider)
                                            .contains('Friday')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationDaysListProvider)
                                  .contains('Saturday')) {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .removeDay('Saturday');
                              } else {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .addDay('Saturday');
                              }
                            },
                            child: Container(
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationDaysListProvider)
                                        .contains('Saturday')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Sat',
                                style: normalText(
                                    color: ref
                                            .watch(medicationDaysListProvider)
                                            .contains('Saturday')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationDaysListProvider)
                                  .contains('Sunday')) {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .removeDay('Sunday');
                              } else {
                                ref
                                    .read(medicationDaysListProvider.notifier)
                                    .addDay('Sunday');
                              }
                            },
                            child: Container(
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationDaysListProvider)
                                        .contains('Sunday')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Sun',
                                style: normalText(
                                    color: ref
                                            .watch(medicationDaysListProvider)
                                            .contains('Sunday')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                'Medicine Schedule (Time)'.toUpperCase(),
                style: GoogleFonts.poppins(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Radio(
                      activeColor: primaryColor,
                      groupValue: timeType,
                      value: 'timeOfDay',
                      onChanged: (value) {
                        //clear list
                        ref
                            .read(medicationTimeListProvider.notifier)
                            .clearList();
                        setState(() {
                          timeType = value;
                        });
                      },
                    ),
                    Text(
                      'Use Time of Day',
                      style: normalText(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: timeType == 'timeOfDay'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 40),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationTimeListProvider)
                                  .contains('Morning')) {
                                ref
                                    .read(medicationTimeListProvider.notifier)
                                    .removeTime('Morning');
                              } else {
                                ref
                                    .read(medicationTimeListProvider.notifier)
                                    .addTme('Morning');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationTimeListProvider)
                                        .contains('Morning')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Morning',
                                style: normalText(
                                    color: ref
                                            .watch(medicationTimeListProvider)
                                            .contains('Morning')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationTimeListProvider)
                                  .contains('Afternoon')) {
                                ref
                                    .read(medicationTimeListProvider.notifier)
                                    .removeTime('Afternoon');
                              } else {
                                ref
                                    .read(medicationTimeListProvider.notifier)
                                    .addTme('Afternoon');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationTimeListProvider)
                                        .contains('Afternoon')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Afternoon',
                                style: normalText(
                                    color: ref
                                            .watch(medicationTimeListProvider)
                                            .contains('Afternoon')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              if (ref
                                  .watch(medicationTimeListProvider)
                                  .contains('Evening')) {
                                ref
                                    .read(medicationTimeListProvider.notifier)
                                    .removeTime('Evening');
                              } else {
                                ref
                                    .read(medicationTimeListProvider.notifier)
                                    .addTme('Evening');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 3))
                                ],
                                color: ref
                                        .watch(medicationTimeListProvider)
                                        .contains('Evening')
                                    ? primaryColor
                                    : Colors.white,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              child: Text(
                                'Evening',
                                style: normalText(
                                    color: ref
                                            .watch(medicationTimeListProvider)
                                            .contains('Evening')
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      )
                    : null,
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Radio(
                      activeColor: primaryColor,
                      groupValue: timeType,
                      value: 'specific',
                      onChanged: (value) {
                        //clear list
                        ref
                            .read(medicationTimeListProvider.notifier)
                            .clearList();
                        setState(() {
                          timeType = value;
                        });
                      },
                    ),
                    Text(
                      'Use Specific Time',
                      style: normalText(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    if (timeType == 'specific')
                      IconButton(
                          onPressed: () {
                            //open time picker
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              if (value != null) {
                                ref
                                    .read(medicationTimeListProvider.notifier)
                                    .addTme(
                                        '${value.hour.toString().length < 2 ? '0${value.hour}' : value.hour}:${value.minute.toString().length < 2 ? '0${value.minute}' : value.minute} ${value.period.toString().split('.').last}');
                              }
                            });
                          },
                          icon: Icon(
                            MdiIcons.calendar,
                            color: secondaryColor,
                          ))
                  ],
                ),
                subtitle: timeType == 'specific'
                    ? ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              indent: 30,
                            ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ref.watch(medicationTimeListProvider).length,
                        itemBuilder: (context, index) {
                          var item =
                              ref.watch(medicationTimeListProvider)[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item,
                                  style: normalText(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      ref
                                          .read(medicationTimeListProvider
                                              .notifier)
                                          .removeTime(item);
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      size: 18,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          );
                        })
                    : null,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Save Medication',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ref
                        .read(newMedicationProvider.notifier)
                        .saveMedication(id!, context, ref);
                  }
                },
              ),

              const SizedBox(height: 30),
            ]),
          ),
        ),
      ),
    );
  }
}
