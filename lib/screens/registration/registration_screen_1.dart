import 'package:campus_assistant/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../study/course1_screen.dart';

class RegistrationScreen1 extends StatefulWidget {
  const RegistrationScreen1({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen1> createState() => _RegistrationScreen1State();
}

class _RegistrationScreen1State extends State<RegistrationScreen1> {
  List universityList = [];
  String? _selectedUniversity;
  String? _selectedDepartment;

  @override
  void initState() {
    getUniversityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              // university list
              DropdownButtonFormField(
                hint: const Text('Select your university'),
                value: _selectedUniversity,
                items: universityList
                    .map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item)))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedUniversity = null;
                    _selectedDepartment = null;
                    _selectedUniversity = value!;
                  });
                },
                validator: (value) =>
                    value == null ? 'please select a university' : null,
              ),

              const SizedBox(height: 8),

              // Departments
              StreamBuilder<QuerySnapshot>(
                stream: UserRepo.refUniversities
                    .doc(_selectedUniversity)
                    .collection('Departments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Some thing went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // loading state
                    return DropdownButtonFormField(
                      hint: const Text('Select your department'),
                      items: [].map((item) {
                        // university name
                        return DropdownMenuItem<String>(
                            value: item, child: Text(item));
                      }).toList(),
                      onChanged: (String? value) {},
                    );
                  }

                  var docs = snapshot.data!.docs;
                  // select department
                  return DropdownButtonFormField(
                    hint: const Text('Select your department'),
                    value: _selectedDepartment,
                    items: docs.map((item) {
                      // university name
                      return DropdownMenuItem<String>(
                          value: item.id, child: Text(item.id));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedDepartment = value!;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'please select a department' : null,
                  );
                },
              ),

              const SizedBox(height: 16),

              //button
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CourseScreen(),
                      ),
                    );
                  },
                  child: const Text('Register'))
            ],
          ),
        ),
      ),
    );
  }

  // get categories
  getUniversityList() {
    UserRepo.refUniversities.get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() => universityList.add(doc.id));
        }
      },
    );
  }
}
