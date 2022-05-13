import 'package:campus_assistant/providers/user_provider.dart';
import 'package:campus_assistant/screens/auth/login.dart';
import 'package:campus_assistant/screens/auth/signup1.dart';
import 'package:campus_assistant/screens/auth/wrapper.dart';
import 'package:campus_assistant/screens/dashboard/dashboard.dart';
import 'package:campus_assistant/screens/home/about/about_screen.dart';
import 'package:campus_assistant/screens/home/home.dart';
import 'package:campus_assistant/screens/home/office/office_screen.dart';
import 'package:campus_assistant/screens/home/student/all_batch_list.dart';
import 'package:campus_assistant/screens/home/student/student_screen.dart';
import 'package:campus_assistant/screens/home/teacher/teacher_details_screen.dart';
import 'package:campus_assistant/screens/home/teacher/teacher_screen.dart';
import 'package:campus_assistant/screens/profile/profile.dart';
import 'package:campus_assistant/screens/study/course1_screen.dart';
import 'package:campus_assistant/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/screens/auth/welcome.dart';
import 'firebase_options.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  // force to stick portrait screen
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      darkTheme: darkThemeData(context),
      theme: lightThemeData(context),
      initialRoute: WrapperScreen.routeName,
      routes: routes,
    );
  }
}

// route
Map<String, Widget Function(BuildContext)> routes = {
  //
  // SplashScreen.routeName: (context) => const SplashScreen(),
  WrapperScreen.routeName: (context) => const WrapperScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),

  DashboardScreen.routeName: (context) => const DashboardScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  SignUpScreen1.routeName: (context) => const SignUpScreen1(),

  // home
  HomeScreen.routeName: (context) => const HomeScreen(),

  TeacherScreen.routeName: (context) => const TeacherScreen(),
  TeacherDetailsScreen.routeName: (context) => const TeacherDetailsScreen(),

  StudentScreen.routeName: (context) => const StudentScreen(),

  AllBatchList.routeName: (context) => const AllBatchList(),

  OfficeScreen.routeName: (context) => const OfficeScreen(),

  AboutScreen.routeName: (context) => const AboutScreen(),

  // study
  CourseScreen.routeName: (context) => const CourseScreen(),
  // CourseScreen2.routeName: (context) => const CourseScreen2(),

  //profile
  ProfileScreen.routeName: (context) => const ProfileScreen(),
};
