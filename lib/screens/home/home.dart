import 'package:campus_assistant/screens/home/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import 'components/categories.dart';
import 'components/custom_drawer.dart';
import 'notice/notice_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  UserModel? userModel;

  //
  getUser() async {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser)
        .get()
        .then((data) {
      setState(() {
        userModel = UserModel.fromJson(data);
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
        centerTitle: true,
        title: const Text.rich(
          TextSpan(
            text: 'CAMPUS ',
            children: [
              TextSpan(
                text: 'ASSISTANT',
                style: TextStyle(
                  color: Colors.orange,
                ),
              )
            ],
          ),
          style: TextStyle(letterSpacing: 1),
          // maxLines: 1,
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications_none_outlined),
              onPressed: () {
                //
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoticeScreen(
                              userModel: userModel!,
                            )));
              }),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const CustomDrawer(),

      //
      body: userModel == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // header
                Header(userName: userModel!.name),

                // categories
                Categories(userModel: userModel!),

                //important links
                // ImportantLinks(),

                //drive links
                // DriveCollections(),

                //syllabus links
                // Syllabus(),
              ],
            ),
    );
  }
}
