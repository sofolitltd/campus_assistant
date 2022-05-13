import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '/screens/study/upload/course_add.dart';
import '/utils/constants.dart';
import 'widgets/course_list.dart';

class CourseScreen2 extends StatefulWidget {
  static const routeName = 'course2_screen';
  const CourseScreen2({
    Key? key,
    required this.university,
    required this.department,
    required this.selectedYear,
    required this.userModel,
  }) : super(key: key);

  final String university;
  final String department;
  final String selectedYear;
  final UserModel userModel;

  @override
  State<CourseScreen2> createState() => _CourseScreen2State();
}

class _CourseScreen2State extends State<CourseScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.selectedYear),
        ),

        // add course
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddCourse(
                          university: widget.university,
                          department: widget.department,
                          selectedYear: widget.selectedYear,
                        )));
          },
          child: const Icon(Icons.add),
        ),

        // course list
        body: ListView(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            children: kCourseCategory
                .map((courseCategory) => CourseList(
                      userModel: widget.userModel,
                      selectedYear: widget.selectedYear,
                      courseCategory: courseCategory,
                    ))
                .toList()));
  }
}
