import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:smart_doctor/models/consultation_messages_model.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../models/audio_recording_model.dart';
import '../models/consultation_model.dart';
import '../services/firebase_fireStore.dart';
import '../services/firebase_storage.dart';

final userImageProvider = StateProvider<File?>((ref) => null);
final doctorImageProvider = StateProvider<File?>((ref) => null);
final idImageProvider = StateProvider<File?>((ref) => null);
final certificateProvider = StateProvider<File?>((ref) => null);
final userTypeProvider = StateProvider<String?>((ref) => null);

final audioRecordingTimerProvider =
    StateNotifierProvider<AudioRecordingTimer, AudioTimer>(
        (ref) => AudioRecordingTimer());

class AudioRecordingTimer extends StateNotifier<AudioTimer> {
  AudioRecordingTimer() : super(AudioTimer(minutes: 0, seconds: 0));
  void setTimer(AudioTimer timer) {
    state = timer;
  }

  void setMinutes(int value) {
    state = state.copyWith(minutes: value);
  }

  void setSeconds(int value) {
    state = state.copyWith(seconds: value);
  }
}

final audioRecordingProvider =
    StateNotifierProvider.autoDispose<AudioRecordingProvider, File?>((ref) {
  final record = Record();
  final player = AudioPlayer();
  ref.onDispose(() {
    record.dispose();
    player.dispose();
  });
  return AudioRecordingProvider(record, player);
});

class AudioRecordingProvider extends StateNotifier<File?> {
  AudioRecordingProvider(this.record, this.player) : super(null);
  final Record record;
  Timer? timer;
  final AudioPlayer player;

  void setAudioFile(File file) {
    state = file;
  }

