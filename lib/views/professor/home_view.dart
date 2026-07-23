import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_house/core/constants/app_colors.dart';
import 'package:mr_house/core/constants/app_dimensions.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:mr_house/viewmodels/auth/auth_cubit.dart';
import 'package:mr_house/viewmodels/auth/auth_state.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/viewmodels/course/course_state.dart';
import 'package:mr_house/views/professor/create_course_view.dart';
import 'package:mr_house/views/shared/enrolled_course_card.dart';
import 'package:mr_house/views/student/personal_info_view.dart';

class ProfessorHomeView extends StatefulWidget {
  const ProfessorHomeView({super.key});

  @override
  State<ProfessorHomeView> createState() => _ProfessorHomeViewState();
}

class _ProfessorHomeViewState extends State<ProfessorHomeView> {
  @override
  void initState() {
    super.initState();
    context.read<CourseCubit>().loadProfessorCourses();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state is AuthAuthenticated
        ? (context.watch<AuthCubit>().state as AuthAuthenticated).user
        : null;

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
                                  role: UserRole.professor)));
                    },
                    child: CircleAvatar(
                      radius: 40,
                      child: const FaIcon(FontAwesomeIcons.user, size: 30),
                    ),
                  ),
                ],
              ),
              AppDimensions.hSBMd,
              const Text(AppStrings.yourCourses,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              AppDimensions.hSBSm,
              Expanded(child: _courseList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCourseView()),
          );
        },
        backgroundColor: AppColors.primary,
        tooltip: "Create Course",
        child: const Icon(Icons.add),
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
          if (state.courses.isEmpty) {
            return const Center(child: Text(AppStrings.noCourses));
          }
          return ListView.builder(
            itemCount: state.courses.length,
            itemBuilder: (context, i) =>
                EnrolledCourseCard(course: state.courses[i], isProfessor: true),
          );
        }
        return const SizedBox();
      },
    );
  }
}
