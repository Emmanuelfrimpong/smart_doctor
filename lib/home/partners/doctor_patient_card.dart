import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/functions.dart';
import 'package:smart_doctor/models/partners_model.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../state/data_state.dart';
import 'doctor_patient_open.dart';

class DoctorPatientCard extends ConsumerWidget {
  const DoctorPatientCard(this.data, {super.key});
  final PartnerModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userType = ref.watch(userTypeProvider);
    return InkWell(
      onTap: () {
        sendToPage(context, DoctorPatientOpenPage(data));
      },
      child: Container(
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 5, offset: Offset(0, 5))
            ]),
        child: LayoutBuilder(builder: (context, con) {
          String name = userType!.toLowerCase() == 'user'
              ? data.doctorName!
              : data.patientName!;
          String image = userType.toLowerCase() == 'user'
              ? data.doctorPhoto!
              : data.patientPhoto!;
          String spcialty =
              userType.toLowerCase() == 'user' ? data.doctorSpeciality! : '';
          String address = userType.toLowerCase() == 'user'
              ? data.doctorData!['address']
              : data.patientData!['address'];
          return Row(children: [
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: image != null && image.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(image),
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
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: primaryColor,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
                if (spcialty.isNotEmpty)
                  //specialty
                  Text(
                      spcialty.isEmpty
                          ? ''
                          : "(${data.doctorSpeciality ?? ""})",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(MdiIcons.mapMarker, color: Colors.black45, size: 18),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: normalText(color: Colors.black54, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      'Status:',
                      style: normalText(color: Colors.black45, fontSize: 14),
                    ),
                    const SizedBox(width: 5),
                    Text(data.status ?? "Status",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: data.status == 'Pending'
                                ? Colors.blue
                                : data.status == 'Accepted'
                                    ? Colors.green
                                    : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                Text(getDateFromDate(data.createdAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ],
            )),
          ]);
        }),
      ),
    );
  }
}
