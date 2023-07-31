import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/models/consultation_messages_model.dart';
import 'package:smart_doctor/models/consultation_model.dart';
import 'package:smart_doctor/state/data_state.dart';
import '../../core/components/widgets/custom_input.dart';
import '../../core/components/widgets/smart_dialog.dart';
import '../../core/functions.dart';
import '../../services/firebase_fireStore.dart';
import '../../state/consultation_data_state.dart';
import '../../state/doctor_data_state.dart';
import '../../state/user_data_state.dart';
import '../../styles/colors.dart';
import '../../styles/styles.dart';
import 'audio_Record_Page.dart';
import 'image_preview_page.dart';
import 'package:record/record.dart';

import 'message_item.dart';

class ConsultationChatPage extends ConsumerStatefulWidget {
  const ConsultationChatPage({super.key});

  @override
  ConsumerState<ConsultationChatPage> createState() =>
      _ConsultationChatPageState();
}

class _ConsultationChatPageState extends ConsumerState<ConsultationChatPage> {
  String message = '';
  final TextEditingController _controller = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final record = Record();
  //create timer
  Timer? timer;
  @override
  void initState() {
    //check if widget is build

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var uid = ref.watch(userTypeProvider)!.toLowerCase() == 'user'
        ? ref.watch(userProvider).id
        : ref.watch(doctorProvider).id;
    var consultation = ref.watch(selectedConsultationProvider);
    var selectedUser = ref.watch(singleDoctorStreamProvider(
        uid == consultation.userId
            ? consultation.doctorId!
            : consultation.userId!));
    var consultationMessages =
        ref.watch(consultationMessagesStreamProvider(consultation.id!));

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (consultation.status == 'Active')
            PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'End Consultation') {
                    showEndConsultationDialog(consultation);
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'End Consultation',
                      child: Text('End Consultation'),
                    ),
                    const PopupMenuItem(
                      value: 'Report Counsellor',
                      child: Text('Report Counsellor'),
                    ),
                  ];
                }),
          const SizedBox(width: 5)
        ],
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundImage: uid == consultation.userId
                        ? consultation.doctorImage != null
                            ? NetworkImage(consultation.doctorImage!)
                            : null
                        : consultation.userImage != null
                            ? NetworkImage(consultation.userImage!)
                            : null),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      uid == consultation.userId
                          ? consultation.doctorName!
                          : consultation.userName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          normalText(fontSize: 18, fontWeight: FontWeight.bold),
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
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          if (consultation.status != 'Pending')
            Expanded(
              child: consultationMessages.when(data: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }
                //get all chat messages where isRead is false and senderId is not equal to current user id and update isRead to true
                List<ConsultationMessagesModel> unreadMessages = [];
                consultationMessages.whenData((data) {
                  unreadMessages = data
                      .where((element) =>
                          element.isRead == false && element.senderId != uid)
                      .toList();
                });
                //update isRead to true
                updateMessage(unreadMessages, consultation.id!);
                return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var message = data[index];
                    return MessageItem(
                      message: message,
                    );
                  },
                );
              }, error: (error, stackTrace) {
                return Center(
                    child: Text(
                  'Something went wrong',
                  style: normalText(color: Colors.grey),
                ));
              }, loading: () {
                return const Center(
                    child: SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressIndicator()));
              }),
            ),
          if (consultation.status == 'Ended')
            Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Consultation has ended',
                style: normalText(
                    color: primaryColor, fontWeight: FontWeight.bold),
              ),
            )),
          if (consultation.status == 'Pending')
            Expanded(
              child: Center(
                  child: Text(
                'Consultation is pending acceptance',
                style:
                    normalText(color: Colors.red, fontWeight: FontWeight.bold),
              )),
            ),
          if (consultation.status == 'Active')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFields(
                      hintText: 'Type your message',
                      controller: _controller,
                      onChanged: (value) {
                        setState(() {
                          message = value;
                        });
                      },
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (message.isEmpty)
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  openSourceBottomSheet(context,
                                      consultation: consultation);
                                },
                                icon: const Icon(Icons.image,
                                    color: primaryColor, size: 25)),
                          if (message.isEmpty)
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  //show bottom sheet for recording
                                  sendToTransparentPage(
                                      context, const AudioRecordPage());
                                },
                                icon: Icon(MdiIcons.microphoneMessage,
                                    color: primaryColor, size: 25)),
                          if (message.isNotEmpty && sending == false)
                            IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  sendMessages(
                                      type: 'text', consultation: consultation);
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: primaryColor,
                                  size: 25,
                                )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  bool sending = false;
  void sendMessages(
      {String? type, required ConsultationModel consultation}) async {
    setState(() {
      sending = true;
    });
    var uid = ref.watch(userTypeProvider)!.toLowerCase() == 'user'
        ? ref.watch(userProvider).id
        : ref.watch(doctorProvider).id;
    var receiverId = uid == consultation.userId
        ? consultation.doctorId!
        : consultation.userId;
    var receiverName = uid == consultation.userId
        ? consultation.doctorName!
        : consultation.userName;
    var receiverImage = uid == consultation.userId
        ? consultation.doctorImage!
        : consultation.userImage!;

    var senderName = uid == consultation.userId
        ? consultation.userName!
        : consultation.doctorName!;
    var senderImage = uid == consultation.userId
        ? consultation.userImage!
        : consultation.doctorImage!;
    ConsultationMessagesModel messagesModel = ConsultationMessagesModel();
    messagesModel.message = message;
    messagesModel.type = type;
    messagesModel.senderId = uid;
    messagesModel.senderName = senderName;
    messagesModel.senderImage = senderImage;
    messagesModel.receiverId = receiverId;
    messagesModel.receiverName = receiverName;
    messagesModel.receiverImage = receiverImage;
    messagesModel.isRead = false;
    messagesModel.createdAt = DateTime.now().millisecondsSinceEpoch;
    messagesModel.id = FireStoreServices.getDocumentId('',
        collection: FirebaseFirestore.instance
            .collection('consultations')
            .doc(consultation.id)
            .collection('messages'));
    messagesModel.consultationId = consultation.id;
    var result = await FireStoreServices.addConsultationMessages(messagesModel);
    if (result) {
      setState(() {
        _controller.clear();
        message = '';
        sending = false;
      });
    }
  }

  void openSourceBottomSheet(BuildContext context,
      {required ConsultationModel consultation}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    openImagePicker(
                        consultation: consultation, source: 'camera');
                  },
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Camera'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    openImagePicker(
                        consultation: consultation, source: 'gallery');
                  },
                  leading: const Icon(Icons.image_outlined),
                  title: const Text('Gallery'),
                ),
              ],
            ),
          );
        });
  }

  void openImagePicker(
      {required ConsultationModel consultation, required String source}) async {
    XFile? media;
    if (source == 'camera') {
      media =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 90);
      if (media == null) return;
      //convert to file
      File file = File(media.path);
      if (mounted) {
        sendToTransparentPage(context, ImagePreviewPage(file, consultation));
      }
    } else {
      // Pick multiple images and videos.
      media =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
      if (media == null) return;
      //convert to file
      File file = File(media.path);
      if (mounted) {
        sendToTransparentPage(context, ImagePreviewPage(file, consultation));
      }
    }
  }

  void showEndConsultationDialog(ConsultationModel consultation) {
    CustomDialog.showInfo(
        title: 'End Consultation',
        message:
            'Are you sure you want to end this consultation? This action cannot be undone',
        onConfirmText: 'End',
        onConfirm: () {
          endConsultation(consultation);
        });
  }

  void endConsultation(ConsultationModel consultation) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Ending Consultation...');
    var result = await FireStoreServices.updateConsultationStatus(
        consultation.id!, 'Ended');
    if (result) {
      CustomDialog.dismiss();
      CustomDialog.showSuccess(title: 'Success', message: 'Consultation Ended');
      //pop page
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void updateMessage(
      List<ConsultationMessagesModel> unreadMessages, String id) async {
    if (unreadMessages.isNotEmpty) {
      for (var message in unreadMessages) {
        await FireStoreServices.updateConsultationMessageReadStatus(
            id, message.id!, true);
      }
    }
  }
}
