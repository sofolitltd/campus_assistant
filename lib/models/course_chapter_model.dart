import 'package:cloud_firestore/cloud_firestore.dart';

class CourseChapterModel {
  final int chapterNo;
  final String chapterTitle;
  final List<String> batchList;

  CourseChapterModel({
    required this.chapterNo,
    required this.chapterTitle,
    required this.batchList,
  });

  // fetch
  CourseChapterModel.fromJson(DocumentSnapshot json)
      : this(
          chapterNo: json['chapterNo']! as int,
          chapterTitle: json['chapterTitle']! as String,
          batchList: (json['batchList']! as List).cast<String>(),
        );

  // upload
  Map<String, dynamic> toJson() {
    return {
      'chapterNo': chapterNo,
      'chapterTitle': chapterTitle,
      'batchList': batchList,
    };
  }
}
