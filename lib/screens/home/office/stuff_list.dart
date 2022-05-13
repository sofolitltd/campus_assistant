import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_assistant/models/stuff_model.dart';
import 'package:campus_assistant/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        .doc('University of Chittagong')
        .collection('Departments')
        .doc('Department of Psychology')
        .collection('Stuff');

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          //
          StuffModel stuffModel = StuffModel(
              name: 'name',
              post: 'post',
              phone: 'phone',
              serial: 0,
              imageUrl: 'imageUrl');

          //
          ref.doc().set(stuffModel.toJson());
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      //
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.orderBy('serial').snapshots(),
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
              StuffModel stuffModel = StuffModel.fromJson(data[index]);

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
                            //
                            CachedNetworkImage(
                              imageUrl: stuffModel.imageUrl,
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

                            //
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //name
                                Text(
                                  stuffModel.name,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),

                                //post
                                Text(
                                  stuffModel.post,
                                ),

                                const SizedBox(height: 8),

                                //
                                SelectableText(
                                  stuffModel.phone,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                //
                              ],
                            ),
                          ],
                        ),

                        //
                        IconButton(
                          onPressed: () {},
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
