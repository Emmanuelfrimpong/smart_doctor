import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import 'package:smart_doctor/state/doctors_data_state.dart';
import '../../core/functions.dart';
import '../../state/data_state.dart';
import '../../styles/colors.dart';
import 'doctor_open_page.dart';

class DoctorCard extends ConsumerWidget {
  const DoctorCard({super.key, required this.user});
  final DoctorModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        ref.read(selectedDoctorProvider.notifier).state = user;
        sendToTransparentPage(context, const DoctorViewPage());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        padding: const EdgeInsets.all(10),
        width: size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: user.profile != null
                    ? DecorationImage(
                        image: NetworkImage(user.profile!),
                        fit: BoxFit.fill,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name ?? "Name",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(user.email ?? "Email",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 14)),
                const SizedBox(height: 2),
                Text(user.phone ?? "Phone Number",
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 14)),
                const SizedBox(height: 2),
                Text(user.address ?? "Address",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 14)),
                const SizedBox(height: 10),
                //rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(user.rating.toString(),
                        style: const TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    for (var i = 0; i < 5; i++)
                      const Icon(Icons.star, color: primaryColor, size: 16),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
