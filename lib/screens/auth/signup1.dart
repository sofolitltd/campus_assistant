import 'package:campus_assistant/screens/auth/signup2.dart';
import 'package:campus_assistant/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpScreen1 extends StatefulWidget {
  const SignUpScreen1({Key? key}) : super(key: key);
  //
  static const routeName = 'signup1_screen';

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  List universityList = [];
  String? _selectedUniversity;
  String? _selectedDepartment;
  bool _isLoading = false;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    getUniversityList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // university list
                DropdownButtonFormField(
                  isExpanded: true,
                  hint: const Text('Select your university'),
                  value: _selectedUniversity,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'University',
                  ),
                  items: universityList
                      .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item, overflow: TextOverflow.ellipsis)))
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

                const SizedBox(height: 16),

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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Department',
                        ),
                        items: [].map((item) {
                          // university name
                          return DropdownMenuItem<String>(
                              value: item, child: Text(item));
                        }).toList(),
                        onChanged: (String? value) {},
                        validator: (value) =>
                            value == null ? 'please select a department' : null,
                      );
                    }

                    var docs = snapshot.data!.docs;
                    // select department
                    return DropdownButtonFormField(
                      hint: const Text('Select your department'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Department',
                      ),
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

                const SizedBox(height: 24),

                //button
                ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_globalKey.currentState!.validate()) {
                              setState(() => _isLoading = true);

                              // batch
                              List<String> batchList = await getUniversityInfo(
                                university: _selectedUniversity.toString(),
                                department: _selectedDepartment.toString(),
                                listFor: 'Batch',
                              );

                              // hall
                              List<String> hallList = await getUniversityInfo(
                                university: _selectedUniversity.toString(),
                                department: _selectedDepartment.toString(),
                                listFor: 'Hall',
                              );

                              // hall
                              List<String> sessionList =
                                  await getUniversityInfo(
                                university: _selectedUniversity.toString(),
                                department: _selectedDepartment.toString(),
                                listFor: 'Session',
                              );

                              setState(() => _isLoading = false);

                              print(batchList);
                              //
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen2(
                                      university:
                                          _selectedUniversity.toString(),
                                      department:
                                          _selectedDepartment.toString(),
                                      batchList: batchList,
                                      hallList: hallList,
                                      sessionList: sessionList,
                                    ),
                                  ));
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Next'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // get university
  getUniversityList() {
    UserRepo.refUniversities.get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() => universityList.add(doc.id));
        }
      },
    );
  }

  // get info
  getUniversityInfo({
    required String university,
    required String department,
    required String listFor,
  }) async {
    List<String> infoList = [];
    await UserRepo.refUniversities
        .doc(university)
        .collection('Departments')
        .doc(department)
        .collection(listFor)
        .orderBy('name')
        .get()
        .then(
      (QuerySnapshot snapshot) {
        for (var batch in snapshot.docs) {
          infoList.add(batch.get('name'));
        }
      },
    );
    return infoList;
  }
}
