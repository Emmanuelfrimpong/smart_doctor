import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_doctor/styles/colors.dart';
import 'package:smart_doctor/styles/styles.dart';

import 'components/home_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: IndexedStack(
          index: _currentIndex,
          alignment: Alignment.center,
          children: [
            const UserHome(),
            const Center(
              child: Text('Appointments Page'),
            ),
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
              icon: Icon(MdiIcons.calendarMonth), label: 'Appointments'),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
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
