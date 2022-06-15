import 'package:campus_assistant/models/user_model.dart';
import 'package:campus_assistant/screens/home/office/add_cr.dart';
import 'package:campus_assistant/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/screens/home/office/widgets/cr_list_card.dart';

class CrList extends StatelessWidget {
  const CrList({
    Key? key,
    required this.userModel,
  }) : super(key: key);
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection('Universities')
        .doc(userModel.university)
        .collection('Departments')
        .doc(userModel.department)
        .collection('Cr');

    return Scaffold(
      floatingActionButton: userModel.role[UserRole.admin.name]
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddCr(userModel: userModel)));
              },
              child: const Icon(Icons.add),
            )
          : null,

      //
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        children: kYearList
            .map((year) =>
                CrListCard(userModel: userModel, year: year, ref: ref))
            .toList(),
      ),
    );
  }
}
