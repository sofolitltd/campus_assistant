import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/constraints.dart';
import '/models/user_model.dart';
import '/screens/study/upload/course_add.dart';
import '/screens/study/widgets/course_list.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  String? selectedYear;
  String? university;
  String? department;
  late UserModel userModel;

  //
  getUser() async {
    var currentUser = 'asifreyad1@gmail.com';
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value);
      setState(() {
        university = userModel.university;
        department = userModel.department;
        selectedYear = userModel.year;
      });
    });
  }

  // year button
  Card buildYearButton() {
    return Card(
      margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      color: Colors.pink[100],
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            hint: const Text('Select Year'),
            value: selectedYear,
            items: kYearList
                .map((String? item) =>
                    DropdownMenuItem(child: Text(item!), value: item))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                selectedYear = value!;
                // print(value);
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Study'),
          actions: [buildYearButton()],
        ),

        // add course
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddCourse(
                          university: university!,
                          department: department!,
                          selectedYear: selectedYear!,
                        )));
          },
          child: const Icon(Icons.add),
        ),

        // course list
        body: (university == null || department == null || selectedYear == null)
            ? Center(
                child: Container(),
              )
            : ListView(
                children: kCourseCategory
                    .map((courseCategory) => CourseList(
                          userModel: userModel,
                          selectedYear: selectedYear!,
                          courseCategory: courseCategory,
                        ))
                    .toList()));
  }
}
