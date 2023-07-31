import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/constants/enums.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import '../../core/components/widgets/custom_button.dart';
import '../../core/functions.dart';
import '../../state/appointemt_data_state.dart';
import '../../state/consultation_data_state.dart';
import '../../state/doctor_data_state.dart';
import '../../state/my_doctor_patient_data_state.dart';
import '../../styles/colors.dart';
import '../../styles/styles.dart';

class DoctorViewPage extends ConsumerStatefulWidget {
  const DoctorViewPage({super.key});

  @override
  ConsumerState<DoctorViewPage> createState() => _DoctorViewPageState();
}

class _DoctorViewPageState extends ConsumerState<DoctorViewPage> {
  @override
  Widget build(BuildContext context) {
    String id = ref.watch(selectedDoctorProvider)!.id!;
    var data = ref.watch(singleDoctorStreamProvider(id));
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),
                    color: primaryColor),
              ),
              Transform.translate(
                offset: const Offset(0, -50),
                child: Card(
                  elevation: 5,
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.75,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: data.when(data: (doctor) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // doctor Online status
                                Text(
                                  doctor.isOnline! ? 'Online' : 'Offline',
                                  style: normalText(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: doctor.isOnline!
                                          ? Colors.green
                                          : Colors.red),
                                ),

                                Transform.translate(
                                  offset: const Offset(0, -50),
                                  child: doctor.profile != null
                                      ? InkWell(
                                          onTap: () {
                                            CustomDialog.showImageDialog(
                                              path: doctor.profile!,
                                            );
                                          },
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                                NetworkImage(doctor.profile!),
                                          ),
                                        )
                                      : const CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.person,
                                              color: primaryColor,
                                              size: 45,
                                            ),
                                          ),
                                        ),
                                ),
                                // doctor rating
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: secondaryColor,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      doctor.rating!.toStringAsFixed(1),
                                      style: normalText(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      doctor.name!,
                                      style: normalText(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '(${doctor.specialty!})',
                                      style: normalText(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45),
                                    ),
                                    const SizedBox(height: 15),
                                    ListTile(
                                      title: Text('10yrs Experience',
                                          style: normalText(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),
                                      subtitle: doctor.images != null &&
                                              doctor.images!.isNotEmpty
                                          ? SizedBox(
                                              height: 100,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        CustomDialog
                                                            .showImageDialog(
                                                          path: doctor
                                                              .images![index],
                                                        );
                                                      },
                                                      child: Image.network(
                                                        doctor.images![index],
                                                        width: 100,
                                                        height: 90,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount:
                                                    doctor.images!.length,
                                                shrinkWrap: true,
                                              ),
                                            )
                                          : const SizedBox(
                                              height: 100,
                                              child: Center(
                                                child:
                                                    Text('No images uploaded'),
                                              ),
                                            ),
                                    ),
                                    //doctor address
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: primaryColor,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(doctor.address ?? '',
                                            style: normalText(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black54)),
                                      ],
                                    ),
                                    //hospital name
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.local_hospital,
                                          color: primaryColor,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(doctor.hospital ?? '',
                                            style: normalText(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black54)),
                                      ],
                                    ),
                                    const SizedBox(height: 25),
                                    //appointment button, consultation button and add to my doctors button
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Card(
                                          color: Colors.white,
                                          child: SizedBox(
                                            width: 110,
                                            height: 110,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: LayoutBuilder(builder:
                                                  (context, constraints) {
                                                var stream = ref.watch(
                                                    doctorAppointmentStreamProvider);
                                                return stream.when(
                                                    data: (data) {
                                                      if (data.isEmpty) {
                                                        return InkWell(
                                                          onTap: () {
                                                            getDateTimes(
                                                                context,
                                                                doctor);
                                                          },
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  MdiIcons
                                                                      .calendarPlus,
                                                                  color:
                                                                      primaryColor,
                                                                  size: 30,
                                                                ),
                                                                const SizedBox(
                                                                    height: 5),
                                                                Text('Book\nAppointment',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: normalText(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .black54)),
                                                              ]),
                                                        );
                                                      } else {
                                                        return Center(
                                                          child: Text(
                                                              'You have a pending Appointment with ${data.first.doctorName}',
                                                              style: normalText(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black)),
                                                        );
                                                      }
                                                    },
                                                    loading: () => const Center(
                                                          child: SizedBox(
                                                              height: 40,
                                                              width: 40,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color:
                                                                    primaryColor,
                                                              )),
                                                        ),
                                                    error: (error, stackTrace) {
                                                      //throw error
                                                      return Center(
                                                        child: Text(
                                                          'Something went wrong',
                                                          style: normalText(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      );
                                                    });
                                              }),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.white,
                                          child: SizedBox(
                                            width: 110,
                                            height: 110,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: LayoutBuilder(builder:
                                                  (context, constraints) {
                                                var stream = ref.watch(
                                                    activeConsultationStream(
                                                        doctor.id!));
                                                return stream.when(loading: () {
                                                  return const Center(
                                                      child: SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child:
                                                              CircularProgressIndicator()));
                                                }, error: (e, s) {
                                                  return Center(
                                                    child: Text(
                                                        'Something went wrong',
                                                        style: normalText(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black)),
                                                  );
                                                }, data: (data) {
                                                  if (data.isEmpty) {
                                                    return InkWell(
                                                      onTap: () {
                                                        CustomDialog.showInfo(
                                                            title:
                                                                'Start Consultation',
                                                            message:
                                                                'Are you sure you want '
                                                                'to start a consultation with '
                                                                '${doctor.name}?',
                                                            onConfirm: () {
                                                              ref
                                                                  .read(selectedDoctorProvider
                                                                      .notifier)
                                                                  .state = doctor;
                                                              ref
                                                                  .read(currentConsultationProvider
                                                                      .notifier)
                                                                  .bookConsultation(
                                                                      context,
                                                                      ref);
                                                            },
                                                            onConfirmText:
                                                                'Submit');
                                                      },
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              MdiIcons.video,
                                                              color:
                                                                  primaryColor,
                                                              size: 30,
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text('Consult',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: normalText(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black54)),
                                                          ]),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: Text(
                                                        'You already have an open or pending consulattion request',
                                                        style: normalText(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    );
                                                  }
                                                });
                                              }),
                                            ),
                                          ),
                                        ),
                                        Card(
                                          color: Colors.white,
                                          child: SizedBox(
                                            width: 110,
                                            height: 110,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: LayoutBuilder(builder:
                                                  (context, constraints) {
                                                var stream = ref.watch(
                                                    inMyDoctorStreamProvider(
                                                        doctor.id!));
                                                return stream.when(loading: () {
                                                  return const Center(
                                                      child: SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: primaryColor,
                                                          )));
                                                }, error: (e, s) {
                                                  return Center(
                                                    child: Text(
                                                        'Something went wrong',
                                                        style: normalText(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black)),
                                                  );
                                                }, data: (data) {
                                                  if (data.isEmpty) {
                                                    return InkWell(
                                                      onTap: () {
                                                        CustomDialog.showInfo(
                                                            title: 'Add Doctor',
                                                            message:
                                                                'Are you sure you want '
                                                                'to add ${doctor.name} to your doctors?',
                                                            onConfirm: () {
                                                              ref
                                                                  .read(myDoctorPatientProvider
                                                                      .notifier)
                                                                  .addDoctor(
                                                                      doctor,
                                                                      ref);
                                                            },
                                                            onConfirmText:
                                                                'Yes|Add');
                                                      },
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              MdiIcons
                                                                  .accountPlus,
                                                              color:
                                                                  primaryColor,
                                                              size: 30,
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                                'Add to\nMy Doctors',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: normalText(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black54)),
                                                          ]),
                                                    );
                                                  } else {
                                                    return Center(
                                                      child: Text(
                                                          'Doctor already part of your doctors',
                                                          style: normalText(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .black)),
                                                    );
                                                  }
                                                });
                                              }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 25),
                                    //doctor bio
                                    ListTile(
                                        title: Text('About',
                                            style: normalText(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                        subtitle: Text(
                                          doctor.about ?? '',
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          style: normalText(
                                              fontSize: 13,
                                              color: Colors.black45),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }, error: (error, stack) {
                        return const Center(
                            child: Text('Something went wrong'));
                      }, loading: () {
                        return const Center(
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator()));
                      })),
                ),
              )
            ]),
          )),
    );
  }

  void getDateTimes(BuildContext context, DoctorModel counsellor) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select Date and Time',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                          ).then((value) {
                            if (value != null) {
                              ref
                                  .read(currentAppointmentProvider.notifier)
                                  .setDate(value);
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text('Date:',
                                style: normalText(color: Colors.blue)),
                            const SizedBox(width: 10),
                            if (ref.watch(currentAppointmentProvider).date !=
                                null)
                              Text(
                                  getDateFromDate(ref
                                      .watch(currentAppointmentProvider)
                                      .date),
                                  style: normalText(
                                      color: primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            if (value != null) {
                              ref
                                  .read(currentAppointmentProvider.notifier)
                                  .setTime(value, context);
                            }
                          });
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text('Time: ',
                                style: normalText(color: Colors.blue)),
                            const SizedBox(width: 10),
                            if (ref.watch(currentAppointmentProvider).time !=
                                null)
                              Text(
                                  getTimeFromDate(ref
                                      .watch(currentAppointmentProvider)
                                      .time),
                                  style: normalText(
                                      color: primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  color: primaryColor,
                  text: 'Book',
                  onPressed: () {
                    //check if date and time selected
                    if (ref.watch(currentAppointmentProvider).time != null &&
                        ref.watch(currentAppointmentProvider).date != null) {
                      ref
                          .read(currentAppointmentProvider.notifier)
                          .bookAppointment(context, ref);
                    } else {
                      CustomDialog.showToast(
                          message: 'Please select date and time',
                          type: ToastType.error);
                    }
                  },
                  icon: MdiIcons.calendarPlus,
                ),
              ],
            ),
          );
        });
  }
}
