import 'package:campus_assistant/models/user_model.dart';
import 'package:campus_assistant/screens/study/widgets/bookmark_counter.dart';
import 'package:flutter/material.dart';

import '/constraints.dart';
import '/models/course_model.dart';
import 'course3_notes_chapters.dart';
import 'course5_types_details.dart';

class CourseTypeScreen extends StatefulWidget {
  const CourseTypeScreen({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseModel,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final CourseModel courseModel;

  @override
  State<CourseTypeScreen> createState() => _CourseTypeScreenState();
}

class _CourseTypeScreenState extends State<CourseTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kCourseType.length,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: Text(
            '${widget.courseModel.courseCode} - ${widget.courseModel.courseTitle}',
          ),

          // tab bar
          bottom: TabBar(
            tabs: kCourseType.map((tab) => Tab(text: tab)).toList(),
          ),

          // bookmark
          actions: const [
            BookmarkCounter(),
          ],
        ),

        //
        body: TabBarView(
          children: [
            CourseNotesChapters(
              userModel: widget.userModel,
              selectedYear: widget.selectedYear,
              id: widget.id,
              courseType: kCourseType[0],
              courseModel: widget.courseModel,
            ),
            CourseTypesDetails(
              userModel: widget.userModel,
              selectedYear: widget.selectedYear,
              id: widget.id,
              courseType: kCourseType[1],
              courseModel: widget.courseModel,
            ),
            CourseTypesDetails(
              userModel: widget.userModel,
              selectedYear: widget.selectedYear,
              id: widget.id,
              courseType: kCourseType[2],
              courseModel: widget.courseModel,
            ),
            CourseTypesDetails(
              userModel: widget.userModel,
              selectedYear: widget.selectedYear,
              id: widget.id,
              courseType: kCourseType[3],
              courseModel: widget.courseModel,
            ),
          ],
        ),
      ),
    );
  }
}
