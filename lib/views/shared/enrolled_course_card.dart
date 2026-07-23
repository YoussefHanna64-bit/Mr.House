import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/core/constants/app_colors.dart';
import 'package:mr_house/models/course_model.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/views/course/lectures_view.dart';
import 'package:mr_house/views/professor/create_course_view.dart';

class EnrolledCourseCard extends StatelessWidget {
  final CourseModel course;
  final bool isProfessor;

  const EnrolledCourseCard(
      {super.key, required this.course, required this.isProfessor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onLongPress: () {
          if (!isProfessor) return;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Course Options"),
              content: const Text("Choose an action for this course"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateCourseView(courseToEdit: course)));
                  },
                  child: const Text("Edit"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<CourseCubit>().deleteCourse(course.id);
                  },
                  child: const Text("Delete",
                      style: TextStyle(color: AppColors.deleteRed)),
                ),
              ],
            ),
          );
        },
        child: Card(
          elevation: 5,
          child: ListTile(
            title: Text(course.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LecturesView(course: course, isProfessor: isProfessor)),
              );
            },
          ),
        ),
      ),
    );
  }
}
