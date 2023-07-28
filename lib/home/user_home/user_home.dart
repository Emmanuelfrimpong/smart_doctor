import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/home/widgets/doctor_card.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';
import '../../../generated/assets.dart';
import '../../core/components/widgets/custom_input.dart';
import '../../core/functions.dart';
import '../../models/doctor_model.dart';
import '../../state/doctor_data_state.dart';
import '../components/doctors_list/doctors_list_page.dart';
import '../consultation/quick_consultation_page.dart';
import '../diagnosis/diagnosis_page.dart';
import '../widgets/home_cards.dart';
import '../widgets/tips_of_day.dart';

class UserHome extends ConsumerStatefulWidget {
  const UserHome({super.key});

  @override
  ConsumerState<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends ConsumerState<UserHome> {
  final FocusNode _focus = FocusNode();

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var doctorsList = ref.watch(doctorsStreamProvider);
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: CustomTextFields(
          hintText: 'Search for a doctor',
          focusNode: _focus,
          controller: _controller,
          color: Colors.white,
          suffixIcon: _focus.hasFocus
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      ref.read(doctorSearchQueryProvider.notifier).state = '';
                      _focus.unfocus();
                    });
                  },
                  icon: Icon(MdiIcons.close, color: Colors.white))
              : Icon(MdiIcons.magnify, color: Colors.white),
          onChanged: (p0) =>
              ref.read(doctorSearchQueryProvider.notifier).state = p0,
        ),
        subtitle: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
              const SizedBox(height: 20),
              if (!_focus.hasFocus)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeCard(
                      color: secondaryColor,
                      title: 'Consultation',
                      subtitle:
                          'Quickly consult with a doctor through chat, call or video call',
                      image: Assets.imagesConsultation,
                      onTap: () {
                        sendToPage(context, const QuickConsultationPage());
                      },
                    ),
                    HomeCard(
                      color: secondaryColor,
                      title: 'Quick Diagnosis',
                      subtitle:
                          'Get a quick diagnosis for your symptoms from an advanced AI',
                      image: Assets.imagesDiagnose,
                      onTap: () {
                        sendToPage(context, const QuickDiagnosisPage());
                      },
                    ),
                  ],
                ),
              if (!_focus.hasFocus) const SizedBox(height: 20),
              if (_focus.hasFocus)
                LayoutBuilder(builder: (context, constraints) {
                  return doctorsList.when(error: (e, s) {
                    return Center(
                        child: Text(
                      'Something went wrong',
                      style: normalText(color: Colors.grey),
                    ));
                  }, loading: () {
                    return const Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator()));
                  }, data: (data) {
                    var filteredList = ref.watch(doctorSearchQueryList(data));

                    return filteredList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return DoctorCard(user: filteredList[index]);
                            },
                            itemCount: filteredList.length)
                        : Center(
                            child: Text(
                              'No Doctors Found',
                              style: normalText(),
                            ),
                          );
                  });
                }),
              if (!_focus.hasFocus)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Text('Rated Doctors',
                          style: normalText(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      const Icon(Icons.star, color: secondaryColor, size: 25),
                      const Icon(Icons.star, color: secondaryColor, size: 25),
                      const Icon(Icons.star, color: secondaryColor, size: 25),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          sendToPage(context, const DoctorsListPage());
                        },
                        child: Text(
                          'View All',
                          style: normalText(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  //sliding doctors list

                  subtitle: SizedBox(
                    height: 215,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return doctorsList.when(error: (e, s) {
                        return Center(
                            child: Text(
                          'Something went wrong',
                          style: normalText(color: Colors.grey),
                        ));
                      }, loading: () {
                        return const Center(
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator()));
                      }, data: (data) {
                        List<DoctorModel> sortedList = sortUsersByRating(data);

                        return sortedList.isNotEmpty
                            ? CarouselSlider(
                                options: CarouselOptions(height: 200),
                                items: sortedList.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return DoctorCard(user: i);
                                    },
                                  );
                                }).toList(),
                              )
                            : Center(
                                child: Text(
                                  'No Doctors Found',
                                  style: normalText(),
                                ),
                              );
                      });
                    }),
                  ),
                ),
              if (!_focus.hasFocus) const SizedBox(height: 5),
              if (!_focus.hasFocus) const TipsOfTheDayCard(),
            ])),
      ),
    );
  }
}
