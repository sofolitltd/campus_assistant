import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../course6_bookmarks.dart';

class BookmarkCounter extends StatelessWidget {
  const BookmarkCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //todo: fix ref
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Universities")
            .doc("University of Chittagong")
            .collection('Departments')
            .doc('Department of Psychology')
            .collection('Study')
            .doc('Bookmarks')
            .collection('asifreyad1@gmail.com')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('');
          }

          var data = snapshot.data!.size;

          if (data == 0) {
            return const Text('');
          }
          //
          return GestureDetector(
            onTap: () {
              //
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CourseBookMarks()));
            },
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 24,
              ),
              margin: const EdgeInsets.only(right: 8, top: 16, bottom: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  // shape: BoxShape.circle,
                  // border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                data.toString(),
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }
}
