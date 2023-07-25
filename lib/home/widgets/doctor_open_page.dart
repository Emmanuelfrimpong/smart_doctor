import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import 'package:smart_doctor/state/doctors_data_state.dart';

import '../../core/components/widgets/custom_button.dart';
import '../../core/functions.dart';
import '../../state/appointemt_data_state.dart';
import '../../styles/colors.dart';
import '../../styles/styles.dart';


class DoctorViewPage extends ConsumerWidget {
  const DoctorViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DoctorModel? doctor = ref.watch(selectedDoctorProvider);
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: CustomButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          color: Colors.red,
                          text: 'Close',
                          onPressed: () => Navigator.pop(context),
                          icon: MdiIcons.closeBox,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (doctor!.profile != null)
                    Image.network(
                      doctor.profile!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            const Icon(Icons.star,
                                color: primaryColor, size: 20),
                            Text(doctor.rating.toString(),
                                style: normalText(
                                    color: primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                          ]))
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(doctor.name.toString(),
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email: ',
                        style: normalText(),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                          onPressed: () {},
                          child: Text(doctor.email.toString(),
                              style: normalText(color: Colors.blue))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phone: ',
                        style: normalText(),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                          onPressed: () {},
                          child: Text(doctor.phone.toString(),
                              style: normalText(color: Colors.blue))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Address: ',
                        style: normalText(),
                      ),
                      Text(doctor.address.toString(),
                          style: normalText(color: Colors.blue))
                    ],
                  ),
                  const Divider(),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('About',
                          style: normalText(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          doctor.about ?? '',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: normalText(fontSize: 14),
                        ),
                      )),
                  const Divider(),
                  SizedBox(
                    height: 50,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              var stream = ref.watch(appointmentStreamProvider);
                              return stream.when(
                                  data: (data) {
                                    if (data.isEmpty) {
                                      return CustomButton(
                                        color: primaryColor,
                                        text: 'Book Appointment',
                                        onPressed: () {
                                          getDateTimes(
                                              context, ref, doctor);
                                        },
                                        icon: MdiIcons.calendarPlus,
                                      );
                                    } else {
                                      return Text('Pending Appoint.',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              normalText(color: Colors.grey));
                                    }
                                  },
                                  loading: () => const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: LinearProgressIndicator(
                                        color: primaryColor,
                                      )),
                                  error: (error, stackTrace) {
                                    //throw error

                                    return Center(
                                      child: Text(
                                        'error',
                                        style: normalText(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    );
                                  });
                            }),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 20),
                ]),
          ),
        ),
      )),
    );
  }


  void getDateTimes(BuildContext context, WidgetRef ref, DoctorModel counsellor) {
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
                    ref
                        .read(currentAppointmentProvider.notifier)
                        .bookAppointment(context, ref);
                  },
                  icon: MdiIcons.calendarPlus,
                ),
              ],
            ),
          );
        });
  }
}