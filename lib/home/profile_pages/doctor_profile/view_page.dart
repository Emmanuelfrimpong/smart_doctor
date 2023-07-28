import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_doctor/authentication/user_options.dart';
import 'package:smart_doctor/models/doctor_model.dart';
import 'package:smart_doctor/state/doctor_data_state.dart';
import '../../../core/functions.dart';
import '../../../services/firebase_auth.dart';
import '../../../services/firebase_fireStore.dart';
import '../../../styles/colors.dart';
import '../../../styles/styles.dart';


class DoctorProfileViewPage extends ConsumerStatefulWidget {
  const DoctorProfileViewPage({super.key});

  @override
  ConsumerState<DoctorProfileViewPage> createState() => _DoctorProfileViewPageState();
}

class _DoctorProfileViewPageState extends ConsumerState<DoctorProfileViewPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(doctorProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          const SizedBox(height: 20),
          //circle avatar image
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.profile!),
          ),
          const SizedBox(height: 15),
          //edit and logout buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    ref.read(userProfileIndexProvider.notifier).state = 1;
                  },
                  child: const Text('Edit Profile')),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    signOut(user);
                  },
                  child: const Text('Logout'))
            ],
          ),
          const SizedBox(height: 20),
          //user name, email and phone number
          Text(user.name ?? '',
              style: normalText(fontSize: 20, fontWeight: FontWeight.bold)),

          //show user type
          Text('(${user.specialty})',
              style:
                  normalText(fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 5),
          Text(user.email ?? '',
              style: normalText(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 5),
          Text(user.phone ?? '',
              style: normalText(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 20),
          //show date of birth, address, city

          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Address: ',
                  style: normalText(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              Text(user.address ?? '',
                  style: normalText(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Rating: ',
                    style: normalText(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                Text(user.rating.toString(),
                    style: normalText(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                for (var i = 0; i < user.rating!.toInt(); i++)
                  const Icon(Icons.star, color: primaryColor, size: 16),
              ],
            ),
          //user bio
          Text(user.about ?? '',
              maxLines: 5,
              style: normalText(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ]),
      ),
    );
  }

  void signOut(DoctorModel user) async {
    await FireStoreServices.updateUserOnlineStatus(user.id!, false);
    await FirebaseAuthService.signOut();
    if (mounted) {
      noReturnSendToPage(context, const UserAuthOptions());
    }
  }
}