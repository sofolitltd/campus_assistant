import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/models/user_model.dart';
import '../auth/login.dart';

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
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .where('email', isEqualTo: currentUser!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('something wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var docs = snapshot.data!.docs;

                //
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      UserModel userModel = UserModel.fromJson(docs[index]);

                      //
                      return profileCard(context, userModel);
                    });
                //
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
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(userModel.imageUrl),
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
                                    'blood (${userModel.blood})',
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
                                  onPressed: () {},
                                  child: const Text('Edit Profile'))),

                          const SizedBox(width: 12),

                          // log out
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();

                                    //
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

        //
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
                  ],
                ),
              ),

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
                    Icons.mail_outline,
                    color: Colors.white,
                  ),
                ),
                title: const Text('Help and Feedback'),
                subtitle: const Text('Reach us with your feedback'),
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
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Feedback on Facebook',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    //
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //contact us

                            Text(
                              'Contact Us',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Divider(),
                    //
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //rate us

                            Text(
                              'Rate Us',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
