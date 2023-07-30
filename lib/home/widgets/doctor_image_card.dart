import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/core/functions.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../state/doctor_data_state.dart';
import 'doctor_open_page.dart';

class DoctorImageCard extends ConsumerWidget {
  const DoctorImageCard({super.key, required this.doctor});
  final DoctorModel doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          ref.read(selectedDoctorProvider.notifier).state = doctor;
          sendToPage(context, const DoctorViewPage());
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          padding: const EdgeInsets.all(5),
          alignment: Alignment.bottomCenter,
          width: size.width * 0.95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(doctor.profile!),
              fit: BoxFit.fill,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(doctor.name ?? '',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      color: secondaryColor,
                      size: 16,
                    ),
                    Text(
                      doctor.rating!.toStringAsFixed(1),
                      style: normalText(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
