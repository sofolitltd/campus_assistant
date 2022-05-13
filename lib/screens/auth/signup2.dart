import 'package:campus_assistant/screens/auth/signup3.dart';
import 'package:campus_assistant/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen2 extends StatefulWidget {
  static const routeName = 'register_info_screen';

  const SignUpScreen2({
    Key? key,
    required this.university,
    required this.department,
    required this.batchList,
    required this.hallList,
    required this.sessionList,
  }) : super(key: key);

  final String university;
  final String department;
  final List<String> batchList;
  final List<String> hallList;
  final List<String> sessionList;

  @override
  _SignUpScreen2State createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();

  String? _selectedBatch;
  String? _selectedSession;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      // floatingActionButton: showFab
      //     ? FloatingActionButton.extended(
      //         onPressed: () async {
      //           showDialog(
      //               context: context,
      //               builder: (_) => AlertDialog(
      //                     title: Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         const Text('Help center'),
      //                         IconButton(
      //                           onPressed: () {
      //                             Navigator.pop(context);
      //                           },
      //                           icon: const Icon(Icons.clear),
      //                         )
      //                       ],
      //                     ),
      //                     titlePadding: const EdgeInsets.only(left: 16),
      //                     contentPadding:
      //                         const EdgeInsets.symmetric(horizontal: 16),
      //                     content: Column(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         const Text(
      //                             'Like our page and send a message with\n\nName:'
      //                             ' \nBatch: \nStudent id:\n\nWe will send code as soon as possible.'),
      //                         const SizedBox(height: 8),
      //                         OutlinedButton.icon(
      //                             onPressed: () async {
      //                               await canLaunch(kFbGroup)
      //                                   ? await launch(kFbGroup)
      //                                   : throw 'Could not launch $kFbGroup';
      //                             },
      //                             icon: const Icon(Icons.facebook,
      //                                 color: Colors.blue),
      //                             label: const Text('Get Code with Facebook')),
      //                         Row(
      //                           children: [
      //                             Expanded(
      //                                 child: Container(
      //                                     height: 1, color: Colors.grey)),
      //                             const Padding(
      //                               padding: EdgeInsets.all(8.0),
      //                               child: Text('OR'),
      //                             ),
      //                             Expanded(
      //                                 child: Container(
      //                                     height: 1, color: Colors.grey)),
      //                           ],
      //                         ),
      //                         const Text('Contact with Developer'),
      //                         const SizedBox(height: 16),
      //                         Container(
      //                           color: Colors.transparent,
      //                           // width: double.infinity,
      //                           child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: const [
      //                               //call
      //                               CustomButton(
      //                                   type: 'tel:',
      //                                   link: kDeveloperMobile,
      //                                   icon: Icons.call,
      //                                   color: Colors.green),
      //
      //                               SizedBox(width: 8),
      //
      //                               //mail
      //                               CustomButton(
      //                                   type: 'mailto:',
      //                                   link: kDeveloperEmail,
      //                                   icon: Icons.mail,
      //                                   color: Colors.red),
      //
      //                               SizedBox(width: 8),
      //
      //                               //facebook
      //                               CustomButton(
      //                                   type: '',
      //                                   link: kDeveloperFb,
      //                                   icon: Icons.facebook,
      //                                   color: Colors.blue),
      //                             ],
      //                           ),
      //                         ),
      //                         const SizedBox(height: 16),
      //                       ],
      //                     ),
      //                   ));
      //         },
      //         label: const Text('Need verification code'),
      //         icon: const Icon(Icons.help),
      //       )
      //     : null,

      //
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),

                  //
                  Text(
                    'Register'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  const Text(
                    'Verify your identity ',
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 32),

                  //batch
                  DropdownButtonFormField(
                    value: _selectedBatch,
                    hint: const Text('Select Batch'),
                    // isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedBatch = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Select your batch" : null,
                    items: widget.batchList.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  //session
                  DropdownButtonFormField(
                    value: _selectedSession,
                    hint: const Text('Select Session'),
                    // isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedSession = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? "Select your session" : null,
                    items: widget.sessionList.map((String val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(
                          val,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  //id
                  TextFormField(
                    controller: _idController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter student id';
                      }
                      // else if (value.length < 8 || value.length > 8) {
                      //   return 'Student id at least 8 digits';
                      // }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Student ID',
                      labelText: 'Student ID',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  //verify
                  TextFormField(
                    controller: _verificationController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter verification code';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Verification Code',
                      labelText: 'Verification Code',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 32),

                  // button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            //
                            if (_globalKey.currentState!.validate()) {
                              setState(() => _isLoading = true);

                              //
                              await verifyCode();
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Verify'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // verifyCode
  verifyCode() async {
    await UserRepo.refUniversities
        .doc(widget.university)
        .collection('Departments')
        .doc(widget.department)
        .collection('Students')
        .doc('Batch List')
        .collection(_selectedBatch.toString())
        .doc(_idController.text)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (!snapshot.exists) {
        print('id not found');
        Fluttertoast.showToast(msg: "Student ID not found in Database");
        setState(() => _isLoading = false);
      } else {
        print('id  found');
        var token = snapshot.get('token');

        if (token == _verificationController.text) {
          print("Verification Code Match");
          setState(() => _isLoading = false);

          //
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpScreen3(
                        university: widget.university,
                        department: widget.department,
                        batch: _selectedBatch.toString(),
                        id: _idController.text,
                        session: _selectedSession.toString(),
                        hallList: widget.hallList,
                      )));

          //
        } else if (token == 'Used') {
          Fluttertoast.showToast(msg: "Verification code already used");
          //
          setState(() => _isLoading = false);
        } else {
          Fluttertoast.cancel();
          Fluttertoast.showToast(msg: "Wrong verify code. Enter correct one");
          setState(() => _isLoading = false);
        }
      }
    });
  }
}
