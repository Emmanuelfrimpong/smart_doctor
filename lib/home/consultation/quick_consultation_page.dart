import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/widgets/custom_drop_down.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/home/consultation/consultation_chat_page.dart';

import '../../core/components/widgets/custom_button.dart';
import '../../core/functions.dart';
import '../../state/consultation_data_state.dart';
import '../../state/doctor_data_state.dart';
import '../../styles/colors.dart';
import '../../styles/styles.dart';

class QuickConsultationPage extends ConsumerStatefulWidget {
  const QuickConsultationPage({super.key});

  @override
  ConsumerState<QuickConsultationPage> createState() =>
      _QuickConsultationPageState();
}

class _QuickConsultationPageState extends ConsumerState<QuickConsultationPage> {
  @override
  Widget build(BuildContext context) {
    var sortedList = ref.watch(doctorsBySpecialtyProvider);

    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'Quick Consultation',
          style: normalText(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SizedBox(
        height: size.height,
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    color: primaryColor),
                child: Text(
                  'Find a doctor and speak with',
                  style: normalText(fontSize: 14, color: Colors.white),
                )),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -40),
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Select Hospital',
                          style: normalText(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        subtitle: CustomDropDown(
                          hintText: 'Select Hospital',
                          value: ref.watch(selectedHospitalProvider),
                          onChanged: (value) {
                            ref.read(selectedHospitalProvider.notifier).state =
                                value.toString();
                          },
                          items:
                              ['All', 'AAMUSTED Clinic', 'Kwadaso SDA Hospital']
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Select Specialty',
                          style: normalText(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        subtitle: CustomDropDown(
                          hintText: 'Select Specialty',
                          value: ref.watch(selectedSpecialtyProvider),
                          onChanged: (value) {
                            ref.read(selectedSpecialtyProvider.notifier).state =
                                value.toString();
                          },
                          items: [
                            'All',
                            'Dentist',
                            'Psychiatrist',
                            'Surgeon',
                            'Physician'
                          ]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                        ),
                      ),
                      if (sortedList.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              var user = sortedList[index];
                              var stream =
                                  ref.watch(activeConsultationStream(user.id!));
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: user.profile != null
                                            ? DecorationImage(
                                                image:
                                                    NetworkImage(user.profile!),
                                                fit: BoxFit.fill,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(user.name ?? "Name",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        //specialty
                                        Text(
                                            "(${user.specialty ?? "Specialty"})",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        const Divider(),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(MdiIcons.email,
                                                color: primaryColor, size: 18),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(user.email ?? "Email",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(MdiIcons.phone,
                                                color: primaryColor, size: 18),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                  user.phone ?? "Phone Number",
                                                  style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(MdiIcons.mapMarker,
                                                color: primaryColor, size: 18),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                  user.address ?? "Address",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        //hospital
                                        Row(
                                          children: [
                                            Icon(MdiIcons.hospital,
                                                color: primaryColor, size: 18),
                                            const SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                  user.hospital ?? "Hospital",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14)),
                                            ),
                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                        //rating
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                user.rating!.toStringAsFixed(1),
                                                style: const TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(width: 5),
                                            for (var i = 0;
                                                i < user.rating!.toInt();
                                                i++)
                                              const Icon(Icons.star,
                                                  color: primaryColor,
                                                  size: 16),
                                          ],
                                        ),
                                        //request consultation button
                                        stream.when(
                                          loading: () => const SizedBox(
                                              height: 20,
                                              width: double.infinity,
                                              child: LinearProgressIndicator(
                                                color: primaryColor,
                                              )),
                                          data: (data) {
                                            if (data.isEmpty) {
                                              return CustomButton(
                                                color: primaryColor,
                                                text: 'Request Consultation',
                                                onPressed: () {
                                                  CustomDialog.showInfo(
                                                      title:
                                                          'Start Consultation',
                                                      message:
                                                          'Are you sure you want '
                                                          'to start a consultation with '
                                                          '${user.name}?',
                                                      onConfirm: () {
                                                        ref
                                                            .read(
                                                                selectedDoctorProvider
                                                                    .notifier)
                                                            .state = user;
                                                        ref
                                                            .read(
                                                                currentConsultationProvider
                                                                    .notifier)
                                                            .bookConsultation(
                                                                context, ref);
                                                      },
                                                      onConfirmText: 'Submit');
                                                },
                                                icon: MdiIcons.chatProcessing,
                                              );
                                            } else {
                                              return CustomButton(
                                                color: secondaryColor,
                                                text: 'Continue Consultation',
                                                onPressed: () {
                                                  ref
                                                      .read(
                                                          currentConsultationProvider
                                                              .notifier)
                                                      .setCurrentConsultation(
                                                          data[0]);
                                                  ref
                                                      .read(
                                                          selectedConsultationProvider
                                                              .notifier)
                                                      .setSelectedConsultation(
                                                          data[0]);
                                                  sendToPage(context,
                                                      const ConsultationChatPage());
                                                },
                                                icon: MdiIcons.chatProcessing,
                                              );
                                            }
                                          },
                                          error: (error, stackTrace) => Center(
                                            child: Text(
                                              'Error',
                                              style: normalText(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            },
                            itemCount: sortedList.length,
                            shrinkWrap: true,
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
