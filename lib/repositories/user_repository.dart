import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mr_house/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> getUser(String uid, UserRole role) async {
    final doc = await _firestore
        .collection(role == UserRole.student ? "students" : "professors")
        .doc(uid)
        .get();

    final data = doc.data() as Map<String, dynamic>;

    return UserModel.fromMap(
        uid, {...data, "email": _auth.currentUser?.email ?? ""}, role);
  }

  Future<void> updateProfile(UserRole role, String field, dynamic value) async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      return;
    }

    await _firestore
        .collection(role == UserRole.student ? "students" : "professors")
        .doc(uid)
        .update({field: value});
  }

  Future<void> updateEmail(UserRole role, String newEmail) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await user.verifyBeforeUpdateEmail(newEmail);
    await _firestore
        .collection(role == UserRole.student ? "students" : "professors")
        .doc(user.uid)
        .update({"email": newEmail});
  }
}
