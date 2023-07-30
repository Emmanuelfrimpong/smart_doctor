import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/state/data_state.dart';
import '../../../../../state/appointemt_data_state.dart';
import '../../../../../styles/colors.dart';
import '../../../core/components/widgets/smart_dialog.dart';
import '../../../core/functions.dart';
import '../../../models/appointment_model.dart';
import '../../../state/user_data_state.dart';
import '../../../styles/styles.dart';

class AppointmentCard extends ConsumerStatefulWidget {
  const AppointmentCard(this.id, {super.key});
  final String id;

  @override
  ConsumerState<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends ConsumerState<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    final appointment = ref.watch(singleAppointmentStreamProvider(widget.id));
    final isUser = ref.watch(userTypeProvider)!.toLowerCase() == 'user';

    return appointment.when(loading: () {
      return Container(
        padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8, right: 15),
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: primaryColor.withOpacity(0.1),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
                child: SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator())),
          ],
        ),
      );
    }, error: (error, stackTrace) {
      return Container(
        padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8, right: 15),
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: primaryColor.withOpacity(0.1),
        child: Text(
          'Something went wrong',
          style: normalText(fontSize: 12),
        ),
      );
    }, data: (data) {
      return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration:
              BoxDecoration(color: primaryColor.withOpacity(.1), boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Appointment with',
                        textAlign: TextAlign.center,
                        style: normalText(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor)),
                  ),
                  PopupMenuButton(
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        takeAction(value, context, data);
                      },
                      itemBuilder: (context) {
                        return [
                          //if user is the counsellor and the appointment is pending show accept and reject
                          if (!isUser && data.status == 'Pending')
                            const PopupMenuItem(
                              value: 'Accept',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text('Accept'),
                                ],
                              ),
                            ),
                          if (!isUser && data.status == 'Accepted')
                            const PopupMenuItem(
                              value: 'End',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text('End Appointment'),
                                ],
                              ),
                            ),
                          if (data.status != 'Ended' &&
                              data.status != 'Cancelled')
                            const PopupMenuItem(
                              value: 'Cancel',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text('Cancel'),
                                ],
                              ),
                            ),
                          if (isUser &&
                              (data.status == 'Pending' ||
                                  data.status == 'Cancelled'))
                            const PopupMenuItem(
                              value: 'Delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          if (data.status != 'Ended' &&
                              data.status != 'Cancelled' &&
                              data.status != 'Accepted')
                            const PopupMenuItem(
                              value: 'Reschedule',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text('Reschedule'),
                                ],
                              ),
                            ),
                        ];
                      },
                      icon: const Icon(Icons.more_vert)),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  if (isUser)
                    Container(
                      height: 150,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: data.doctorImage != null
                            ? DecorationImage(
                                image: NetworkImage(data.doctorImage!),
                                fit: BoxFit.fill,
                              )
                            : null,
                      ),
                    ),
                  if (!isUser)
                    Container(
                      height: 150,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: data.userImage != null
                            ? DecorationImage(
                                image: NetworkImage(data.userImage!),
                                fit: BoxFit.fill,
                              )
                            : null,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            isUser
                                ? data.doctorName ?? ''
                                : data.userName ?? '',
                            style: normalText(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date: ',
                                style: normalText(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(getDateFromDate(data.date!),
                                style: normalText(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Time: ',
                                style: normalText(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(getTimeFromDate(data.time!),
                                style: normalText(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status: ',
                                style: normalText(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(data.status ?? '',
                                style: normalText(
                                    color: data.status == 'Pending'
                                        ? Colors.grey
                                        : data.status == 'Cancelled'
                                            ? Colors.red
                                            : primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ));
    });
  }

  void takeAction(String? value, BuildContext context, AppointmentModel data) {
    ref.read(selectedAppointmentProvider.notifier).setAppointment(data);
    if (value == 'Accept') {
      CustomDialog.showInfo(
          title: 'Accept Appointment',
          message:
              'Are you sure you want to accept this appointment?\nDate: ${getDateFromDate(ref.read(selectedAppointmentProvider).date!)}\nTime: ${getTimeFromDate(ref.read(selectedAppointmentProvider).time!)}',
          onConfirm: () {
            ref
                .read(selectedAppointmentProvider.notifier)
                .updateAppointment('Accepted');
          },
          onConfirmText: 'Accept');
    } else if (value == 'Cancel') {
      CustomDialog.showInfo(
          title: 'Update',
          onConfirmText: 'Yes',
          message: 'Are you sure you want to cancel this appointment?',
          onConfirm: () {
            ref
                .read(selectedAppointmentProvider.notifier)
                .updateAppointment('Cancelled');
          });
    } else if (value == 'Reschedule') {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(data.date!);
      TimeOfDay time = TimeOfDay.fromDateTime(
          DateTime.fromMillisecondsSinceEpoch(data.time!));
      showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime.now(),
        lastDate: DateTime(2024),
      ).then((value) {
        if (value != null) {
          //show time picker
          ref
              .read(selectedAppointmentProvider.notifier)
              .setDate(value.millisecondsSinceEpoch);
          showTimePicker(
            context: context,
            initialTime: time,
          ).then((value) {
            if (value != null) {
              ref
                  .read(selectedAppointmentProvider.notifier)
                  .setTime(value.toDateTime().millisecondsSinceEpoch);
              CustomDialog.showInfo(
                  title: 'Reschedule Appointment',
                  message:
                      'Are you sure you want to reschedule this appointment?\nDate: ${getDateFromDate(ref.read(selectedAppointmentProvider).date!)}\nTime: ${getTimeFromDate(ref.read(selectedAppointmentProvider).time!)}',
                  onConfirm: () {
                    ref
                        .read(selectedAppointmentProvider.notifier)
                        .rescheduleAppointment();
                  },
                  onConfirmText: 'Reschedule');
            }
          });
        }
      });
    } else if (value == 'End') {
      CustomDialog.showInfo(
          title: 'End Appointment',
          message:
              'Are you sure you want to end this appointment?\nDate: ${getDateFromDate(ref.read(selectedAppointmentProvider).date!)}\nTime: ${getTimeFromDate(ref.read(selectedAppointmentProvider).time!)}',
          onConfirm: () {
            ref
                .read(selectedAppointmentProvider.notifier)
                .updateAppointment('Ended');
          },
          onConfirmText: 'End');
    } else if (value == 'Delete') {
      CustomDialog.showInfo(
          title: 'Delete Appointment',
          message:
              'Are you sure you want to delete this appointment?\nDate: ${getDateFromDate(ref.read(selectedAppointmentProvider).date!)}\nTime: ${getTimeFromDate(ref.read(selectedAppointmentProvider).time!)}',
          onConfirm: () {
            ref.read(selectedAppointmentProvider.notifier).deleteAppointment();
          },
          onConfirmText: 'Delete');
    }
  }
}
