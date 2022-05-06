import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepo {
  static final FirebaseFirestore ref = FirebaseFirestore.instance;
  static final refUniversities = ref.collection('Universities');
}
