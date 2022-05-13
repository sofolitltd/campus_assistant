import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/models/user_model.dart';
import '/screens/dashboard/dashboard.dart';
import '../../utils/constants.dart';

class SignUpScreen3 extends StatefulWidget {
  const SignUpScreen3({
    Key? key,
    required this.university,
    required this.department,
    required this.batch,
    required this.id,
    required this.session,
    required this.hallList,
  }) : super(key: key);

  final String university;
  final String department;
  final String batch;
  final String id;
  final String session;
  final List<String> hallList;

  @override
  State<SignUpScreen3> createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  String? _selectedBloodGroup;
  String? _selectedHall;

  bool _isObscure = true;
  bool _isLoading = false;

  var regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _globalKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //
                    Text(
                      'Create \nAccount',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    const SizedBox(height: 16),

                    //name
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        prefixIcon: const Icon(Icons.person_pin_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter your name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    //email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.mail_outline_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        // suffixIcon: regExp.hasMatch(_emailcontroller.text)
                        //     ? const Icon(Icons.check, color: Colors.green)
                        //     : const Icon(Icons.check),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter your email';
                        } else if (!regExp.hasMatch(val)) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    //password
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_open_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(_isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.remove_red_eye_outlined)),
                      ),
                      obscureText: _isObscure,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter your password';
                        } else if (val.length < 8) {
                          return 'Password at least 8 character';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // mobile
                    TextFormField(
                      controller: _mobileController,
                      validator: (value) {
                        if (value == null) {
                          return 'Enter Mobile Number';
                        } else if (value.length < 11 || value.length > 11) {
                          return 'Mobile Number at least 11 digits';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Mobile Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone_android_outlined)),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    // blood
                    DropdownButtonFormField(
                      value: _selectedBloodGroup,
                      hint: const Text('Select Blood Group'),
                      // isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                        prefixIcon: Icon(Icons.bloodtype_outlined),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedBloodGroup = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Select your blood group" : null,
                      items: kBloodGroup.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // hall
                    DropdownButtonFormField(
                      isExpanded: true,
                      value: _selectedHall,
                      hint: const Text('Choose Hall'),
                      // isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                        prefixIcon: Icon(Icons.home_work_outlined),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedHall = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? "Select your hall" : null,
                      items: widget.hallList.map((String val) {
                        return DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    //log in
                    ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                //
                                if (_globalKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);

                                  //
                                  await createNewUser(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Sign up')),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // createNewUser
  createNewUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() => null);

      //
      var user = userCredential.user;
      print(user);

      if (user != null) {
        //
        // uploadImageFile();

        //
        await addUserInformation(user);

        //
        setState(() => _isLoading = false);
        // Fluttertoast.showToast(msg: 'Registration successful');
        // Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.routeName,
        //     ((Route<dynamic> route) => false));
        //
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: 'Registration failed');
        setState(() => _isLoading = false);
      }

      //
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() => _isLoading = false);
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() => _isLoading = false);
        //
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Sign up Error'),
                  content:
                      const Text('The account already exists for that email.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'))
                  ],
                ));
        // Fluttertoast.showToast(
        //     msg: 'The account already exists for that email.');
      }
      // Fluttertoast.showToast(msg: '${e.message}');
      print('${e.message}');
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      Fluttertoast.showToast(msg: 'Some thing wrong.');
      print(e);
    }
  }

  // upload and download url
  // Future uploadImageFile() async {
  //   final filePath = 'Users/${widget.batch}';
  //   // final fileName = basename(_imageFile!.path);
  //   // final destination = '$filePath/$fileName';
  //   final destination = '$filePath/${widget.id}.jpg';
  //
  //   task = FirebaseApi.uploadFile(destination, _imageFile!);
  //   setState(() {});
  //
  //   if (task == null) return;
  //
  //   final snapshot = await task!.whenComplete(() {});
  //   final downloadedUrl = await snapshot.ref.getDownloadURL();
  //   print('Download-Link: $downloadedUrl');
  //
  //   // cloud fire store
  //   addStudentInformation(downloadedUrl);
  // }

  //
  // addStudentInformation(String downloadedUrl) async {
  //   //
  //   Map<String, dynamic> studentInfo = {
  //     'mobile': widget.mobile,
  //     'hall': widget.hall,
  //     'imageUrl': downloadedUrl,
  //   };
  //
  //   await FirebaseFirestore.instance
  //       .collection('Psychology')
  //       .doc('Students')
  //       .collection(widget.batch!)
  //       .doc(widget.id)
  //       .update(studentInfo)
  //       .whenComplete(() {
  //     print('Add Information successfully');
  //
  //     //
  //     removeVerificationToken();
  //   });
  // }

  //
  addUserInformation(User user) async {
    UserModel userModel = UserModel(
      university: widget.university,
      department: widget.department,
      batch: widget.batch,
      id: widget.id,
      session: widget.session,
      name: _nameController.text.trim(),
      email: user.email!,
      phone: _mobileController.text.trim(),
      blood: _selectedBloodGroup.toString(),
      hall: _selectedHall.toString(),
      status: 'Basic',
      imageUrl: '',
    );
    //
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .set(userModel.toJson());
  }

  // remove token
  // removeVerificationToken() async {
  //   FirebaseFirestore.instance
  //       .collection('Psychology')
  //       .doc('Verify')
  //       .collection(widget.batch!)
  //       .doc(widget.id)
  //       .update({'token': 'used'}).whenComplete(() {
  //     print('Remove Token successfully');
  //   });
  // }
}
