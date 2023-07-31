import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/home/diagnosis/responds_page.dart';
import 'package:smart_doctor/state/diagnosis_data_state.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import 'history_page.dart';
import 'new_diagnosis.dart';

class QuickDiagnosisPage extends ConsumerStatefulWidget {
  const QuickDiagnosisPage({super.key});

  @override
  ConsumerState<QuickDiagnosisPage> createState() => _QuickDiagnosisPageState();
}

class _QuickDiagnosisPageState extends ConsumerState<QuickDiagnosisPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(
            MdiIcons.arrowLeft,
            color: Colors.white,
          ),
          onPressed: () {
            if (ref.watch(diagnosisIndexProvider) == 0) {
              Navigator.pop(context);
            } else {
              ref.read(diagnosisIndexProvider.notifier).state =
                  ref.watch(diagnosisIndexProvider) - 1;
            }
          },
        ),
        title: Text('Quick Diagnosis',
            style: normalText(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        actions: [
          if (ref.watch(diagnosisIndexProvider) == 0)
            IconButton(
                onPressed: () {
                  ref.read(diagnosisIndexProvider.notifier).state = 1;
                },
                icon: Icon(MdiIcons.plusBox, color: Colors.white, size: 30)),
          if (ref.watch(diagnosisIndexProvider) != 0)
            IconButton(
                onPressed: () {
                  ref.read(diagnosisIndexProvider.notifier).state = 0;
                },
                icon: const Icon(Icons.history, color: Colors.white, size: 30)),
          if (ref.watch(diagnosisIndexProvider) == 2)
            IconButton(
                onPressed: () {
                  ref.read(diagnosisIndexProvider.notifier).state = 1;
                },
                icon: Icon(MdiIcons.plusBox, color: Colors.white, size: 30)),
        ],
      ),
      body: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)),
                  color: primaryColor),
              child: Text(
                'Find what is wrong with you',
                style: normalText(fontSize: 14, color: Colors.white),
              )),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: IndexedStack(
                    index: ref.watch(diagnosisIndexProvider),
                    children: const [
                      HistoryPage(),
                      NewDiagnosisPage(),
                      DiagnoseResponsePage()
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
