import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/models/consultation_model.dart';
import 'package:smart_doctor/state/data_state.dart';

import '../../core/components/widgets/custom_input.dart';
import '../../core/components/widgets/smart_dialog.dart';
import '../../models/consultation_messages_model.dart';
import '../../services/firebase_fireStore.dart';
import '../../services/firebase_storage.dart';
import '../../state/doctor_data_state.dart';
import '../../state/user_data_state.dart';
import '../../styles/colors.dart';

class ImagePreviewPage extends ConsumerStatefulWidget {
  const ImagePreviewPage(this.imageUrls, this.consultation, {super.key});
  final File imageUrls;
  final ConsultationModel? consultation;

  @override
  ConsumerState<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends ConsumerState<ImagePreviewPage> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            //close button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.black))
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: FileImage(widget.imageUrls), fit: BoxFit.cover)),
            )),

            const SizedBox(height: 10),
            //add caption and send button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFields(
                      hintText: 'Type caption',
                      controller: _captionController,
                      onChanged: (value) {},
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                sendMessages();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: primaryColor,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )

            //send button
          ]),
        ),
      ),
    );
  }

  void sendMessages() async {
    //show loading
    CustomDialog.showLoading(
      message: 'Sending media files...',
    );

    String mediaUrls = await CloudStorageServices.sendFile(
        widget.imageUrls, widget.consultation!.id!);
    var consultation = widget.consultation!;

    //send message to firebase firestore
    dynamic user = ref.watch(userTypeProvider)!.toLowerCase() == 'user'
        ? ref.watch(userProvider)
        : ref.watch(doctorProvider);
    var uid = user.id;
    var receiverId = uid == consultation.userId
        ? consultation.doctorId
        : consultation.userId;
    var receiverName = uid == consultation.userId
        ? consultation.doctorName
        : consultation.userName;
    var receiverImage = uid == consultation.userId
        ? consultation.doctorImage
        : consultation.userImage;

    var senderName = uid == consultation.userId
        ? consultation.userName
        : consultation.doctorName;
    var senderImage = uid == consultation.userId
        ? consultation.userImage
        : consultation.doctorImage;
    ConsultationMessagesModel messagesModel = ConsultationMessagesModel();
    messagesModel.message = _captionController.text;
    messagesModel.type = 'image';
    messagesModel.senderId = uid;
    messagesModel.senderName = senderName;
    messagesModel.senderImage = senderImage;
    messagesModel.receiverId = receiverId;
    messagesModel.receiverName = receiverName;
    messagesModel.receiverImage = receiverImage;
    messagesModel.isRead = false;
    messagesModel.mediaFile = mediaUrls;
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
        _captionController.clear();
      });
      //close loading
      CustomDialog.dismiss();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
