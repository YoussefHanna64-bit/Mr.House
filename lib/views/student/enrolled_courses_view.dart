import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/viewmodels/course/course_state.dart';
import 'package:mr_house/views/shared/enrolled_course_card.dart';

class EnrolledCoursesView extends StatelessWidget {
  const EnrolledCoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            children: [
              const Center(
                  child: Text(AppStrings.yourCourses,
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold))),
              Expanded(
                child: BlocBuilder<CourseCubit, CourseState>(
                  builder: (context, state) {
                    if (state is CourseLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CourseLoaded) {
                      final enrolledCourses = state.courses
                          .where((c) => state.isEnrolled(c.id))
                          .toList();

                      if (enrolledCourses.isEmpty) {
                        return const Center(child: Text(AppStrings.noEnrolled));
                      }

                      return ListView.builder(
                        itemCount: enrolledCourses.length,
                        itemBuilder: (context, i) => EnrolledCourseCard(
                            course: enrolledCourses[i], isProfessor: false),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
