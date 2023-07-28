import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/components/constants/enums.dart';
import 'package:smart_doctor/core/components/widgets/smart_dialog.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import '../../core/components/widgets/custom_button.dart';
import '../../core/functions.dart';
import '../../state/appointemt_data_state.dart';
import '../../state/doctor_data_state.dart';
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
          body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  // ref.read(selectedDoctorProvider.notifier).state = null;
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        data.when(error: (e, s) {
          return Center(
              child: Text(
            'Something went wrong',
            style: normalText(color: Colors.grey),
          ));
        }, loading: () {
          return const Center(
              child: SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator()));
        }, data: (doctor) {
          return Expanded(
            child: Stack(children: [
              if (doctor.profile != null)
                Image.network(
                  doctor.profile!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(5),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          const SizedBox(height: 10),
                          //name
                          Text(doctor.name ?? "Name",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                          //specialty
                          Text("(${doctor.specialty ?? "Specialty"})",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700)),
                          //rating stars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(doctor.rating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 5),
                              for (var i = 0; i < doctor.rating!.toInt(); i++)
                                const Icon(Icons.star,
                                    color: primaryColor, size: 16),
                            ],
                          ),
                          const Divider(
                            thickness: 8,
                            color: secondaryColor,
                            indent: 30,
                            endIndent: 30,
                          ),
                          const SizedBox(height: 15),
                          //phone
                          Row(
                            children: [
                              Icon(MdiIcons.phone,
                                  color: primaryColor, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(doctor.phone ?? "Phone Number",
                                    style: normalText(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black45,
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          //address
                          Row(
                            children: [
                              Icon(MdiIcons.mapMarker,
                                  color: primaryColor, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(doctor.address ?? "Address",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: normalText(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black45,
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          //hospital
                          Row(
                            children: [
                              Icon(MdiIcons.hospital,
                                  color: primaryColor, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(doctor.hospital ?? "Hospital",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: normalText(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black45,
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                          //about
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Icon(MdiIcons.information,
                                    color: primaryColor, size: 18),
                                const SizedBox(width: 10),
                                Text('About',
                                    style: normalText(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black45,
                                        fontSize: 16)),
                              ],
                            ),
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(doctor.about ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: normalText(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black45,
                                      fontSize: 15)),
                            ),
                          ),
                          const Divider(),

                          if (doctor.images != null &&
                              doctor.images!.isNotEmpty)
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: doctor.images!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          doctor.images![index],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }),
                            ),

                          LayoutBuilder(builder: (context, constraints) {
                            var stream =
                                ref.watch(doctorAppointmentStreamProvider);
                            return stream.when(
                                data: (data) {
                                  if (data.isEmpty) {
                                    return CustomButton(
                                      color: primaryColor,
                                      text: 'Book Appointment',
                                      onPressed: () {
                                        getDateTimes(context, doctor);
                                      },
                                      icon: MdiIcons.calendarPlus,
                                    );
                                  } else {
                                    return Text(
                                        'You have a pending Appointment with ${data.first.doctorName}',
                                        style: normalText(color: Colors.grey));
                                  }
                                },
                                loading: () => const SizedBox(
                                    height: 20,
                                    width: 200,
                                    child: LinearProgressIndicator(
                                      color: primaryColor,
                                    )),
                                error: (error, stackTrace) {
                                  //throw error
                                  return Center(
                                    child: Text(
                                      'Something went wrong',
                                      style: normalText(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  );
                                });
                          })
                        ])),
                      ),
                    )),
              )
            ]),
          );
        }),
      ])),
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
