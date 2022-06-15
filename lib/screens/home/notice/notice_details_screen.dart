import 'package:flutter/material.dart';

import '/models/notice_model.dart';
import '/models/user_model.dart';
import '/screens/home/notice/notice_by_batch.dart';
import 'notice_screen.dart';

class NoticeDetailsScreen extends StatelessWidget {
  final NoticeModel noticeModel;
  final UserModel userModel;

  const NoticeDetailsScreen({
    Key? key,
    required this.noticeModel,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
      ),

      //
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              ListTile(
                contentPadding: EdgeInsets.zero,
                // image
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(noticeModel.uploaderImage),
                ),

                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // uploader
                    Text(
                      noticeModel.uploaderName,
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    //
                    const Icon(Icons.arrow_right_outlined),

                    // to
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoticeByBatch(
                              userModel: userModel,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Text(
                          userModel.batch,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                style: noticeModel.message.length < 100
                    ? Theme.of(context).textTheme.headline5
                    : Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
