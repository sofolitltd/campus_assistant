import 'package:campus_assistant/models/course_content_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    Key? key,
    required this.contentId,
    required this.courseContentModel,
  }) : super(key: key);

  final String contentId;
  final CourseContentModel courseContentModel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Universities")
            .doc("University of Chittagong")
            .collection('Departments')
            .doc('Department of Psychology')
            .collection('Study')
            .doc('Bookmarks')
            .collection('asifreyad1@gmail.com')
            .doc(contentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_added,
                ));
          }

          if (snapshot.data!.exists) {
            return IconButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("Universities")
                      .doc("University of Chittagong")
                      .collection('Departments')
                      .doc('Department of Psychology')
                      .collection('Study')
                      .doc('Bookmarks')
                      .collection('asifreyad1@gmail.com')
                      .doc(contentId)
                      .delete()
                      .then((value) {
                    // Fluttertoast.cancel();
                    Fluttertoast.showToast(msg: 'Remove Bookmark');
                  });
                },
                icon: const Icon(Icons.bookmark_remove, color: Colors.red));
          }

          return IconButton(
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection("Universities")
                    .doc("University of Chittagong")
                    .collection('Departments')
                    .doc('Department of Psychology')
                    .collection('Study')
                    .doc('Bookmarks')
                    .collection('asifreyad1@gmail.com')
                    .doc(contentId)
                    .set(courseContentModel.toJson())
                    .then((value) {
                  //
                  // Fluttertoast.cancel();
                  Fluttertoast.showToast(msg: 'Add Bookmark');
                });
              },
              icon: const Icon(
                Icons.bookmark_added,
              ));
        });
  }
}
