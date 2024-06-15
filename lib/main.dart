import 'package:awesome_notifications/awesome_notifications.dart';
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
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/logo',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: primaryColor,
            playSound: true,
            soundSource: 'resource://raw/ring',
            enableVibration: true,
            importance: NotificationImportance.High,
            enableLights: true, 
            defaultRingtoneType: DefaultRingtoneType.Alarm,
            icon: 'resource://drawable/logo',
            ledColor: Colors.white),
            
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupName: 'Basic group', channelGroupKey: 'basic_channel_group',
          
        )
      ],
      debug: true);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<bool> _initUser() async {
    // await FirebaseAuthService.signOut();

    //check if token is set

    if (FirebaseAuthService.isUserLogin()) {
      User user = FirebaseAuthService.getCurrentUser();
      String? userType = user.displayName;
      //check if widget is build

      //check if widget is build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userTypeProvider.notifier).state = userType;
      });

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
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications(

    ).setListeners(
        onActionReceivedMethod:(ReceivedNotification receivedNotification) async{
        await NotificationController.onActionReceivedMethod(receivedNotification);}
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    super.initState();
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

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedAction) async {
   
  }
}
