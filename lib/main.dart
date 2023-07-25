import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:smart_doctor/services/firebase_auth.dart';
import 'package:smart_doctor/services/firebase_fireStore.dart';
import 'package:smart_doctor/state/data_state.dart';
import 'package:smart_doctor/state/doctor_data_state.dart';
import 'package:smart_doctor/state/user_data_state.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'authentication/login/login_main_page.dart';
import 'core/components/widgets/smart_dialog.dart';
import 'firebase_options.dart';
import 'home/home_page.dart';
import 'models/doctor_model.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<bool> _initUser() async {
    // final doctors = DummyDoctors.doctorsList();
    // for (var doctor in doctors) {
    //   doctor.id = FireStoreServices.getDocumentId('doctors');
    //   doctor.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    //   await FireStoreServices.saveDoctor(doctor);
    // }
    // await FirebaseAuthService.signOut();
    if (FirebaseAuthService.isUserLogin()) {
      User user = FirebaseAuthService.getCurrentUser();
      String? userType = user.displayName;
      //check if widget is build

      //update user online status

      if (userType!.toLowerCase() == 'doctor') {
        DoctorModel? doctorModel = await FireStoreServices.getDoctor(user.uid);
        //update doctor online status
        await FireStoreServices.updateDoctorOnlineStatus(user.uid, true);
        if (doctorModel != null) {
          ref.read(doctorProvider.notifier).setDoctor(doctorModel);
        } else {
          CustomDialog.showError(
              title: 'Data Error',
              message: 'Unable to get Doctor info, try again later');
        }
      } else {
        UserModel? userModel = await FireStoreServices.getUser(user.uid);
        await FireStoreServices.updateUserOnlineStatus(user.uid, true);
        if (userModel != null) {
          ref.read(userProvider.notifier).setUser(userModel);
        } else {
          CustomDialog.showError(
              title: 'Data Error',
              message: 'Unable to get User info, try again later');
        }
      }
      ref.read(userTypeProvider.notifier).state = userType;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Smart Doctor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: darkColor,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
        ),
        builder: FlutterSmartDialog.init(),
        home: FutureBuilder<bool>(
            future: _initUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return const HomeMainPage();
                } else {
                  return const LoginMainPage();
                }
              } else {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }
}
