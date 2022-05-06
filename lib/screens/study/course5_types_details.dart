import 'package:campus_assistant/models/user_model.dart';
import 'package:campus_assistant/screens/study/widgets/content_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/database_service.dart';
import '/models/course_content_model.dart';
import '/models/course_model.dart';
import '/screens/study/upload/content_add.dart';

class CourseTypesDetails extends StatelessWidget {
  const CourseTypesDetails({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseType,
    required this.courseModel,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final String courseType;
  final CourseModel courseModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // add content
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddContent(
                        userModel: userModel,
                        selectedYear: selectedYear,
                        id: id,
                        courseType: courseType,
                        courseModel: courseModel,
                      )));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService.refUniversities
              .doc(userModel.university)
              .collection('Departments')
              .doc(userModel.department)
              .collection('Study')
              .doc('Courses')
              .collection(selectedYear)
              .doc(id)
              .collection(courseType)
              .where('batchList', arrayContains: userModel.batch)
              // .where('lessonNo', isEqualTo: courseType.lessonNo)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.size == 0) {
              return Center(child: Text('No $courseType Found!'));
            }

            var data = snapshot.data!.docs;

            //
            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                //model
                CourseContentModel courseContentModel =
                    CourseContentModel.fromJson(data[index]);

                var contentId = data[index].id;
                //
                return ContentCard(
                    contentId: contentId,
                    courseContentModel: courseContentModel);
              },
            );
          }),
    );
  }
}
