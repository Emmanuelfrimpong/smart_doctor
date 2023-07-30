import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/models/health_tips.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../../../services/firebase_fireStore.dart';

class TipsOfTheDayCard extends ConsumerWidget {
  const TipsOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<TipsModel>(
        future: FireStoreServices.getTips(),
        builder: (context, snapshot) {
          TipsModel tips =
              snapshot.hasData ? snapshot.data! : TipsModel(id: '');
          return Container(
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: secondaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Row(children: [
                  Icon(MdiIcons.lightbulbOnOutline, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Tips of the day',
                    style: normalText(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                      tips.doctor_name != null ? ' by ${tips.doctor_name}' : '',
                      style: normalText(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ))
                ]),
                subtitle: LayoutBuilder(builder: (context, constraints) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        )));
                  } else if (snapshot.hasError) {
                    return const SizedBox(
                        height: 50, child: Center(child: Text('Error')));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10, top: 15),
                      child: Text(
                        tips.health_tip!,
                        style: normalText(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                }),
              ));
        });
  }
}
