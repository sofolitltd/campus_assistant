import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '../../widgets/headline.dart';
import 'course2_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  //
  static const routeName = 'course1_screen';

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen>
    with AutomaticKeepAliveClientMixin {
  //
  @override
  bool get wantKeepAlive => true;

  String? university;
  String? department;
  late UserModel userModel;
  List yearList = [];

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
      setState(() {
        university = userModel.university;
        department = userModel.department;
        getYearList();
      });
    });
  }

  // get
  getYearList() {
    FirebaseFirestore.instance
        .collection('Universities')
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection('Year or Semester')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        yearList.add(element);
      });
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
    //for automatic keep alive
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study'),
      ),

      // add year
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //
          FirebaseFirestore.instance
              .collection('Universities')
              .doc(university)
              .collection('Departments')
              .doc(department)
              .collection('Year or Semester')
              .doc()
              .set({
            'name': 'Year',
            'courses': '',
            'credits': '',
            'marks': '',
          });
        },
        child: const Icon(Icons.add),
      ),

      body: ListView(
          padding: const EdgeInsets.only(
            top: 8,
            left: 16,
            right: 16,
          ),
          children: [
            //
            const Headline(title: 'All Course'),

            //
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Universities')
                    .doc(university)
                    .collection('Departments')
                    .doc(department)
                    .collection('Year or Semester')
                    .orderBy('name')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Some thing wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .7,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  var data = snapshot.data!.docs;
                  //
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        //
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CourseScreen2(
                                      university: university!,
                                      department: department!,
                                      selectedYear: data[index].get('name'),
                                      userModel: userModel,
                                    )));
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.centerRight,
                        children: [
                          //
                          Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(right: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Container(
                              width: double.infinity,
                              height: 96,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //year title
                                  Text(
                                    data[index].get('name'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),

                                  // year sub title
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text('Courses: '),
                                            Text(
                                              '${data[index].get('courses')}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      //
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.greenAccent.shade100,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        child: Row(
                                          children: [
                                            const Text('Marks: '),
                                            Text(
                                              '${data[index].get('marks')}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orangeAccent.shade100,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 4,
                                    offset: const Offset(1, 3)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  data[index].get('credits'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'credits',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            // const Icon(Icons.arrow_forward_ios_outlined),
                          )
                        ],
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 15),
                  );
                }),

            //
          ]),
    );
  }
}
