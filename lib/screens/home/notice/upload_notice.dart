import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UploadNotice extends StatefulWidget {
  final String batch;
  final String crName;
  final String crImageUrl;

  const UploadNotice({
    Key? key,
    required this.batch,
    required this.crName,
    required this.crImageUrl,
  }) : super(key: key);

  @override
  _UploadNoticeState createState() => _UploadNoticeState();
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
        title: const Text("Upload Notice"),
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
                  backgroundImage: NetworkImage(widget.crImageUrl),
                ),

                const SizedBox(width: 8),

                //
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.crName),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      child: const Text(
                        'Class Representative',
                        style: TextStyle(fontSize: 12),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: .5),
                        borderRadius: BorderRadius.circular(2),
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

    FirebaseFirestore.instance
        .collection('Notice')
        .doc(widget.batch)
        .collection('Cr')
        .add({
      'crName': widget.crName,
      'crImageUrl': widget.crImageUrl,
      'time': time,
      'message': _messageController.text.toString(),
    }).then((value) {
      Fluttertoast.showToast(msg: 'Post notice successfully');
      Navigator.pop(context);
    });
  }
}
