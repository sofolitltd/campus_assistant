import 'package:campus_assistant/models/student_model.dart';
import 'package:campus_assistant/models/user_model.dart';
import 'package:campus_assistant/screens/home/student/add_student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/screens/home/student/widgets/student_card.dart';
import 'all_batch_list.dart';

class StudentScreen extends StatelessWidget {
  static const routeName = 'student_screen';

  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(userModel.university)
        .collection('Departments')
        .doc(userModel.department)
        .collection('Students')
        .doc('Batch List')
        .collection(userModel.batch);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend List'),
        // centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        actions: [
          // all batch
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: MaterialButton(
                color: Colors.pink[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AllBatchList.routeName,
                    arguments: userModel,
                  );
                },
                child: const Text('All Student',
                    style: TextStyle(color: Colors.black87))),
          )
        ],
      ),
      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddStudent(
                        userModel: userModel,
                        selectedBatch: userModel.batch,
                      )));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.orderBy('orderBy', descending: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;

          if (data.isEmpty) {
            return const Center(child: Text('No data found!'));
          }

          //
          return Scrollbar(
            radius: const Radius.circular(8),
            interactive: true,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                StudentModel studentModel = StudentModel.fromJson(data[index]);
                //
                return StudentCard(studentModel: studentModel);
              },
            ),
          );
        },
      ),
    );
  }
}
