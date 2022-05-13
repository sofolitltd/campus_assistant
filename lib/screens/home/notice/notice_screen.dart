import 'package:campus_assistant/screens/home/notice/upload_notice.dart';
import 'package:campus_assistant/screens/home/notice/upload_notice_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


enum ActionsList { edit, delete, cancel }

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  String? batch;
  String? id;
  String? crName;
  String? crImageUrl;
  bool crEmailVerify = false;

  @override
  void initState() {
    //
    getBatchAndId();
    //
    verifyCREmail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice'),
        elevation: 0,
        centerTitle: true,
      ),

      // floating button
      floatingActionButton: crEmailVerify
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadNotice(
                            batch: batch!,
                            crName: crName!,
                            crImageUrl: crImageUrl!)));
              },
              child: const Icon(Icons.add),
            )
          : null,

      body: batch == ''
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Notice')
                  .doc(batch)
                  .collection('Cr')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var data = snapshot.data!.docs;
                return snapshot.data!.size == 0
                    ? const Center(child: Text('No notice found'))
                    : ListView.separated(
                        itemCount: data.length,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (BuildContext context, int index) {
//
                          var notice = data[index];

                          //
                          return ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 100),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //header
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 4, 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              notice.get('crImageUrl')),
                                        ),
                                        const SizedBox(width: 8),

                                        // name and time
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //name
                                              Text(notice.get('crName'),
                                                  style: const TextStyle()),

                                              const SizedBox(height: 4),

                                              //time
                                              Row(
                                                children: [
                                                  const Icon(Icons.timeline,
                                                      // color: Colors.black45,
                                                      size: 16),
                                                  const SizedBox(width: 3),

                                                  //
                                                  // Text(notice.get('time')),
                                                  Text(TimeAgo.timeAgoSinceDate(
                                                      notice.get('time'))),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        // menu
                                        if (crEmailVerify)
                                          InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (context) =>
                                                        buildBottomModal(
                                                            context, notice));
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: const Icon(
                                                    Icons.more_vert_outlined),
                                              ))
                                      ],
                                    ),
                                  ),

                                  const Divider(height: 1),

                                  //message
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 8, 12, 16),
                                    child: Text(
                                      notice.get('message'),
                                      style: TextStyle(
                                          fontSize: notice
                                                      .get('message')
                                                      .toString()
                                                      .length <
                                                  100
                                              ? 20
                                              : 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              }),
    );
  }

  //
  getBatchAndId() async {
    var userId = FirebaseAuth.instance.currentUser!.uid.toString();

    //
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .get()
        .then((value) {
      batch = value.get('batch');
      id = value.get('id');

      //
      getCRNameAndImage(batch: batch!, id: id!);

      //
      getNotice(batch: batch!);
    });
  }

  //
  getNotice({required String batch}) {
    FirebaseFirestore.instance
        .collection('Notice')
        .doc(batch)
        .collection('Cr')
        .get()
        .then((value) => null);
  }

  //
  void verifyCREmail() async {
    var userEmail = FirebaseAuth.instance.currentUser!.email.toString();

    //
    await FirebaseFirestore.instance
        .collection('Psychology')
        .doc('Admin')
        .collection('CR')
        .doc(userEmail)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          crEmailVerify = true;
          print('cr email status: $crEmailVerify');
        });
      } else {
        setState(() {
          crEmailVerify = false;
          print('cr email status: $crEmailVerify');
        });
      }
    });
  }

  //
  getCRNameAndImage({required String batch, required String id}) async {
    await FirebaseFirestore.instance
        .collection('Psychology')
        .doc('Students')
        .collection(batch)
        .doc(id)
        .get()
        .then((value) {
      crName = value.get('name');
      crImageUrl = value.get('imageUrl');
      print('$crName => $crImageUrl');
    });
  }

  //
  buildBottomModal(BuildContext context, QueryDocumentSnapshot notice) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // edit  post
          ListTile(
              onTap: () async {
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadNoticeEdit(
                      batch: batch!,
                      crName: notice.get('crName'),
                      crImageUrl: notice.get('crImageUrl'),
                      message: notice.get('message'),
                      messageId: notice.id,
                    ),
                  ),
                );
              },
              leading: const Icon(Icons.edit),
              title: const Text('Edit')),

          //delete post
          ListTile(
              onTap: () {
                deletePost(context, currentBatch: batch!, noticeId: notice.id);
              },
              leading: const Icon(Icons.delete),
              title: const Text('Delete')),
        ],
      ),
    );
  }

  //delete post
  deletePost(BuildContext context,
      {required String currentBatch, required String noticeId}) async {
    await FirebaseFirestore.instance
        .collection('Notice')
        .doc(currentBatch)
        .collection('Cr')
        .doc(noticeId)
        .delete()
        .then(
      (value) {
        Fluttertoast.showToast(msg: 'Post delete successfully');
        Navigator.pop(context);
      },
    );
  }
}

//
class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mm a").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
