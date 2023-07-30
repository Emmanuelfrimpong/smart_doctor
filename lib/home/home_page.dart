import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/core/functions.dart';
import 'package:smart_doctor/home/profile_pages/profile_main_page.dart';
import 'package:smart_doctor/models/user_model.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';
import '../authentication/login/login_main_page.dart';
import '../core/components/widgets/smart_dialog.dart';
import '../models/doctor_model.dart';
import '../services/firebase_auth.dart';
import '../services/firebase_fireStore.dart';
import '../state/data_state.dart';
import '../state/doctor_data_state.dart';
import '../state/navigation_state.dart';
import '../state/user_data_state.dart';
import 'components/appointment/appointment_page.dart';
import 'components/my_patients_page/my_patients_page.dart';
import 'consultation/consultation_page.dart';
import 'user_home/user_home.dart';

class HomeMainPage extends ConsumerStatefulWidget {
  const HomeMainPage({super.key});

  @override
  ConsumerState<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends ConsumerState<HomeMainPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    dynamic user;
    var userType = ref.watch(userTypeProvider);

    if (userType!.toLowerCase() == 'user') {
      user = ref.watch(userProvider);
    } else {
      user = ref.watch(doctorProvider);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
          index: _currentIndex,
          alignment: Alignment.center,
          children: [
            if (userType.toLowerCase() == 'user') const UserHome(),
            const AppointmentPage(),
            const ConsultationPage(),
            if (userType.toLowerCase() == 'doctor') const MyPatientsPage(),
            const ProfileMainPage(),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.white,
        backgroundColor: primaryColor,
        selectedFontSize: 18,
        unselectedFontSize: 14,
        elevation: 2,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        items: [
          if (userType.toLowerCase() == 'user')
            BottomNavigationBarItem(icon: Icon(MdiIcons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.calendarMonth), label: 'Appoint.'),
          BottomNavigationBarItem(icon: Icon(MdiIcons.chat), label: 'Consult.'),
          //add my patients page for doctor
          if (userType.toLowerCase() == 'doctor')
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.accountGroup), label: 'My Patients'),

          BottomNavigationBarItem(
              icon: Icon(MdiIcons.accountCircle), label: 'Profile'),
        ],
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
          PopupMenuButton(
              onSelected: (value) {
                takeAction(value, user, userType);
              },
              child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: user.profile != null
                          ? DecorationImage(
                              image: NetworkImage(user.profile!),
                              fit: BoxFit.cover)
                          : null),
                  child: Center(
                    child: user.profile == null
                        ? Icon(
                            MdiIcons.account,
                            color: primaryColor,
                            size: 20,
                          )
                        : null,
                  )),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'out',
                    child: Row(children: [
                      Icon(MdiIcons.logout, color: primaryColor),
                      const Text('Sign Out'),
                    ]),
                  ),
                ];
              }),
          const SizedBox(width: 10)
        ],
        title: Row(
          children: [
            Image.asset(
              'assets/logo/icon.png',
              height: 50,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Doctor',
                    style: normalText(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Doctor on your phone',
                    style: normalText(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void takeAction(String value, dynamic user, String userType) async {
    if (value == 'out') {
      CustomDialog.showInfo(
        title: 'Sign Out',
        message: 'Are you sure you want to sign out ?',
        onConfirmText: 'Yes',
        onConfirm: () {
          signOut(userType, user);
        },
      );
    }
  }

  void signOut(String userType, dynamic user) async {
    CustomDialog.dismiss();
    CustomDialog.showLoading(message: 'Signing out... Please wait');
    //update user online status
    if (userType.toLowerCase() == 'user') {
      await FireStoreServices.updateUserOnlineStatus(user.id, false);
      ref.read(userProvider.notifier).setUser(UserModel());
    } else {
      FireStoreServices.updateDoctorOnlineStatus(user.id, false);
      ref.read(doctorProvider.notifier).setDoctor(DoctorModel());
    }
    await FirebaseAuthService.signOut();
    CustomDialog.dismiss();
    if (mounted) {
      ref.read(authIndexProvider.notifier).state = 0;
      noReturnSendToPage(context, const LoginMainPage());
    }
  }
}
