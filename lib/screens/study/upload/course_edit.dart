import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadChapterEdit extends StatefulWidget {
  const UploadChapterEdit({
    Key? key,
    required this.year,
    required this.courseType,
    required this.courseCode,
    required this.chapterNo,
    required this.chapterTitle,
  }) : super(key: key);
  final String year;
  final String courseType;
  final String courseCode;
  final String chapterNo;
  final String chapterTitle;

  @override
  _UploadChapterEditState createState() => _UploadChapterEditState();
}

class _UploadChapterEditState extends State<UploadChapterEdit> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? _selectedChapterNo;
  final TextEditingController _chapterTitleController = TextEditingController();

  @override
  void initState() {
    if (widget.chapterNo.isNotEmpty && widget.chapterTitle.isNotEmpty) {
      _selectedChapterNo = widget.chapterNo;
      _chapterTitleController.text = widget.chapterTitle;
    }

    super.initState();
  }

  @override
  void dispose() {
    _chapterTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('upload Chapter'),
        ),

        //

        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          children: [
            //top path
            buildPathSection(widget.year, widget.courseType, widget.courseCode),

            const SizedBox(height: 16),

            //
            Form(
              key: _formState,
              child: Column(
                children: [
                  //
                  Row(
                    children: [
                      Expanded(child: Container()),

                      const SizedBox(width: 16),

                      //
                      Expanded(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            value: _selectedChapterNo,
                            hint: const Text('Choose No'),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 8),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedChapterNo = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? "Choose Chapter No" : null,
                            items: ['1', '2', '3'].map((String val) {
                              return DropdownMenuItem(
                                alignment: Alignment.center,
                                value: val,
                                child: Text(
                                  val,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // title
                  TextFormField(
                    controller: _chapterTitleController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Chapter Title',
                      hintText: 'Introduction',
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter Chapter Title" : null,
                  ),

                  const SizedBox(height: 16),

                  //
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formState.currentState!.validate()) {
                            if (widget.chapterNo != _selectedChapterNo) {
                              deleteChapter(context, widget.chapterNo);
                              uploadChapter();
                              Navigator.pop(context);
                            } else {
                              uploadChapter();
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text('upload'))),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  // top path
  Wrap buildPathSection(String year, courseType, courseCode) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: Icon(Icons.account_tree_rounded),
        ),

        // year
        Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(width: .5, color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(year)),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(courseType),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(courseCode),
      ],
    );
  }

  //
  uploadChapter() async {
    await FirebaseFirestore.instance
        .collection('Study')
        .doc(widget.year)
        .collection(widget.courseType)
        .doc(widget.courseCode)
        .collection('Lessons')
        .doc(_selectedChapterNo.toString())
        .set({
      'title': _chapterTitleController.text,
    }).then((value) {
      Fluttertoast.showToast(msg: 'upload successfully');
    });
  }

  //delete chapter
  deleteChapter(BuildContext context, String id) async {
    await FirebaseFirestore.instance
        .collection('Study')
        .doc(widget.year)
        .collection(widget.courseType)
        .doc(widget.courseCode)
        .collection('Lessons')
        .doc(id)
        .delete()
        .then(
      (value) {
        // Fluttertoast.showToast(msg: 'Chapter delete successfully');
      },
    );
  }
}
