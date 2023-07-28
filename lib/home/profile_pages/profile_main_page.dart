import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/home/profile_pages/doctor_profile/doctor_profile_page.dart';
import 'package:smart_doctor/home/profile_pages/user_profile.dart';

import '../../state/data_state.dart';

class ProfileMainPage extends ConsumerWidget {
  const ProfileMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userType = ref.watch(userTypeProvider);
    if (userType!.toLowerCase() == 'user') {
      return const UserProfilePage();
    } else {
      return const DoctorProfilePage();
    }
  }
}
