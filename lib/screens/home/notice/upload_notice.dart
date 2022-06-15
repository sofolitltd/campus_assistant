import 'package:campus_assistant/models/notice_model.dart';
import 'package:campus_assistant/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UploadNotice extends StatefulWidget {
  final UserModel userModel;

  const UploadNotice({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<UploadNotice> createState() => _UploadNoticeState();
}

class _UploadNoticeState extends State<UploadNotice> {
  bool isButtonActive = false;
  final TextEditingController _messageController = TextEditingController();
  String counter = '';

  @override
  void initState() {
    super.initState();

    //
    _messageController.addListener(() {
      final isButtonActive = _messageController.text.isNotEmpty;
      setState(() {
        this.isButtonActive = isButtonActive;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(getDateTime());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userModel.batch),
        elevation: 0,
        titleSpacing: 0,
        actions: [
          // post button
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
            child: ElevatedButton(
                onPressed: isButtonActive
                    ? () {
                        setState(() => isButtonActive = true);

                        //
                        postMessage();
                      }
                    : null,
                child: const Text('Post')),
          ),
        ],
      ),

      //
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //admin profile
            Row(
              children: [
                CircleAvatar(
                  minRadius: 24,
                  backgroundImage: NetworkImage(widget.userModel.imageUrl),
                ),

                const SizedBox(width: 8),

                //
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userModel.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 2,
                        bottom: 3,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: .2),
                        borderRadius: BorderRadius.circular(2),
                        // color: Colors.orangeAccent.shade100,
                      ),
                      child: const Text(
                        'Class Representative',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 8),

            // message
            TextFormField(
              controller: _messageController,
              // autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type notice here!',
                hintStyle: TextStyle(fontSize: 20),
                // counterText: counter.length.toString(),
              ),
              onChanged: (value) => setState(() => counter = value),
              style: TextStyle(fontSize: counter.length < 100 ? 20 : 16),
              textCapitalization: TextCapitalization.sentences,
              minLines: 10,
              maxLines: 25,
            ),
          ],
        ),
      ),
    );
  }

  //
  postMessage() {
    var time = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());

    NoticeModel noticeModel = NoticeModel(
      uploaderName: widget.userModel.name,
      uploaderImage: widget.userModel.imageUrl,
      batch: [widget.userModel.batch],
      message: _messageController.text.toString(),
      time: time,
      seen: [],
    );

    //
    FirebaseFirestore.instance
        .collection('Universities')
        .doc(widget.userModel.university)
        .collection('Departments')
        .doc(widget.userModel.department)
        .collection('Notifications')
        .add(noticeModel.toJson())
        .then((value) {
      Fluttertoast.showToast(msg: 'Post notice successfully');
      Navigator.pop(context);
    });
  }
}
