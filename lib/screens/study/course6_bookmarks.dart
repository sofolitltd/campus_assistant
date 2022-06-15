import 'package:campus_assistant/screens/study/widgets/content_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/content_model.dart';
import '../../models/user_model.dart';

class CourseBookMarks extends StatelessWidget {
  const CourseBookMarks({Key? key, required this.userModel}) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        title: const Text('BookMarks'),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Universities")
              .doc(userModel.university)
              .collection('Departments')
              .doc(userModel.department)
              .collection('Bookmarks')
              .doc(userModel.email)
              .collection('Contents')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('something wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.size == 0) {
              return const Center(child: Text('No Bookmarks Found!'));
            }

            var data = snapshot.data!.docs;

            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                var contentId = data[index].id;
                var courseType = data[index].get('courseType');

                //
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Universities")
                        .doc(userModel.university)
                        .collection('Departments')
                        .doc(userModel.department)
                        .collection(courseType)
                        .doc(contentId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('something wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.data!.exists) {
                        return const Center(child: Text('No Bookmarks Found!'));
                      }

                      var data = snapshot.data!;
                      // model
                      ContentModel courseContentModel =
                          ContentModel.fromJson(data);

                      //
                      return Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          //
                          Container(
                            width: 26,
                            constraints: const BoxConstraints(
                              minHeight: 112,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                courseContentModel.courseCode.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),

                          //
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: ContentCard(
                                userModel: userModel,
                                contentId: contentId,
                                courseContentModel: courseContentModel),
                          ),
                        ],
                      );
                    });
              },
            );
          }),
    );
  }
}
