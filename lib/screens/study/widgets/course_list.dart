import 'package:campus_assistant/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/database_service.dart';
import '/models/course_model.dart';
import '/widgets/headline.dart';
import 'course_card.dart';

class CourseList extends StatelessWidget {
  const CourseList({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.courseCategory,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String courseCategory;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //
        StreamBuilder<QuerySnapshot>(
          stream: DatabaseService.refUniversities
              .doc(userModel.university)
              .collection('Departments')
              .doc(userModel.department)
              .collection('Study')
              .doc('Courses')
              .collection(selectedYear)
              .where('courseCategory', isEqualTo: courseCategory)
              .where('batchList', arrayContains: userModel.batch)
              .orderBy('courseCode')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  child: const Center(child: CircularProgressIndicator()));
            }

            var data = snapshot.data!.docs;

            //
            if (data.isNotEmpty) {
              return Column(
                children: [
                  //
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 8,
                    ),
                    child: Headline(title: courseCategory),
                  ),

                  //
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 16),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    itemBuilder: (context, index) {
                      //model
                      CourseModel courseModel =
                          CourseModel.fromJson(data[index]);

                      //
                      return CourseCard(
                        userModel: userModel,
                        selectedYear: selectedYear,
                        id: data[index].id,
                        courseModel: courseModel,
                      );
                    },
                  ),
                ],
              );
            }

            //
            return Container();
          },
        ),
      ],
    );
  }
}
