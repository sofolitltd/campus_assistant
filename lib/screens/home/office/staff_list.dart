import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_assistant/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/models/stuff_model.dart';
import '/models/user_model.dart';
import '/widgets/open_app.dart';

class StuffList extends StatelessWidget {
  const StuffList({
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
        .doc(userModel.department);

    return Scaffold(
      floatingActionButton: userModel.role[UserRole.admin.name]
          ? FloatingActionButton(
              onPressed: () async {
                //
                StaffModel staffModel = StaffModel(
                  name: '',
                  post: '',
                  phone: '',
                  serial: 1,
                  imageUrl: '',
                );

                // todo: late add
                // ref.collection('Staff').doc().set(staffModel.toJson());
              },
              child: const Icon(Icons.add),
            )
          : null,
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.collection('Staff').orderBy('serial').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.docs;
          //
          return ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              StaffModel staffModel = StaffModel.fromJson(data[index]);

              //
              return GestureDetector(
                onLongPress: () async {
                  //
                  // await ref.doc(data[index].id).delete().then((value) =>
                  //     Fluttertoast.showToast(msg: 'Delete successful'));
                },
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        //
                        Row(
                          children: [
                            //image
                            CachedNetworkImage(
                              imageUrl: staffModel.imageUrl,
                              fadeInDuration: const Duration(milliseconds: 500),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 32,
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const CircleAvatar(
                                radius: 32,
                                backgroundImage: AssetImage(
                                    'assets/images/pp_placeholder.png'),
                                child: CupertinoActivityIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                      radius: 32,
                                      backgroundImage: AssetImage(
                                          'assets/images/pp_placeholder.png')),
                            ),

                            const SizedBox(width: 12),

                            //name, post, phone
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //name
                                Text(
                                  staffModel.name,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),

                                //post
                                Text(
                                  staffModel.post,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: Colors.grey),
                                ),

                                const SizedBox(height: 8),

                                //
                                if (staffModel.phone.isNotEmpty)
                                  Row(
                                    children: [
                                      //
                                      const Icon(
                                        Icons.phone_android_outlined,
                                        size: 16,
                                      ),

                                      const SizedBox(width: 8),
                                      //
                                      SelectableText(
                                        staffModel.phone,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                //
                              ],
                            ),
                          ],
                        ),

                        //
                        if (staffModel.phone.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              OpenApp.withNumber(staffModel.phone);
                            },
                            icon: const Icon(
                              Icons.call_outlined,
                              color: Colors.green,
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 15),
          );
        },
      ),
    );
  }
}
