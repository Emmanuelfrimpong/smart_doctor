import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_doctor/home/profile_pages/doctor_profile/view_page.dart';
import '../../../generated/assets.dart';
import '../../../state/navigation_state.dart';
import '../../../styles/colors.dart';
import 'edit_page.dart';

class DoctorProfilePage extends ConsumerStatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  ConsumerState<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends ConsumerState<DoctorProfilePage> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
        index: ref.watch(userProfileIndexProvider),
        children: const [
          DoctorProfileViewPage(),
          DoctorProfileEditPage(),
        ]);
  }
}
