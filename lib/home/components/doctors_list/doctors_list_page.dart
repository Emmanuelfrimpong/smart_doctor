import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/home/widgets/doctor_card.dart';
import 'package:smart_doctor/state/doctors_data_state.dart';
import 'package:smart_doctor/styles/colors.dart';

import '../../../core/components/widgets/custom_input.dart';
import '../../../styles/styles.dart';

class DoctorsListPage extends ConsumerStatefulWidget {
  const DoctorsListPage({super.key});

  @override
  ConsumerState<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends ConsumerState<DoctorsListPage> {
  @override
  Widget build(BuildContext context) {
    var doctorsList = ref.watch(doctorsStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors List',
            style: normalText(fontSize: 22, fontWeight: FontWeight.w700)),
      ),
      body: Container(
        color: primaryColor.withOpacity(0.1),
        child: doctorsList.when(data: (data) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFields(
                  hintText: 'Search doctors',
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return DoctorCard(user: data[index]);
                    }),
              ),
            ],
          );
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
      ),
    );
  }
}
