import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/viewmodels/course/course_state.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/views/shared/course_card_widget.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            children: [
              const Center(
                  child: Text(AppStrings.favoriteCourses,
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold))),
              Expanded(
                child: BlocBuilder<CourseCubit, CourseState>(
                  builder: (context, state) {
                    if (state is CourseLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is CourseLoaded) {
                      final favCourses = state.courses
                          .where((c) => state.isFavorite(c.id))
                          .toList();

                      if (favCourses.isEmpty) {
                        return const Center(
                            child: Text(AppStrings.noFavorites));
                      }
                      return ListView.builder(
                        itemCount: favCourses.length,
                        itemBuilder: (context, i) =>
                            CourseCardWidget(course: favCourses[i]),
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
