import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/home/widgets/doctor_card.dart';
import 'package:smart_doctor/styles/colors.dart';
import '../../../core/components/widgets/custom_input.dart';
import '../../../state/doctor_data_state.dart';
import '../../../styles/styles.dart';

class DoctorsListPage extends ConsumerStatefulWidget {
  const DoctorsListPage({super.key});

  @override
  ConsumerState<DoctorsListPage> createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends ConsumerState<DoctorsListPage> {
  @override
  void initState() {
    // check is widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(doctorSearchQueryProvider.notifier).state = '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var doctorsList = ref.watch(doctorsStreamProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text('Doctors List',
            style: normalText(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      ),
      body: Container(
        color: primaryColor.withOpacity(0.1),
        child: doctorsList.when(data: (data) {
          var filterdData = ref.watch(doctorSearchAllQueryList(data));
          return Column(
            children: [
              SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40)),
                            color: primaryColor),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Card(
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: CustomTextFields(
                              hintText: 'Search doctors',
                              suffixIcon:
                                  Icon(MdiIcons.magnify, color: primaryColor),
                              onChanged: (value) {
                                ref
                                    .read(doctorSearchQueryProvider.notifier)
                                    .state = value;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                      itemCount: filterdData.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return DoctorCard(user: filterdData[index]);
                      }),
                ),
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
