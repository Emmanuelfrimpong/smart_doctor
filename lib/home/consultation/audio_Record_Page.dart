// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/styles.dart';
import '../../state/consultation_data_state.dart';
import '../../state/data_state.dart';

class AudioRecordPage extends ConsumerStatefulWidget {
  const AudioRecordPage({super.key});

  @override
  ConsumerState<AudioRecordPage> createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends ConsumerState<AudioRecordPage> {
  onDispose() {
    ref.read(audioRecordingProvider.notifier).dispose();
  }

  @override
  Widget build(BuildContext context) {
    var timer = ref.watch(audioRecordingTimerProvider);
    var file = ref.watch(audioRecordingProvider);
    var session = ref.watch(selectedConsultationProvider);

    bool isPlaying = ref.watch(isPlayingProvider);
    var playingTimer = ref.watch(playingTimerProvider);
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          color: Colors.white,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
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
            RippleAnimation(
              color: primaryColor,
              delay: const Duration(milliseconds: 300),
              repeat: true,
              minRadius: 30,
              ripplesCount: 6,
              duration: const Duration(milliseconds: 6 * 300),
              child: CircleAvatar(
                minRadius: 25,
                maxRadius: 25,
                child: Icon(file == null ? Icons.mic : MdiIcons.speaker,
                    size: 30, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            //show timer
            if (file != null)
              Text(
                '${playingTimer.minutes.toString().padLeft(2, '0')}:${playingTimer.seconds.toString().padLeft(2, '0')}',
                style: normalText(fontSize: 18),
              ),
            if (file == null)
              Text(
                '${timer.minutes.toString().padLeft(2, '0')}:${timer.seconds.toString().padLeft(2, '0')}',
                style: normalText(fontSize: 18),
              ),
            //show pause, stop and play button, change stop button to send button when recording is stopped and hide pause button
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (timer.minutes == 0 && timer.seconds == 0 && file == null)
                  InkWell(
                    onTap: () {
                      ref
                          .read(audioRecordingProvider.notifier)
                          .startRecording(session.id!, ref);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: Icon(MdiIcons.microphone,
                          color: primaryColor, size: 30),
                    ),
                  ),
                if (timer.minutes > 0 || timer.seconds > 0 && file == null)
                  InkWell(
                    onTap: () {
                      ref
                          .read(audioRecordingProvider.notifier)
                          .stopRecording(session.id!, ref);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child:
                          const Icon(Icons.stop, color: primaryColor, size: 30),
                    ),
                  ),
                if (timer.minutes > 0 || timer.seconds > 0 && file == null)
                  const SizedBox(
                    width: 10,
                  ),
                if (timer.minutes > 0 || timer.seconds > 0 && file == null)
                  InkWell(
                    onTap: () {
                      ref
                          .read(audioRecordingProvider.notifier)
                          .pauseRecording();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: const Icon(Icons.pause,
                          color: primaryColor, size: 30),
                    ),
                  ),
                if (file != null)
                  //delete button
                  InkWell(
                    onTap: () {
                      ref
                          .read(audioRecordingProvider.notifier)
                          .deleteRecording(ref);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: const Icon(Icons.delete,
                          color: primaryColor, size: 30),
                    ),
                  ),
                if (file != null)
                  const SizedBox(
                    width: 10,
                  ),
                if (file != null)
                  //show play button
                  InkWell(
                    onTap: () {
                      if (isPlaying) {
                        ref
                            .read(audioRecordingProvider.notifier)
                            .pausePlaying(ref);
                      } else {
                        ref
                            .read(audioRecordingProvider.notifier)
                            .playRecording(ref);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                          color: primaryColor, size: 30),
                    ),
                  ),
                if (file != null)
                  const SizedBox(
                    width: 30,
                  ),
                if (file != null)
                  //send button
                  InkWell(
                    onTap: () {
                      ref
                          .read(audioRecordingProvider.notifier)
                          .sendRecording(context, session, ref);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: secondaryColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Text('Send',
                              style: normalText(
                                  fontSize: 18,
                                  color: secondaryColor,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.send,
                              color: secondaryColor, size: 25),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ]),
        ),
      ),
    );
  }
}
