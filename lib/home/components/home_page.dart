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
import '../../state/data_state.dart';
import '../../state/doctors_data_state.dart';
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
    var size = MediaQuery.of(context).size;
    var doctorsList = ref.watch(doctorsStreamProvider);
    List<DoctorModel> sortedList = [];
    doctorsList.whenData((value) {
      sortedList = sortUsersByRating(value);
    });

    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomTextFields(
            hintText: 'Search for a counsellor',
            focusNode: _focus,
            controller: _controller,
            suffixIcon: _focus.hasFocus
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                        _focus.unfocus();
                      });
                    },
                    icon: Icon(MdiIcons.close, color: primaryColor))
                : Icon(MdiIcons.magnify, color: primaryColor),
            onChanged: (p0) =>
                ref.read(searchQueryProvider.notifier).state = p0,
          ),
        ),
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
                onTap: () {},
              ),
              HomeCard(
                color: secondaryColor,
                title: 'Quick Diagnosis',
                subtitle:
                    'Get a quick diagnosis for your symptoms from an advanced AI',
                image: Assets.imagesDiagnose,
                onTap: () {},
              ),
            ],
          ),
        if (!_focus.hasFocus) const SizedBox(height: 20),
        ListTile(
          title: Row(
            children: [
              Text('Rated Doctors',
                  style: normalText(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              const Icon(Icons.star, color: primaryColor, size: 25),
              const Icon(Icons.star, color: primaryColor, size: 25),
              const Icon(Icons.star, color: primaryColor, size: 25),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: normalText(
                      color: primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          subtitle: SizedBox(
            height: 215,
            child: sortedList.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return DoctorCard(user: sortedList[index]);
                    },
                    itemCount: sortedList.length)
                : Center(
                    child: Text(
                      'No Counsellor Found',
                      style: normalText(),
                    ),
                  ),
          ),
        ),
        if (!_focus.hasFocus) const SizedBox(height: 5),
        const TipsOfTheDayCard(),
      ])),
    );
  }
}