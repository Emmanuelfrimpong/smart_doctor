import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:smart_doctor/home/consultation/consultation_chat_page.dart';
import 'package:smart_doctor/models/consultation_model.dart';
import 'package:smart_doctor/state/data_state.dart';
import 'package:smart_doctor/state/doctor_data_state.dart';
import '../../core/components/widgets/smart_dialog.dart';
import '../../core/functions.dart';
import '../../state/consultation_data_state.dart';
import '../../state/user_data_state.dart';
import '../../styles/colors.dart';
import '../../styles/styles.dart';

class ConsultationItem extends ConsumerWidget {
  const ConsultationItem(this.consultation, {super.key});
  final ConsultationModel consultation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userId = ref.watch(userTypeProvider)!.toLowerCase() == 'user'
        ? ref.watch(userProvider).id
        : ref.watch(doctorProvider).id;
    var selectedUser = ref.watch(singleDoctorStreamProvider(
        userId == consultation.userId
            ? consultation.doctorId!
            : consultation.userId!));
    var consultationMessages =
        ref.watch(consultationMessagesStreamProvider(consultation.id!));
    return InkWell(
      onTap: () {
        if (consultation.status!.toLowerCase() != 'rejected') {
          if (consultation.status!.toLowerCase() == 'pending') {
            if (userId == consultation.doctorId) {
              CustomDialog.showCustom(
                  ui: Card(
                color: Colors.white,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Accept Consultation Request?'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(selectedConsultationProvider.notifier)
                                    .setSelectedConsultation(consultation);
                                ref
                                    .read(selectedConsultationProvider.notifier)
                                    .updateConsultationStatus(
                                        consultation.id!, 'Active');
                                CustomDialog.dismiss();
                                sendToPage(
                                    context, const ConsultationChatPage());
                              },
                              child: const Text('Accept')),
                          ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(selectedConsultationProvider.notifier)
                                    .updateConsultationStatus(
                                        consultation.id!, 'Rejected');
                                CustomDialog.dismiss();
                              },
                              child: const Text('Reject'))
                        ],
                      )
                    ],
                  ),
                ),
              ));
            } else {
              ref
                  .read(selectedConsultationProvider.notifier)
                  .setSelectedConsultation(consultation);
              sendToPage(context, const ConsultationChatPage());
            }
          } else {
            ref
                .read(selectedConsultationProvider.notifier)
                .setSelectedConsultation(consultation);
            sendToPage(context, const ConsultationChatPage());
          }
        } else {
          CustomDialog.showError(
              title: 'Consultation Rejected',
              message: 'This consultation has been rejected');
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8, right: 15),
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: primaryColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
                backgroundImage: userId == consultation.userId
                    ? consultation.doctorImage != null
                        ? NetworkImage(consultation.doctorImage!)
                        : null
                    : consultation.userImage != null
                        ? NetworkImage(consultation.userImage!)
                        : null),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    userId == consultation.userId
                        ? consultation.doctorName!
                        : consultation.userName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        normalText(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                selectedUser.when(data: (data) {
                  // ignore: unnecessary_null_comparison
                  if (data != null) {
                    String status = data.isOnline! ? 'Online' : 'Offline';
                    return Text(
                      status,
                      style: normalText(
                          color: status.toLowerCase() == 'online'
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12),
                    );
                  } else {
                    return const Text('');
                  }
                }, loading: () {
                  return const SizedBox(
                      width: 150, child: LinearProgressIndicator());
                }, error: (error, stackTrace) {
                  return const Text('');
                })
              ],
            ),
            trailing: LayoutBuilder(builder: (context, constraints) {
              return consultationMessages.when(data: (data) {
                // get data where is not read
                var unreadMessages = data
                    .where((element) =>
                        element.senderId != userId && element.isRead == false)
                    .toList();
                if (unreadMessages.isNotEmpty) {
                  return badges.Badge(
                    badgeContent: Text(
                      unreadMessages.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.comment,
                        size: 18,
                      ),
                    ),
                  );
                } else {
                  return const Text('');
                }
              }, error: (error, stackTrace) {
                return const Text('');
              }, loading: () {
                return const Text('');
              });
            }),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getNumberOfTime(consultation.createdAt!),
                      style: normalText(fontSize: 13, color: Colors.grey),
                    )
                  ],
                ),
                Text(
                  consultation.status!,
                  style: normalText(
                      color: consultation.status!.toLowerCase() == 'ended'
                          ? Colors.red
                          : consultation.status!.toLowerCase() == 'pending'
                              ? Colors.grey
                              : consultation.status!.toLowerCase() == 'rejected'
                                  ? Colors.red
                                  : primaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
