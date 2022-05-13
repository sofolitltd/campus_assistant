import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/user_model.dart';

class UserInfo {
  //
  static getUser() async {
    var currentUser = 'asifreyad1@gmail.com';
    UserModel? userModel;

    await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUser)
        .get()
        .then((value) {
      for (var element in value.docs) {
        userModel = UserModel.fromJson(element);
      }
    });
    return userModel;
  }
}
