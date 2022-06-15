import 'package:campus_assistant/models/content_model.dart';
import 'package:campus_assistant/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    Key? key,
    required this.contentId,
    required this.userModel,
    required this.courseContentModel,
  }) : super(key: key);

  final String contentId;
  final UserModel userModel;
  final ContentModel courseContentModel;

  @override
  Widget build(BuildContext context) {
    //todo: fix ref
    var ref = FirebaseFirestore.instance
        .collection("Universities")
        .doc(userModel.university)
        .collection('Departments')
        .doc(userModel.department)
        .collection('Bookmarks')
        .doc(userModel.email)
        .collection('Contents');

    //
    return StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_outlined,
                ));
          }

          var id = '';
          for (var element in snapshot.data!.docs) {
            id = element.id;
            if (id == contentId) {
              return IconButton(
                  onPressed: () async {
                    //todo: fix ref
                    await ref.doc(contentId).delete().then((value) {
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(msg: 'Remove Bookmark');
                    });
                  },
                  icon: const Icon(Icons.favorite_outlined, color: Colors.red));
            }
          }

          //
          return IconButton(
              onPressed: () async {
                ref.doc(contentId).set({
                  'userEmail': userModel.email,
                  'courseType': courseContentModel.contentType,
                  'contentId': contentId,
                }).then((value) {
                  //
                  Fluttertoast.cancel();
                  Fluttertoast.showToast(msg: 'Add Bookmark');
                });
              },
              icon: const Icon(
                Icons.favorite_border_outlined,
              ));
        });
  }
}
