import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/models/notice_model.dart';
import '/models/user_model.dart';
import '/screens/home/notice/upload_notice.dart';
import '/utils/constants.dart';
import 'notice_screen.dart';

class NoticeByBatch extends StatelessWidget {
  final UserModel userModel;
  const NoticeByBatch({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(userModel.batch),
          centerTitle: true,
        ),

        //
        body: SingleChildScrollView(
          child: Column(
            children: [
              //
              if (userModel.role[UserRole.cr.name])
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    tileColor: Theme.of(context).cardColor,
                    // image
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userModel.imageUrl),
                    ),

                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadNotice(
                              userModel: userModel,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        margin: const EdgeInsets.only(right: 8),
                        child: Text(
                          'Write something...',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ),
                ),

              //
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Universities')
                      .doc(userModel.university)
                      .collection('Departments')
                      .doc(userModel.department)
                      .collection('Notifications')
                      .where('batch', arrayContains: userModel.batch)
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height * .7,
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }

                    var data = snapshot.data!.docs;
                    return snapshot.data!.size == 0
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * .7,
                            child:
                                const Center(child: Text('No notice found!')))
                        : ListView.separated(
                            itemCount: data.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (BuildContext context, int index) {
//
                              var notice = data[index];
                              NoticeModel noticeModel =
                                  NoticeModel.fromJson(notice);

                              return Card(
                                elevation: 0,
                                margin: EdgeInsets.zero,
                                // width: double.infinity,
                                // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                // color: ,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                    bottom: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      //
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        // image
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              noticeModel.uploaderImage),
                                        ),

                                        title: Text(
                                          noticeModel.uploaderName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),

                                        //time
                                        subtitle: Text(
                                          TimeAgo.timeAgoSinceDate(
                                            noticeModel.time,
                                          ),
                                        ),
                                      ),

                                      //message
                                      SelectableText(
                                        noticeModel.message,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  }),
            ],
          ),
        ));
  }
}
