import 'package:cloud_firestore/cloud_firestore.dart';

class CourseContentModel {
  final String courseCode;
  final String contentType;
  final int lessonNo;
  final String status;
  final List<String> batchList;
  final String contentTitle;
  final String contentSubtitle;
  final String contentSubtitleType;
  final String uploadDate;
  final String fileUrl;

  CourseContentModel({
    required this.courseCode,
    required this.contentType,
    required this.lessonNo,
    required this.status,
    required this.batchList,
    required this.contentTitle,
    required this.contentSubtitle,
    required this.contentSubtitleType,
    required this.uploadDate,
    required this.fileUrl,
  });

  // fetch
  CourseContentModel.fromJson(DocumentSnapshot json)
      : this(
          courseCode: json['courseCode']! as String,
          contentType: json['contentType']! as String,
          lessonNo: json['lessonNo']! as int,
          status: json['status']! as String,
          batchList: (json['batchList']! as List).cast<String>(),
          contentTitle: json['contentTitle']! as String,
          contentSubtitle: json['contentSubtitle']! as String,
          contentSubtitleType: json['contentSubtitleType']! as String,
          uploadDate: json['uploadDate']! as String,
          fileUrl: json['fileUrl']! as String,
        );

  // upload
  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'contentType': contentType,
      'lessonNo': lessonNo,
      'status': status,
      'batchList': batchList,
      'contentTitle': contentTitle,
      'contentSubtitle': contentSubtitle,
      'contentSubtitleType': contentSubtitleType,
      'uploadDate': uploadDate,
      'fileUrl': fileUrl,
    };
  }
}
