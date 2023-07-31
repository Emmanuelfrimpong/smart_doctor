import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';
import '../../state/data_state.dart';
import '../../state/doctor_data_state.dart';
import '../../state/my_doctor_patient_data_state.dart';
import '../../state/user_data_state.dart';

class DoctorPatientPage extends ConsumerStatefulWidget {
  const DoctorPatientPage({super.key, this.isDoctor = false});
  final bool isDoctor;

  @override
  ConsumerState<DoctorPatientPage> createState() => _DoctorPatientPageState();
}

class _DoctorPatientPageState extends ConsumerState<DoctorPatientPage> {
  @override
  Widget build(BuildContext context) {
    var userType = ref.watch(userTypeProvider);
    var id = userType!.toLowerCase() == 'user'
        ? ref.watch(userProvider).id
        : ref.watch(doctorProvider).id;
    var doctorPatients = ref.watch(myDoctorPatientStreamProvider);
    return Scaffold(
      appBar: widget.isDoctor
          ? null
          : AppBar(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              title: Text(
                userType.toLowerCase() == 'user' ? 'My Doctors' : 'My Patients',
                style: normalText(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
      body: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
              color: primaryColor),
        ),
        Expanded(
          child: Transform.translate(
              offset: const Offset(0, -40),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: doctorPatients.when(data: (data) {
                  if (data.isEmpty) {
                    return Center(
                        child: Text(
                      'No ${userType.toLowerCase() == 'user' ? 'Doctors' : 'Patients'} added yet',
                      style: normalText(color: Colors.black),
                    ));
                  } else {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container();
                        });
                  }
                }, error: (e, s) {
                  return Center(
                      child: Text(
                    'Something went wrong',
                    style: normalText(color: Colors.black45),
                  ));
                }, loading: () {
                  return const Center(
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator()),
                  );
                }),
              )),
        )
      ]),
    );
  }
}
