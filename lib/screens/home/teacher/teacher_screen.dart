import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_assistant/screens/home/teacher/teacher_add.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/teacher_model.dart';
import '../../../models/user_model.dart';
import '../teacher/teacher_details_screen.dart';

class TeacherScreen extends StatelessWidget {
  static const routeName = 'teacher_screen';

  const TeacherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text('Teacher Information'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Present'),
              Tab(text: 'Study Leave'),
            ],
          ),
        ),

        //body
        body: TabBarView(
          children: [
            // present
            TeacherListView(userModel: userModel, isPresent: true),

            //study leave
            TeacherListView(userModel: userModel, isPresent: false),
          ],
        ),
      ),
    );
  }
}

// teacher list view
class TeacherListView extends StatelessWidget {
  const TeacherListView(
      {Key? key, required this.userModel, required this.isPresent})
      : super(key: key);

  final UserModel userModel;
  final bool isPresent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TeacherAdd(userModel: userModel, present: isPresent),
              ));
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Universities')
            .doc(userModel.university)
            .collection('Departments')
            .doc(userModel.department)
            .collection('Teachers')
            .where('present', isEqualTo: isPresent)
            .orderBy('serial')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;
          return snapshot.data!.size == 0
              ? const Center(child: Text('No data found'))
              : Scrollbar(
                  radius: const Radius.circular(8),
                  interactive: true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.length,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (BuildContext context, int index) {
                      //
                      TeacherModel teacherModel =
                          TeacherModel.formJson(data[index]);

                      //
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          //
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.pushNamed(
                              context,
                              TeacherDetailsScreen.routeName,
                              arguments: teacherModel,
                            ),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: teacherModel.name,
                                      child: CachedNetworkImage(
                                        imageUrl: teacherModel.imageUrl,
                                        fadeInDuration:
                                            const Duration(milliseconds: 500),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          backgroundImage: imageProvider,
                                          radius: 32,
                                        ),
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            const CircleAvatar(
                                                radius: 32,
                                                backgroundImage: AssetImage(
                                                    'assets/images/pp_placeholder.png'),
                                                child:
                                                    CupertinoActivityIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const CircleAvatar(
                                                radius: 32,
                                                backgroundImage: AssetImage(
                                                    'assets/images/pp_placeholder.png')),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(teacherModel.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 8),
                                        Text(teacherModel.post,
                                            style: const TextStyle()),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                          //
                          Text(teacherModel.serial.toString()),
                        ],
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
