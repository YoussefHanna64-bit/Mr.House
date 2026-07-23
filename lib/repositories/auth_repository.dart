import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> signIn(String email, String password, UserRole role) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    final user = credential.user!;

    final doc = await _firestore
        .collection(role == UserRole.student ? "students" : "professors")
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      throw Exception(role == UserRole.student
          ? "You are not a student"
          : "You are not a professor");
    }

    final data = doc.data() as Map<String, dynamic>;
    await _saveSession(true, role);
    return UserModel.fromMap(user.uid, {...data, "email": user.email!}, role);
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String address,
    required String phoneNumber,
    required String gender,
    required UserRole role,
    String? bio,
    String? specialty,
    String? age,
    String? experience,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    final user = credential.user!;

    final data = <String, dynamic>{
      if (role == UserRole.student) "name": name else "Fullname": name,
      "address": address,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "email": email,
    };

    if (role == UserRole.professor) {
      data.addAll({
        "Bio": bio,
        "Specialty": specialty,
        "Age": age,
        "Experience": experience,
      });
    }

    await _firestore
        .collection(role == UserRole.student ? "students" : "professors")
        .doc(user.uid)
        .set(data);

    return UserModel.fromMap(user.uid, {...data, "email": email}, role);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("isLoggedIn");
    await prefs.remove("userRole");
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final roleStr = prefs.getString("userRole") ?? "";
    final role = roleStr == "professor" ? UserRole.professor : UserRole.student;

    final doc = await _firestore
        .collection(role == UserRole.student ? "students" : "professors")
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(user.uid, {...data, "email": user.email!}, role);
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> reauthenticate(String password) async {
    final user = _auth.currentUser!;

    await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email!, password: password));
  }

  Future<void> updatePassword(String newPassword) async {
    await _auth.currentUser!.updatePassword(newPassword);
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser!.delete();
  }

  Future<void> _saveSession(bool isLoggedIn, UserRole role) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isLoggedIn", isLoggedIn);
    await prefs.setString(
        "userRole", role == UserRole.student ? "student" : "professor");
  }
}
