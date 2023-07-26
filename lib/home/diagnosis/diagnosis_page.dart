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
        title: Text(
          'Quick Diagnosis',
          style: normalText(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (ref.watch(diagnosisIndexProvider) == 0)
            IconButton(
                onPressed: () {
                  ref.read(diagnosisIndexProvider.notifier).state = 1;
                },
                icon: Icon(MdiIcons.plusBox, color: primaryColor, size: 30)),
          if (ref.watch(diagnosisIndexProvider) != 0)
            IconButton(
                onPressed: () {
                  ref.read(diagnosisIndexProvider.notifier).state = 0;
                },
                icon: const Icon(Icons.history, color: primaryColor, size: 30)),
        ],
      ),
      body: IndexedStack(
          index: ref.watch(diagnosisIndexProvider),
          children: const [
            HistoryPage(),
            NewDiagnosisPage(),
            DiagnoseResponsePage()
          ]),
    );
  }
}
