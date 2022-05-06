import 'package:campus_assistant/models/course_model.dart';
import 'package:campus_assistant/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '/constraints.dart';
import '/database_service.dart';
import '/models/course_chapter_model.dart';

class AddChapter extends StatefulWidget {
  const AddChapter({
    Key? key,
    required this.userModel,
    required this.selectedYear,
    required this.id,
    required this.courseModel,
    required this.courseType,
  }) : super(key: key);

  final UserModel userModel;
  final String selectedYear;
  final String id;
  final CourseModel courseModel;
  final String courseType;

  @override
  _AddChapterState createState() => _AddChapterState();
}

class _AddChapterState extends State<AddChapter> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  int? _selectedChapterNo;
  List<String>? _selectedBatchList;

  final TextEditingController _chapterTitleController = TextEditingController();

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
          title: const Text('Add Chapter'),
        ),

        //

        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          children: [
            //top path
            buildPathSection(
              widget.selectedYear,
              widget.courseModel.courseCategory,
              widget.courseModel.courseCode,
              'Chapters',
            ),

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
                            hint: const Text('Chapter No'),
                            decoration: const InputDecoration(
                              label: Text('Chapter No'),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 8),
                            ),
                            onChanged: (int? value) {
                              setState(() {
                                _selectedChapterNo = value;
                              });
                            },
                            validator: (value) =>
                                value == null ? "Choose Chapter No" : null,
                            items: List.generate(15, (index) => 1 + index++)
                                .map((int value) {
                              return DropdownMenuItem(
                                alignment: Alignment.center,
                                value: value,
                                child: Text(
                                  '$value',
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //
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

                  // batch list
                  MultiSelectDialogField(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    title: const Text('Accessible Batch List'),
                    buttonText: const Text('Batch List'),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    items:
                        kBatchList.map((e) => MultiSelectItem(e, e)).toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (List<String> values) {
                      setState(() {
                        _selectedBatchList = values;
                      });
                    },
                    validator: (values) => (values == null || values.isEmpty)
                        ? "Select some batch"
                        : null,
                  ),

                  const SizedBox(height: 16),

                  //
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formState.currentState!.validate()) {
                            CourseChapterModel courseLessonModel =
                                CourseChapterModel(
                              chapterNo: _selectedChapterNo!,
                              chapterTitle: _chapterTitleController.text.trim(),
                              batchList: _selectedBatchList!,
                            );

                            //
                            DatabaseService.addCourseChapter(
                              university: widget.userModel.university,
                              department: widget.userModel.department,
                              year: widget.selectedYear,
                              id: widget.id,
                              courseLessonModel: courseLessonModel,
                            );

                            //
                            Fluttertoast.showToast(msg: 'Upload successfully');

                            //
                            Navigator.pop(context);
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
  Wrap buildPathSection(String year, courseCategory, courseCode, chapter) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        //
        const Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.account_tree_outlined,
            color: Colors.black87,
            size: 20,
          ),
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
        Text(courseCategory),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(courseCode),

        //
        const Icon(Icons.keyboard_arrow_right_rounded),
        Text(chapter),
      ],
    );
  }
}

//
