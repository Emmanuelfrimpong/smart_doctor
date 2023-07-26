import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/diagnosis_data_state.dart';

class DiagnoseResponsePage extends ConsumerStatefulWidget {
  const DiagnoseResponsePage({super.key});

  @override
  ConsumerState<DiagnoseResponsePage> createState() =>
      _DiagnoseResponsePageState();
}

class _DiagnoseResponsePageState extends ConsumerState<DiagnoseResponsePage> {
  @override
  Widget build(BuildContext context) {
    var diagnosis = ref.watch(newDiagnosisProvider);
    return Column(
      children: [
        for (var response in diagnosis.responses!)
          Text(response.text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
