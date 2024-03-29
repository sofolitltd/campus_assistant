import 'package:campus_assistant/screens/study/widgets/content_card_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/screens/study/widgets/content_card.dart';
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
        title: const Text('Bookmarks'),
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
            return const Center(child: Text('something wrong'));
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
                    return const Center(child: Text('something wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.data!.exists) {
                    return const Center(child: Text('No Bookmarks Found!'));
                  }

                  var data = snapshot.data!;
                  // model
                  ContentModel courseContentModel = ContentModel.fromJson(data);

                  // for web browser
                  if (kIsWeb) {
                    return ContentCardWeb(
                      userModel: userModel,
                      contentId: contentId,
                      courseContentModel: courseContentModel,
                    );
                  }

                  //for mobile
                  return ContentCard(
                    userModel: userModel,
                    contentId: contentId,
                    courseContentModel: courseContentModel,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
