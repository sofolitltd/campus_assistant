import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../database_service.dart';
import '../../models/course_content_model.dart';
import '../../models/user_model.dart';
import '../study/widgets/content_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  UserModel? userModel;

  //
  getUser() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUser!.email)
        .get()
        .then((value) {
      for (var element in value.docs) {
        userModel = UserModel.fromJson(element);
      }
      setState(() {});
    });
  }

  //
  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),

      //
      body: (userModel == null)
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: DatabaseService.refUniversities
                  .doc(userModel!.university)
                  .collection('Departments')
                  .doc(userModel!.department)
                  .collection('Study')
                  .doc('Library')
                  .collection('Books')
                  .orderBy('courseCode')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.size == 0) {
                  return const Center(child: Text('No data Found!'));
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
                      courseContentModel: courseContentModel,
                    );
                  },
                );
              }),
    );
  }
}
