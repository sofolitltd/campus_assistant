import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModel {
  final bool present;
  final int serial;
  final String name,
      post,
      phd,
      mobile,
      email,
      imageUrl,
      interests,
      publications;

  TeacherModel({
    required this.serial,
    required this.present,
    required this.name,
    required this.post,
    required this.phd,
    required this.mobile,
    required this.email,
    required this.interests,
    required this.publications,
    required this.imageUrl,
  });

  //up
  Map<String, dynamic> toJson() {
    return {
      'serial': serial,
      'present': present,
      'name': name,
      'post': post,
      'phd': phd,
      'mobile': mobile,
      'email': email,
      'interests': interests,
      'publications': publications,
      'imageUrl': imageUrl,
    };
  }

  // fetch
  TeacherModel.formJson(DocumentSnapshot json)
      : this(
          serial: json['serial']! as int,
          present: json['present']! as bool,
          name: json['name']! as String,
          post: json['post']! as String,
          phd: json['phd']! as String,
          mobile: json['mobile']! as String,
          email: json['email']! as String,
          interests: json['interests']! as String,
          publications: json['publications']! as String,
          imageUrl: json['imageUrl']! as String,
        );
}
