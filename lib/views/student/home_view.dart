import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_house/core/constants/app_dimensions.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:mr_house/viewmodels/auth/auth_cubit.dart';
import 'package:mr_house/viewmodels/auth/auth_state.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/viewmodels/course/course_state.dart';
import 'package:mr_house/views/shared/category_chip.dart';
import 'package:mr_house/views/shared/course_card_widget.dart';
import 'package:mr_house/views/student/personal_info_view.dart';

class StudentHomeView extends StatefulWidget {
  const StudentHomeView({super.key});

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}

class _StudentHomeViewState extends State<StudentHomeView> {
  String? _selectedCategory;

  final _categories = [
    {"icon": FontAwesomeIcons.userGraduate, "category": "General"},
    {"icon": FontAwesomeIcons.divide, "category": "Math"},
    {"icon": Icons.science, "category": "Science"},
    {"icon": Icons.menu_book, "category": "Arabic"},
    {"icon": Icons.abc, "category": "English"},
    {"icon": FontAwesomeIcons.atom, "category": "Physics"},
  ];

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello, ${user?.name.split(" ").first ?? ""}!",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PersonalInfoView(
                                  role: UserRole.student)));
                    },
                    child: CircleAvatar(
                      radius: 40,
                      child: const FaIcon(FontAwesomeIcons.user, size: 30),
                    ),
                  ),
                ],
              ),
              AppDimensions.hSBMd,
              const Text(AppStrings.category,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              AppDimensions.hSBSm,
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _categories
                      .map((c) => CategoryChip(
                            icon: c["icon"]! as dynamic,
                            label: c["category"]!.toString(),
                            onTap: () {
                              setState(() {
                                _selectedCategory = c["category"]!.toString();
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
              AppDimensions.hSBSm,
              const Text(AppStrings.topCourses,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              AppDimensions.hSBSm,
              Expanded(child: _courseList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _courseList() {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CourseLoaded) {
          final filtered =
              (_selectedCategory == null || _selectedCategory == "General")
                  ? state.courses
                  : state.courses
                      .where((c) => c.professorSpecialty == _selectedCategory)
                      .toList();

          if (filtered.isEmpty) {
            return const Center(child: Text(AppStrings.noCourses));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, i) => CourseCardWidget(course: filtered[i]),
          );
        }
        return const SizedBox();
      },
    );
  }
}
