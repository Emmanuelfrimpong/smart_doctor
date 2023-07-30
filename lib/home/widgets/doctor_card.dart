import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import '../../core/functions.dart';
import '../../state/doctor_data_state.dart';
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
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: const EdgeInsets.all(5),
        width: size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryColor.withOpacity(.1),
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
                //specialty
                Text("(${user.specialty ?? "Specialty"})",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const Divider(),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(MdiIcons.email, color: primaryColor, size: 18),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(user.email ?? "Email",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(MdiIcons.phone, color: primaryColor, size: 18),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(user.phone ?? "Phone Number",
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(MdiIcons.mapMarker, color: primaryColor, size: 18),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(user.address ?? "Address",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                //hospital
                Row(
                  children: [
                    Icon(MdiIcons.hospital, color: primaryColor, size: 18),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(user.hospital ?? "Hospital",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 14)),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                //rating
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(user.rating!.toStringAsFixed(1),
                        style: const TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    for (var i = 0; i < user.rating!.toInt(); i++)
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
