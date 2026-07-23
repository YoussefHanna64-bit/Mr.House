import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/core/constants/app_colors.dart';
import 'package:mr_house/models/course_model.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/viewmodels/course/course_state.dart';
import 'package:mr_house/views/course/course_details_view.dart';

class CourseCardWidget extends StatelessWidget {
  final CourseModel course;

  const CourseCardWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        final isFav =
            state is CourseLoaded ? state.isFavorite(course.id) : false;

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CourseDetailsView(course: course)));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 5,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(course.name,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(course.students,
                                  style: const TextStyle(fontSize: 12)),
                              GestureDetector(
                                onTap: () => context
                                    .read<CourseCubit>()
                                    .toggleFavorite(course.id),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline,
                                  color: AppColors.favorite,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_border,
                                  color: AppColors.star, size: 14),
                              const Spacer(flex: 1),
                              Text(course.rating,
                                  style: const TextStyle(fontSize: 12)),
                              const Spacer(flex: 115),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
