import 'package:mr_house/models/course_model.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<CourseModel> courses;
  final Set<String> enrolledIds;
  final Set<String> favIds;

  CourseLoaded(
    this.courses, {
    this.enrolledIds = const {},
    this.favIds = const {},
  });

  bool isEnrolled(String id) => enrolledIds.contains(id);
  bool isFavorite(String id) => favIds.contains(id);
}

class CourseError extends CourseState {
  final String message;

  CourseError(this.message);
}
