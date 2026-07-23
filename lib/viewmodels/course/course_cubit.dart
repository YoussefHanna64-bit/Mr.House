import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/viewmodels/course/course_state.dart';
import '../../models/course_model.dart';
import '../../repositories/course_repository.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository _repo;

  CourseCubit(this._repo) : super(CourseInitial());

  Future<void> loadCourses(
      {String? specialty, bool favoriteOnly = false}) async {
    emit(CourseLoading());

    final courses = await _repo.getCourses(
        specialty: specialty, favoriteOnly: favoriteOnly);
    final favIds = await _repo.getFavoriteIds();
    final enrolledIds = await _repo.getEnrolledIds();

    emit(CourseLoaded(
      List.from(courses),
      favIds: Set.from(favIds),
      enrolledIds: Set.from(enrolledIds),
    ));
  }

  Future<void> loadEnrolledCourses() async {
    emit(CourseLoading());
    final courses = await _repo.getEnrolledCourses();
    emit(CourseLoaded(List.from(courses)));
  }

  Future<void> loadProfessorCourses() async {
    emit(CourseLoading());
    final courses = await _repo.getProfessorCourses();
    emit(CourseLoaded(List.from(courses)));
  }

  Future<void> toggleEnrolled(String courseId, [String? professorId]) async {
    final currentState = state;

    if (currentState is CourseLoaded) {
      final isEnrolled = currentState.isEnrolled(courseId);
      final updatedEnrolledIds = isEnrolled
          ? (Set<String>.from(currentState.enrolledIds)..remove(courseId))
          : {...currentState.enrolledIds, courseId};

      final updatedCourses = currentState.courses.map((c) {
        if (c.id == courseId) {
          int students = int.tryParse(c.students) ?? 0;
          students =
              isEnrolled ? (students > 0 ? students - 1 : 0) : students + 1;
          return CourseModel(
            id: c.id,
            name: c.name,
            desc: c.desc,
            introVid: c.introVid,
            rating: c.rating,
            students: students.toString(),
            professorId: c.professorId,
            professorName: c.professorName,
            professorSpecialty: c.professorSpecialty,
            professorBio: c.professorBio,
            professorExperience: c.professorExperience,
            professorAge: c.professorAge,
            videos: c.videos,
          );
        }
        return c;
      }).toList();

      emit(CourseLoaded(updatedCourses,
          enrolledIds: updatedEnrolledIds,
          favIds: Set.from(currentState.favIds)));

      if (professorId == null) {
        final course =
            currentState.courses.where((c) => c.id == courseId).firstOrNull;
        professorId = course?.professorId;
      }

      await _repo.toggleEnrolled(courseId, isEnrolled, professorId);
    }
  }

  Future<void> toggleFavorite(String courseId) async {
    final currentState = state;

    if (currentState is CourseLoaded) {
      final wasFav = currentState.isFavorite(courseId);
      final updatedFavIds = wasFav
          ? (Set<String>.from(currentState.favIds)..remove(courseId))
          : {...currentState.favIds, courseId};

      emit(CourseLoaded(List.from(currentState.courses),
          favIds: updatedFavIds,
          enrolledIds: Set.from(currentState.enrolledIds)));

      await _repo.toggleFavorite(courseId, wasFav);
    }
  }

  Future<void> checkEnrolledAndFav(String courseId) async {
    if (state is CourseLoaded) {
      final current = state as CourseLoaded;

      emit(CourseLoaded(List.from(current.courses),
          enrolledIds: Set.from(current.enrolledIds),
          favIds: Set.from(current.favIds)));
    }
  }

  Future<void> createCourse(Map<String, dynamic> data) async {
    emit(CourseLoading());
    await _repo.createCourse(data);
    await loadProfessorCourses();
  }

  Future<void> updateCourse(String courseId, Map<String, dynamic> data) async {
    emit(CourseLoading());
    await _repo.updateCourse(courseId, data);
    await loadProfessorCourses();
  }

  Future<void> deleteCourse(String courseId) async {
    emit(CourseLoading());
    await _repo.deleteCourse(courseId);
    await loadProfessorCourses();
  }

  Future<void> addLecture(String courseId, Map<String, dynamic> lecture) async {
    emit(CourseLoading());
    await _repo.addLecture(courseId, lecture);
    await loadProfessorCourses();
  }

  Future<void> updateLecture(String courseId, Map<String, dynamic> oldLecture,
      Map<String, dynamic> newLecture) async {
    emit(CourseLoading());
    await _repo.updateLecture(courseId, oldLecture, newLecture);
    await loadProfessorCourses();
  }

  Future<void> deleteLecture(
      String courseId, Map<String, dynamic> lecture) async {
    emit(CourseLoading());
    await _repo.deleteLecture(courseId, lecture);
    await loadProfessorCourses();
  }

  Future<void> rateCourse(CourseModel course, double rating) async {
    emit(CourseLoading());
    await _repo.rateCourse(course.professorId, course.id, rating);
    await loadEnrolledCourses();
  }
}