  //start recording
  void startRecording(String id, WidgetRef ref) async {
    try {
      //get path from path provider
      final Directory root = await getApplicationDocumentsDirectory();
      final String directoryPath = '${root.path}/$id.wav';
      // Check and request permission
      if (await record.hasPermission()) {
        // Start recording
        await record.start(
          path: directoryPath,
          encoder: AudioEncoder.wav, // by default
          bitRate: 128000, // by default
          samplingRate: 44100, // by default
        );
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          var time = timer.tick;
          var minutes = time ~/ 60;
          var seconds = time % 60;
          ref
              .read(audioRecordingTimerProvider.notifier)
              .setTimer(AudioTimer(minutes: minutes, seconds: seconds));
        });
      }
    } catch (e) {}
  }

  // pause recording
  void pauseRecording() async {
    await record.pause();
    timer!.cancel();
  }

  //resume recording
  void resumeRecording(WidgetRef ref) async {
    await record.resume();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      var time = timer.tick;
      var minutes = time ~/ 60;
      var seconds = time % 60;
      ref
          .read(audioRecordingTimerProvider.notifier)
          .setTimer(AudioTimer(minutes: minutes, seconds: seconds));
    });
  }

  //stop recording
  void stopRecording(String id, WidgetRef ref) async {
    //get path from path provider
    final Directory root = await getApplicationDocumentsDirectory();
    final String directoryPath = '${root.path}/$id.wav';
    timer!.cancel();
    await record.stop();
    state = File(directoryPath);
    // //set timer to 0
    //set playing time to recording time
    ref
        .read(playingTimerProvider.notifier)
        .setTimer(ref.watch(audioRecordingTimerProvider));
    // ref
    //     .read(audioRecordingTimerProvider.notifier)
    //     .setTimer(AudioTimer(minutes: 0, seconds: 0));
  }

  void playRecording(WidgetRef ref) {
    player.setFilePath(state!.path);
    //ref.read(audioDurationProvider.notifier).state = player.duration!;
    player.play();
    ref.read(isPlayingProvider.notifier).state = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      var currentTimer = ref.watch(playingTimerProvider);
      ref.read(playingTimerProvider.notifier).setTimer(AudioTimer(
          minutes: currentTimer.minutes != 0 ? currentTimer.minutes - 1 : 0,
          seconds: currentTimer.seconds != 0 ? currentTimer.seconds - 1 : 0));
    });
    player.playerStateStream.listen((event) {
      //reduce time by 1 second using timer

      if (event.processingState == ProcessingState.completed) {
        player.stop();
        ref.read(isPlayingProvider.notifier).state = false;
        ref
            .read(playingTimerProvider.notifier)
            .setTimer(ref.watch(audioRecordingTimerProvider));
        //cancel timer
        timer!.cancel();
      }
    });
  }

  void pausePlaying(WidgetRef ref) {
    player.pause();
    ref.read(isPlayingProvider.notifier).state = false;
    // pause timer
    timer!.cancel();
  }

  void deleteRecording(WidgetRef ref) {
    state!.delete();
    state = null;
    ref.read(isPlayingProvider.notifier).state = false;
    ref
        .read(audioRecordingTimerProvider.notifier)
        .setTimer(AudioTimer(minutes: 0, seconds: 0));
  }

  void sendRecording(BuildContext context, ConsultationModel consultation,
      WidgetRef ref) async {
    //show loading
    CustomDialog.showLoading(message: 'Sending Audio... Please wait');
    //save file to cloud storage
    final String url =
        await CloudStorageServices.sendFile(state!, consultation.id!);
    //save file to firestore

    //send message to firebase firestore
    var uid = ref.watch(userProvider).id;
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
    messagesModel.type = 'audio';
    messagesModel.senderId = uid;
    messagesModel.senderName = senderName;
    messagesModel.senderImage = senderImage;
    messagesModel.receiverId = receiverId;
    messagesModel.receiverName = receiverName;
    messagesModel.receiverImage = receiverImage;
    messagesModel.isRead = false;
    messagesModel.mediaFile = url;
    messagesModel.createdAt = DateTime.now().millisecondsSinceEpoch;
    messagesModel.id = FireStoreServices.getDocumentId('',
        collection: FirebaseFirestore.instance
            .collection('consultations')
            .doc(consultation.id)
            .collection('messages'));
    messagesModel.consultationId = consultation.id;
    var result = await FireStoreServices.addConsultationMessages(messagesModel);
    if (result) {
      //delete file
      state!.delete();
      state = null;
      //clear timer
      ref
          .read(audioRecordingTimerProvider.notifier)
          .setTimer(AudioTimer(minutes: 0, seconds: 0));
      ref
          .read(playingTimerProvider.notifier)
          .setTimer(AudioTimer(minutes: 0, seconds: 0));
      //close loading

      CustomDialog.dismiss();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}

final isPlayingProvider = StateProvider<bool>((ref) => false);
final playingTimerProvider =
    StateNotifierProvider<AudioPlayingTimer, AudioTimer>(
        (ref) => AudioPlayingTimer());

class AudioPlayingTimer extends StateNotifier<AudioTimer> {
  AudioPlayingTimer() : super(AudioTimer(minutes: 0, seconds: 0));
  void setTimer(AudioTimer timer) {
    state = timer;
  }

  void setMinutes(int value) {
    state = state.copyWith(minutes: value);
  }

  void setSeconds(int value) {
    state = state.copyWith(seconds: value);
  }
}

final audioPlayerProvider =
    StateNotifierProvider.autoDispose<AudioPlayerProvider, bool>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() {
    player.dispose();
  });
  return AudioPlayerProvider(player);
});

class AudioPlayerProvider extends StateNotifier<bool> {
  final AudioPlayer player;
  AudioPlayerProvider(this.player) : super(false);
  void playAudio(String s, WidgetRef ref) async {
    player.setUrl(s);
    player.play();
    state = true;
    player.durationStream.listen((event) {
      ref.read(audioPlayerDurationProvider.notifier).state = event!;
    });
    // get duration  stream
    player.positionStream.listen((event) {
      ref.read(audioPlayerDurationProvider.notifier).state = event;
      var currAudioPlaying = event.inMicroseconds.ceilToDouble();
      final currTime = (currAudioPlaying /
          (player.duration?.inMicroseconds.ceilToDouble() ?? 1.0));
      ref.read(audioPlayerTimerProvider.notifier).state =
          currTime > 1.0 ? 1.0 : currTime;
    });
    player.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        player.stop();
        state = false;
        ref.read(audioPlayerTimerProvider.notifier).state = 0.0;
      }
    });
  }

  // pause audio
  void pauseAudio() {
    player.pause();
    state = false;
  }
}

final audioPlayerDurationProvider =
    StateProvider<Duration>((ref) => const Duration());
final audioPlayerTimerProvider = StateProvider<double>((ref) => 0.0);
