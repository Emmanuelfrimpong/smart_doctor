import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/models/doctor_model.dart';

import '../../core/functions.dart';
import '../../state/doctor_data_state.dart';
import 'doctor_open_page.dart';

class DoctorSmallCard extends ConsumerWidget {
  const DoctorSmallCard(this.doctor, {super.key});
  final DoctorModel doctor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          ref.read(selectedDoctorProvider.notifier).state = doctor;
          sendToTransparentPage(context, const DoctorViewPage());
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(5),
          width: size.width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  blurRadius: 5,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: NetworkImage(doctor.profile!),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(height: 5),
                Text(
                  doctor.name ?? '',
                  maxLines: 1,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  doctor.specialty ?? '',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ]),
        ));
  }
}
