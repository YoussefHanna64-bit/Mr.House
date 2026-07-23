import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mr_house/models/course_model.dart';

class CourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<CourseModel>> getCourses(
      {String? specialty, bool favoriteOnly = false}) async {
    try {
      final QuerySnapshot professorsSnapshot =
          specialty == null || specialty == "General"
              ? await _firestore.collection("professors").get()
              : await _firestore
                  .collection("professors")
                  .where("Specialty", isEqualTo: specialty)
                  .get();

      final userId = _auth.currentUser?.uid;
      Set<String> favCourseIds = {};

      if (favoriteOnly && userId != null) {
        final favDocs = await _firestore
            .collection("students")
            .doc(userId)
            .collection("favoriteCourses")
            .get();

        favCourseIds = favDocs.docs.map((d) => d.id).toSet();
      }

      List<CourseModel> allCourses = [];
      for (final profDoc in professorsSnapshot.docs) {
        final profData = profDoc.data() as Map<String, dynamic>;
        final coursesSnapshot = await _firestore
            .collection("professors")
            .doc(profDoc.id)
            .collection("courses")
            .get();

        for (final courseDoc in coursesSnapshot.docs) {
          if (favoriteOnly && !favCourseIds.contains(courseDoc.id)) {
            continue;
          }

          allCourses.add(CourseModel.fromMap(courseDoc.id, courseDoc.data(),
              professorId: profDoc.id,
              professorName: profData["Fullname"] ?? "",
              professorSpecialty: profData["Specialty"] ?? "",
              professorBio: profData["Bio"] ?? "",
              professorExperience: profData["Experience"]?.toString() ?? "",
              professorAge: profData["Age"]?.toString() ?? ""));
        }
      }

      return allCourses;
    } catch (e) {
      return [];
    }
  }

  Future<List<CourseModel>> getEnrolledCourses() async {
    final user = _auth.currentUser;

    if (user == null) {
      return [];
    }

    try {
      final enrolledDocs = await _firestore
          .collection("students")
          .doc(user.uid)
          .collection("enrolledCourses")
          .get();

      if (enrolledDocs.docs.isEmpty) {
        return [];
      }

      final enrolledIds = enrolledDocs.docs.map((d) => d.id).toSet();
      final allCourses = await getCourses();

      return allCourses.where((c) => enrolledIds.contains(c.id)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<CourseModel>> getProfessorCourses() async {
    final user = _auth.currentUser;

    if (user == null) {
      return [];
    }

    try {
      final courseDocs = await _firestore
          .collection("professors")
          .doc(user.uid)
          .collection("courses")
          .get();

      final profDoc =
          await _firestore.collection("professors").doc(user.uid).get();

      final profData = profDoc.data()!;

      return courseDocs.docs.map((d) {
        return CourseModel.fromMap(d.id, d.data(),
            professorId: user.uid,
            professorName: profData["Fullname"] ?? "",
            professorSpecialty: profData["Specialty"] ?? "",
            professorBio: profData["Bio"] ?? "",
            professorExperience: profData["Experience"]?.toString() ?? "",
            professorAge: profData["Age"]?.toString() ?? "");
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Set<String>> getFavoriteIds() async {
    final user = _auth.currentUser;

    if (user == null) {
      return {};
    }

    final docs = await _firestore
        .collection("students")
        .doc(user.uid)
        .collection("favoriteCourses")
        .get();

    return docs.docs.map((d) => d.id).toSet();
  }

  Future<Set<String>> getEnrolledIds() async {
    final user = _auth.currentUser;

    if (user == null) {
      return {};
    }

    final docs = await _firestore
        .collection("students")
        .doc(user.uid)
        .collection("enrolledCourses")
        .get();

    return docs.docs.map((d) => d.id).toSet();
  }

  Future<void> toggleEnrolled(String courseId, bool currentlyEnrolled,
      [String? professorId]) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final ref = _firestore
        .collection("students")
        .doc(user.uid)
        .collection("enrolledCourses")
        .doc(courseId);

    if (currentlyEnrolled) {
      await ref.delete();

      if (professorId != null) {
        final courseRef = _firestore
            .collection("professors")
            .doc(professorId)
            .collection("courses")
            .doc(courseId);

        final doc = await courseRef.get();
        if (doc.exists) {
          final data = doc.data();

          int students = data!["Students"] - 1;
          if (students < 0) {
            students = 0;
          }

          await courseRef.update({"Students": students});
        }
      }
    } else {
      await ref.set({"courseId": courseId});

      if (professorId != null) {
        final courseRef = _firestore
            .collection("professors")
            .doc(professorId)
            .collection("courses")
            .doc(courseId);

        final doc = await courseRef.get();
        if (doc.exists) {
          final data = doc.data();
          int students = data!["Students"] + 1;

          await courseRef.update({"Students": students});
        }
      }
    }
  }

  Future<void> toggleFavorite(String courseId, bool isFavorite) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final ref = _firestore
        .collection("students")
        .doc(user.uid)
        .collection("favoriteCourses")
        .doc(courseId);

    if (isFavorite) {
      await ref.delete();
    } else {
      await ref.set({"courseId": courseId});
    }
  }

  Future<void> createCourse(Map<String, dynamic> data) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection("professors")
        .doc(user.uid)
        .collection("courses")
        .doc()
        .set(data);
  }

  Future<void> updateCourse(String courseId, Map<String, dynamic> data) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection("professors")
        .doc(user.uid)
        .collection("courses")
        .doc(courseId)
        .update(data);
  }

  Future<void> deleteCourse(String courseId) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection("professors")
        .doc(user.uid)
        .collection("courses")
        .doc(courseId)
        .delete();
  }

  Future<void> addLecture(String courseId, Map<String, dynamic> lecture) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection("professors")
        .doc(user.uid)
        .collection("courses")
        .doc(courseId)
        .update({
      "videos": FieldValue.arrayUnion([lecture]),
    });
  }

  Future<void> updateLecture(String courseId, Map<String, dynamic> oldLecture,
      Map<String, dynamic> newLecture) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final ref = _firestore
        .collection("professors")
        .doc(user.uid)
        .collection("courses")
        .doc(courseId);

    await ref.update({
      "videos": FieldValue.arrayRemove([oldLecture])
    });

    await ref.update({
      "videos": FieldValue.arrayUnion([newLecture])
    });
  }

  Future<void> deleteLecture(
      String courseId, Map<String, dynamic> lecture) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore
        .collection("professors")
        .doc(user.uid)
        .collection("courses")
        .doc(courseId)
        .update({
      "videos": FieldValue.arrayRemove([lecture])
    });
  }

  Future<void> rateCourse(
      String professorId, String courseId, double newRating) async {
    final ref = _firestore
        .collection("professors")
        .doc(professorId)
        .collection("courses")
        .doc(courseId);

    final doc = await ref.get();

    if (doc.exists) {
      final currentRatingStr = doc.data()?["Rating"]?.toString() ?? "0";
      final currentRating = double.tryParse(currentRatingStr) ?? 0.0;
      final newAvg =
          currentRating == 0.0 ? newRating : (currentRating + newRating) / 2;

      await ref.update({"Rating": newAvg.toStringAsFixed(1)});
    }
  }
}
