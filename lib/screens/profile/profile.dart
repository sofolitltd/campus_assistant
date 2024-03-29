import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_assistant/screens/home/notice/notice_group.dart';
import 'package:campus_assistant/screens/study/course6_bookmarks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/models/user_model.dart';
import '../auth/login.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  //
  static const routeName = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  //
  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    getRef();
    super.initState();
  }

  getRef() async {
    final prefs = await SharedPreferences.getInstance();
    // Obtain shared preferences.

    var un = prefs.getString('university');
    prefs.getString('department');
    print('share: $un');
    return un;
  }

  @override
  Widget build(BuildContext context) {
    //for automatic keep alive
    super.build(context);

    //
    var currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade100,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      //
      body: Stack(
        children: [
          //
          // bg
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade100,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),

          //
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('something wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data!;
                UserModel userModel = UserModel.fromJson(docs);

                //
                return profileCard(context, userModel);
              }),
        ],
      ),
    );
  }

  //
  Widget profileCard(BuildContext context, UserModel userModel) {
    return Column(
      children: [
        //
        Stack(
          // alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // image, name,
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        spreadRadius: 3,
                        offset: Offset(2, 1)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // image
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: userModel.imageUrl,
                            fadeInDuration: const Duration(milliseconds: 500),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/pp_placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/pp_placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        //name, status
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              Text(
                                userModel.name,
                                // maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),

                              // const SizedBox(height: 2),

                              //
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  //
                                  Text(
                                    'Blood group (${userModel.blood})',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),

                                  //
                                  if (userModel.status == 'Pro')
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 20,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              //
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).dividerColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    userBasic(
                                      context,
                                      'Batch',
                                      userModel.batch,
                                    ),
                                    userBasic(
                                      context,
                                      'Session',
                                      userModel.session,
                                    ),
                                    userBasic(
                                      context,
                                      'Student ID',
                                      userModel.id,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // const SizedBox(height: 12),

                    //
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 4),
                      child: Row(
                        children: [
                          //
                          Expanded(
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditProfile(
                                                  userModel: userModel,
                                                )));
                                  },
                                  child: const Text('Edit Profile'))),

                          const SizedBox(width: 12),

                          // log out
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();

                                    //
                                    if (!mounted) return;
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                        (route) => false);
                                  },
                                  child: const Text('Log Out'))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // contact
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            children: [
              //
              ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.contact_page_outlined,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Contact Information'),
                subtitle: const Text('Email, Phone No'),
              ),

              //
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Text(
                      'Email',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(height: 2),

                    //
                    Text(
                      userModel.email,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),

                    const Divider(),

                    //
                    Text(
                      'Phone',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(height: 2),

                    //
                    Text(
                      userModel.phone,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),

                    const Divider(),

                    //
                    Text(
                      'Hall',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(height: 2),

                    //
                    Text(
                      userModel.hall,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              // content
              ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 0,
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.mail_outline,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Essentials'),
                subtitle: const Text(' Notice Group, Bookmarks '),
              ),

              //
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NoticeGroup(userModel: userModel),
                            ),
                          );
                        },
                        title: Text(
                          'Notice Groups',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                        ),
                      ),

                      const Divider(height: 1),

                      ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourseBookMarks(userModel: userModel),
                            ),
                          );
                        },
                        title: Text(
                          'Bookmarks',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                        ),
                      ),
                      //
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  //
  Column userBasic(BuildContext context, String title, subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),

        const SizedBox(height: 2),

        //
        Text(
          subtitle,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
