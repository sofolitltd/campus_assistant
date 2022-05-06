import 'package:campus_assistant/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/database_service.dart';
import '/models/course_chapter_model.dart';
import '/models/course_model.dart';
import '/screens/study/upload/chapter_add.dart';
import 'course4_notes_details.dart';

class CourseNotesChapters extends StatelessWidget {
  const CourseNotesChapters({
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
      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add chapter
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddChapter(
                        userModel: userModel,
                        selectedYear: selectedYear,
                        id: id,
                        courseModel: courseModel,
                        courseType: courseType,
                      )));
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService.refUniversities
              .doc(userModel.university)
              .collection('Departments')
              .doc(userModel.department)
              .collection('Study')
              .doc('Courses')
              .collection(selectedYear)
              .doc(id)
              .collection('Chapters')
              .where('batchList', arrayContains: userModel.batch)
              .orderBy('chapterNo')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.size == 0) {
              return const Center(child: Text('No Chapters Found!'));
            }

            var data = snapshot.data!.docs;

            //
            return ListView.separated(
              shrinkWrap: true,
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                //model
                CourseChapterModel courseChapterModel =
                    CourseChapterModel.fromJson(data[index]);
                //
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onTap: () {
                      // notes details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseNotesDetails(
                            userModel: userModel,
                            selectedYear: selectedYear,
                            id: id,
                            courseType: courseType,
                            courseModel: courseModel,
                            courseChapterModel: courseChapterModel,
                          ),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.amber.shade200,
                      ),
                      alignment: Alignment.center,
                      child: Text('${courseChapterModel.chapterNo}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          )),
                    ),
                    title: Text(
                      courseChapterModel.chapterTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
