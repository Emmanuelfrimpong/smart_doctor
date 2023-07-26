import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../state/diagnosis_data_state.dart';
import '../../styles/colors.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);
    var diagnosis = ref.watch(diagnosisStreamProvider(user.id!));
    return Center(
      child: diagnosis.when(data: (data) {
        if (data.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No diagnosis history',
                style: normalText(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              TextButton(
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    ref.read(diagnosisIndexProvider.notifier).state = 1;
                  },
                  child: Text(
                    'Start a diagnosis',
                    style: normalText(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ))
            ],
          );
        } else {
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                //return expandable card
                return ExpansionTile(
                  title: Text(
                    'Date',
                  ),
                  children: [],
                );
              });
        }
      }, error: (error, stack) {
        return Center(
            child: Text(
          'Something went wrong',
          style: normalText(color: Colors.grey),
        ));
      }, loading: () {
        return const Center(
            child: SizedBox(
                height: 20, width: 20, child: CircularProgressIndicator()));
      }),
    );
  }
}
