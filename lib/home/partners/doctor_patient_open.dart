import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import 'package:smart_doctor/models/partners_model.dart';
import 'package:smart_doctor/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/components/widgets/smart_dialog.dart';
import '../../core/functions.dart';
import '../../state/data_state.dart';
import '../../styles/colors.dart';
import '../../styles/styles.dart';

class DoctorPatientOpenPage extends ConsumerStatefulWidget {
  const DoctorPatientOpenPage(this.data, {super.key});
  final PartnerModel data;

  @override
  ConsumerState<DoctorPatientOpenPage> createState() =>
      _DoctorPatientOpenPageState();
}

class _DoctorPatientOpenPageState extends ConsumerState<DoctorPatientOpenPage> {
  @override
  Widget build(BuildContext context) {
    var userType = ref.watch(userTypeProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          userType!.toLowerCase() == 'user' ? 'My Doctor' : 'My Patient',
          style: normalText(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
              color: primaryColor),
        ),
        Expanded(
            child: Transform.translate(
          offset: const Offset(0, -30),
          child: Card(
            elevation: 5,
            color: Colors.white,
            margin: const EdgeInsets.all(10),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: userType.toLowerCase() == 'user'
                    ? _buildDoctor()
                    : _buildPatient()),
          ),
        ))
      ]),
    );
  }

  Widget _buildPatient() {
    var map = widget.data.doctorData;
    UserModel user = UserModel.fromMap(map!);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // doctor Online status
            Text(
              user.isOnline! ? 'Online' : 'Offline',
              style: normalText(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: user.isOnline! ? Colors.green : Colors.red),
            ),

            Transform.translate(
              offset: const Offset(0, -50),
              child: user.profile != null
                  ? InkWell(
                      onTap: () {
                        CustomDialog.showImageDialog(
                          path: user.profile!,
                        );
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.profile!),
                      ),
                    )
                  : const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person,
                          color: primaryColor,
                          size: 45,
                        ),
                      ),
                    ),
            ),
            // doctor rating
            Container()
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  user.name!,
                  style: normalText(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),
                //doctor address
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(user.address ?? '',
                        style: normalText(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54)),
                  ],
                ),

                const SizedBox(height: 25),
                //appointment button, consultation button and add to my doctors button
                if (widget.data.status != 'Pending' &&
                    widget.data.status != 'Accepted')
                  Text(
                    'You no longer have access to this doctor. You or doctor has cancelled the partnership.',
                    style: normalText(color: Colors.red),
                  ),
                if (widget.data.status == 'Pending')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // accept and reject button
                      ElevatedButton.icon(
                        onPressed: () {
                          //Todo accept request
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Accept',
                          style: normalText(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          //Todo reject request
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Reject',
                          style: normalText(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  ),
                if (widget.data.status == 'Accepted')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //call button
                      ElevatedButton.icon(
                        onPressed: () {
                          launchURL('tel:${user.phone}');
                        },
                        icon: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Call',
                          style: normalText(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      //chat button
                      ElevatedButton.icon(
                        onPressed: () {
                          getConsultationAndOpenChat();
                        },
                        icon: const Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Chat',
                          style: normalText(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  ),
                const SizedBox(height: 15),
                if (widget.data.status == 'Accepted')
                  ElevatedButton.icon(
                      onPressed: () {
                        //Todo remove user from my patient page
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Remove Patient',
                        style: normalText(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 15),
                // user madical records
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Height',
                      style: normalText(color: Colors.grey),
                    ),
                    Text(
                      user.height != null
                          ? '${user.height ?? user.height!.toStringAsFixed(2)}'
                          : '',
                      style: normalText(color: Colors.black),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Weight',
                      style: normalText(color: Colors.grey),
                    ),
                    Text(
                      user.weight != null
                          ? '${user.weight!.toStringAsFixed(2)} kg'
                          : '',
                      style: normalText(color: Colors.black),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Blood Group',
                      style: normalText(color: Colors.grey),
                    ),
                    Text(
                      user.bloodType ?? '',
                      style: normalText(color: Colors.black),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Medical History',
                      style: normalText(color: Colors.grey),
                    ),
                    Text(
                      user.medicalHistory ?? '',
                      style: normalText(color: Colors.black),
                    ),
                  ],
                ),

                //doctor bio
                ListTile(
                    title: Text('About',
                        style: normalText(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    subtitle: Text(
                      user.about ?? '',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: normalText(fontSize: 13, color: Colors.black45),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctor() {
    var map = widget.data.doctorData;
    DoctorModel doctor = DoctorModel.fromMap(map!);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // doctor Online status
            Text(
              doctor.isOnline! ? 'Online' : 'Offline',
              style: normalText(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: doctor.isOnline! ? Colors.green : Colors.red),
            ),

            Transform.translate(
              offset: const Offset(0, -50),
              child: doctor.profile != null
                  ? InkWell(
                      onTap: () {
                        CustomDialog.showImageDialog(
                          path: doctor.profile!,
                        );
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(doctor.profile!),
                      ),
                    )
                  : const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person,
                          color: primaryColor,
                          size: 45,
                        ),
                      ),
                    ),
            ),
            // doctor rating
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: secondaryColor,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  doctor.rating!.toStringAsFixed(1),
                  style: normalText(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: primaryColor),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  doctor.name!,
                  style: normalText(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  '(${doctor.specialty!})',
                  style: normalText(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black45),
                ),
                const SizedBox(height: 15),
                ListTile(
                  title: Text('10yrs Experience',
                      style: normalText(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  subtitle: doctor.images != null && doctor.images!.isNotEmpty
                      ? SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () {
                                    CustomDialog.showImageDialog(
                                      path: doctor.images![index],
                                    );
                                  },
                                  child: Image.network(
                                    doctor.images![index],
                                    width: 100,
                                    height: 90,
                                  ),
                                ),
                              );
                            },
                            itemCount: doctor.images!.length,
                            shrinkWrap: true,
                          ),
                        )
                      : const SizedBox(
                          height: 100,
                          child: Center(
                            child: Text('No images uploaded'),
                          ),
                        ),
                ),
                //doctor address
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(doctor.address ?? '',
                        style: normalText(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 10),
                //hospital name
                Row(
                  children: [
                    const Icon(
                      Icons.local_hospital,
                      color: primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(doctor.hospital ?? '',
                        style: normalText(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 25),
                //appointment button, consultation button and add to my doctors button
                if (widget.data.status != 'Pending' &&
                    widget.data.status != 'Accepted')
                  Text(
                    'You no longer have access to this doctor. You or doctor has cancelled the partnership.',
                    style: normalText(color: Colors.red),
                  ),
                if (widget.data.status == 'Pending')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Doctor have not accepted your request yet. Wait until doctor accept',
                      style: normalText(color: Colors.blue),
                    ),
                  ),
                if (widget.data.status == 'Accepted')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //call button
                      ElevatedButton.icon(
                        onPressed: () {
                          launchURL('tel:${doctor.phone}');
                        },
                        icon: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Call',
                          style: normalText(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      //chat button
                      ElevatedButton.icon(
                        onPressed: () {
                          getConsultationAndOpenChat();
                        },
                        icon: const Icon(
                          Icons.chat,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Chat',
                          style: normalText(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                    onPressed: () {
                      //Todo remove doctor from my doctors page
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Remove Doctor',
                      style: normalText(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 15),
                //doctor bio
                ListTile(
                    title: Text('About',
                        style: normalText(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    subtitle: Text(
                      doctor.about ?? '',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: normalText(fontSize: 13, color: Colors.black45),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  void getConsultationAndOpenChat() {}
}
