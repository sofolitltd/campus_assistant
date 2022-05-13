import 'package:cloud_firestore/cloud_firestore.dart';

class StuffModel {
  final String name;
  final String post;
  final String phone;
  final int serial;
  final String imageUrl;

  StuffModel({
    required this.name,
    required this.post,
    required this.phone,
    required this.serial,
    required this.imageUrl,
  });

  //fetch
  StuffModel.fromJson(DocumentSnapshot json)
      : this(
          name: json['name']! as String,
          post: json['post']! as String,
          phone: json['phone']! as String,
          serial: json['serial']! as int,
          imageUrl: json['imageUrl']! as String,
        );

  // upload
  Map<String, dynamic> toJson() => {
        'name': name,
        'post': post,
        'phone': phone,
        'serial': serial,
        'imageUrl': imageUrl,
      };
}
