import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/widgets/custom_input.dart';
import 'package:smart_doctor/core/functions.dart';
import 'package:smart_doctor/state/medication_data_state.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../core/components/constants/enums.dart';
import '../../core/components/widgets/smart_dialog.dart';
import 'new_remider.dart';

class MedicationPage extends ConsumerStatefulWidget {
  const MedicationPage({super.key});

  @override
  ConsumerState<MedicationPage> createState() => _MedicationPageState();
}

class _MedicationPageState extends ConsumerState<MedicationPage> {
  final FocusNode _focus = FocusNode();

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(medicationStreamProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'My Medication',
          style: normalText(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              icon: Icon(
                MdiIcons.plus,
                color: primaryColor,
              ),
              onPressed: () {
                sendToPage(
                    context, NewMedicationPage(ref.watch(userProvider).id));
              },
              label: Text(
                'Add ',
                style: normalText(
                    color: primaryColor, fontWeight: FontWeight.bold),
              )),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          CustomTextFields(
            hintText: 'Search Medication',
            focusNode: _focus,
            controller: _controller,
            color: primaryColor,
            suffixIcon: _focus.hasFocus
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        ref
                            .read(medicationSearchStringProvider.notifier)
                            .state = '';
                        _focus.unfocus();
                      });
                    },
                    icon: Icon(MdiIcons.close, color: primaryColor))
                : Icon(MdiIcons.magnify, color: primaryColor),
            onChanged: (p0) =>
                ref.read(medicationSearchStringProvider.notifier).state = p0,
          ),
          if (!_focus.hasFocus)
            data.when(data: (data) {
              if (data.isEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'No mediation found',
                        style: normalText(color: Colors.blue),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          icon: Icon(
                            MdiIcons.plus,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            sendToPage(context,
                                NewMedicationPage(ref.watch(userProvider).id));
                          },
                          label: Text(
                            'Add Medication',
                            style: normalText(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var medication = data[index];
                      return ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                medication.medicationName!,
                                style: normalText(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text('${dueIn(medication.duration!, context)}',
                                style: normalText(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  MdiIcons.pill,
                                  color: primaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Dosage',
                                    style: normalText(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                '${medication.medicationDosage} ${medication.medicationType}',
                                style: normalText(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  MdiIcons.calendar,
                                  color: primaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Duration',
                                    style: normalText(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Column(
                                children: [
                                  ListTile(
                                    subtitle: Wrap(
                                      children: [
                                        for (var day
                                            in medication.duration!['days']!)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Chip(
                                              label: Text(
                                                getDay(day),
                                                style: normalText(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: primaryColor,
                                            ),
                                          )
                                      ],
                                    ),
                                    title: Text(
                                      'Days',
                                      style: normalText(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ListTile(
                                    subtitle: Wrap(
                                      children: [
                                        for (var time
                                            in medication.duration!['times']!)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Chip(
                                              label: Text(
                                                time,
                                                style: normalText(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: primaryColor,
                                            ),
                                          )
                                      ],
                                    ),
                                    title: Text(
                                      'Times',
                                      style: normalText(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  MdiIcons.note,
                                  color: primaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text('Note',
                                    style: normalText(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                medication.medicationNote!,
                                style: normalText(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // end medication iconbutton, delete, off off and on notification
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () {
                                    CustomDialog.showToast(
                                        message:
                                            'Feature not available in debug mode',
                                        type: ToastType.error);
                                  },
                                  label: Text(
                                    'End Medication',
                                    style: normalText(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  icon: Icon(
                                    MdiIcons.cancel,
                                    color: Colors.white,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    CustomDialog.showToast(
                                        message:
                                            'Feature not available in debug mode',
                                        type: ToastType.error);
                                  },
                                  icon: Icon(
                                    MdiIcons.delete,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    CustomDialog.showToast(
                                        message:
                                            'Feature not available in debug mode',
                                        type: ToastType.error);
                                  },
                                  icon: Icon(
                                    MdiIcons.bellRing,
                                    color: primaryColor,
                                  )),
                            ],
                          )
                        ],
                      );
                    },
                    itemCount: data.length,
                  ),
                );
              }
            }, error: (e, s) {
              return Center(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                child: Text(
                  'Something went wrong',
                  style: normalText(color: Colors.black54),
                ),
              ));
            }, loading: () {
              return const Center(
                  child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator()));
            })
        ]),
      ),
    );
  }
}
