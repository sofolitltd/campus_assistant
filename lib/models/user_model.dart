import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.university,
    required this.department,
    required this.year,
    required this.batch,
    required this.email,
    required this.status,
  });

  final String university;
  final String department;
  final String year;
  final String batch;
  final String email;
  final String status;

  // get
  UserModel.fromJson(DocumentSnapshot json)
      : this(
          university: json['university']! as String,
          department: json['department']! as String,
          year: json['year']! as String,
          batch: json['batch']! as String,
          email: json['email']! as String,
          status: json['status']! as String,
        );

  // up
  toJson() {
    return UserModel(
      university: university,
      department: department,
      year: year,
      batch: batch,
      email: email,
      status: status,
    );
  }
}
