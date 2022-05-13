import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

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
  }) async {
    //
    var ref = refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection('Study');

    var contentId = const Uuid().v4();

    //
    await ref
        .doc('Courses')
        .collection(year)
        .doc(id)
        .collection(courseType)
        .doc(contentId)
        .set(courseContentModel.toJson());

    // add to library
    if (courseType == 'Books') {
      await ref
          .doc('Library')
          .collection('Books')
          .doc(contentId)
          .set(courseContentModel.toJson());
    }
  }

  //
  //
  static deleteCourseContent({
    required university,
    required department,
    required year,
    required String id,
    required String courseType,
    required String contentId,
  }) async {
    //
    var ref = refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection('Study');

    //
    await ref
        .doc('Courses')
        .collection(year)
        .doc(id)
        .collection(courseType)
        .doc(contentId)
        .delete();

    // add to library
    if (courseType == 'Books') {
      await ref.doc('Library').collection('Books').doc(contentId).delete();
    }
  }
}
