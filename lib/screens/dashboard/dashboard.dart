import 'package:campus_assistant/screens/liberary/library.dart';
import 'package:flutter/material.dart';

import '/screens/home/home.dart';
import '/screens/profile/profile.dart';
import '/screens/study/course1_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  //
  static const routeName = 'dashboard_screen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex!,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.school),
            icon: Icon(Icons.school_outlined),
            label: 'Study',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.photo_library_rounded),
            icon: Icon(Icons.photo_library_outlined),
            label: 'Library',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),

      //
      body: screensList[_currentPageIndex!],
    );
  }

  //
  List screensList = const [
    HomeScreen(),
    CourseScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];
}
