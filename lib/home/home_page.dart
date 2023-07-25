import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import '../state/data_state.dart';
import 'components/appointment/appointment_page.dart';
import 'components/home_page.dart';

class HomeMainPage extends ConsumerStatefulWidget {
  const HomeMainPage({super.key});

  @override
  ConsumerState<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends ConsumerState<HomeMainPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var user;
    var userType = ref.watch(userTypeProvider);
    if (userType == 'User') {
      user = ref.watch(userProvider);
    } else {
      user = ref.watch(doctorProvider);
    }
    return Scaffold(
      backgroundColor: primaryColor,
      body: IndexedStack(
          index: _currentIndex,
          alignment: Alignment.center,
          children: [
            const UserHome(),
            const AppointmentPage(),
            Container(
              child: const Center(
                child: Text('Chat Page'),
              ),
            ),
            Container(
              child: const Center(
                child: Text('Profile Page'),
              ),
            ),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.white,
        backgroundColor: Colors.transparent,
        selectedFontSize: 18,
        unselectedFontSize: 14,
        elevation: 2,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        items: [
          BottomNavigationBarItem(icon: Icon(MdiIcons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.calendarMonth), label: 'Appoint.'),
          BottomNavigationBarItem(icon: Icon(MdiIcons.chat), label: 'Chat'),
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
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(MdiIcons.logout),
                      label: const Text('Logout'),
                    ),
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
}
