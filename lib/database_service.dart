import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/course_chapter_model.dart';
import 'models/course_content_model.dart';
import 'models/course_model.dart';

class DatabaseService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static var refUniversities =
      FirebaseFirestore.instance.collection('Universities');

  //
  static addCourse({
    required university,
    required department,
    required String year,
    required CourseModel courseModel,
  }) async {
    //
    await refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection('Study')
        .doc('Courses')
        .collection(year)
        .add(courseModel.toJson());
  }

  //
  static addCourseChapter({
    required university,
    required department,
    required year,
    required String id,
    required CourseChapterModel courseLessonModel,
  }) {
    //
    refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection('Study')
        .doc('Courses')
        .collection(year)
        .doc(id)
        .collection('Chapters')
        .doc()
        .set(courseLessonModel.toJson());
  }

  //
  static addCourseContent({
    required university,
    required department,
    required year,
    required String id,
    required String courseType,
    required CourseContentModel courseContentModel,
  }) {
    //
    refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection('Study')
        .doc('Courses')
        .collection(year)
        .doc(id)
        .collection(courseType)
        .doc()
        .set(courseContentModel.toJson());
  }

//reference
// final CollectionReference refStudy =
//     ref.collection('psychology').doc('information').collection('teachers');

// //add teacher info
// Future addTeacher() async {
//   TeacherModel teacher = TeacherModel(
//     serial: '15',
//     present: true,
//     name: '',
//     post: '',
//     phd: '',
//     mobile: '',
//     email: '',
//     imageUrl: '',
//     interest: '',
//     publications: '',
//   );
//
//   return await _reference.doc('15').set(teacher.toJson());
// }
//
// //get teachers info
// Stream<QuerySnapshot> get getTeachersInfo {
//   return _reference.snapshots();
// }
}
