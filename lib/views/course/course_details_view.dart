import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/core/constants/app_colors.dart';
import 'package:mr_house/core/constants/app_dimensions.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/models/course_model.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/viewmodels/course/course_state.dart';
import 'package:mr_house/views/shared/info_card.dart';
import 'package:mr_house/views/shared/primary_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailsView extends StatefulWidget {
  final CourseModel course;

  const CourseDetailsView({super.key, required this.course});

  @override
  State<CourseDetailsView> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsView> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.course.introVid)!,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
    context.read<CourseCubit>().checkEnrolledAndFav(widget.course.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(AppStrings.courseDetails,
              style: TextStyle(fontSize: 30)),
          centerTitle: true),
      body: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          final course = state is CourseLoaded
              ? state.courses.firstWhere((c) => c.id == widget.course.id,
                  orElse: () => widget.course)
              : widget.course;
          final enrolled =
              state is CourseLoaded ? state.isEnrolled(course.id) : false;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  children: [
                    _professorSection(course),
                    _detailsSection(course),
                    Center(
                        child: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true)),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: PrimaryButton(
                        height: 50,
                        color: enrolled ? AppColors.error : AppColors.primary,
                        textColor: Colors.black,
                        onPressed: () => context
                            .read<CourseCubit>()
                            .toggleEnrolled(course.id, course.professorId),
                        label:
                            enrolled ? AppStrings.enrolled : AppStrings.enroll,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _professorSection(CourseModel course) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage("assets/images/Professor1.jpg")),
          AppDimensions.hSBSm,
          Text("Prof. ${course.professorName}",
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          AppDimensions.hSBSm,
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(course.professorBio,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                softWrap: true,
                textAlign: TextAlign.center),
          ),
          AppDimensions.hSBSm,
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(course.professorSpecialty,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                softWrap: true,
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _detailsSection(CourseModel course) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppDimensions.hSBSm,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoCardWidget(
                  label: AppStrings.students, value: course.students),
              InfoCardWidget(label: AppStrings.rating, value: course.rating),
            ],
          ),
          AppDimensions.hSBSm,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InfoCardWidget(label: AppStrings.age, value: course.professorAge),
              InfoCardWidget(
                  label: AppStrings.experiences,
                  value: "${course.professorExperience} ${AppStrings.years}"),
            ],
          ),
          AppDimensions.hSBSm,
          AppDimensions.hSBSm,
          const Text(AppStrings.aboutCourse,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          AppDimensions.hSBSm,
          Text(course.desc,
              style: const TextStyle(fontWeight: FontWeight.w500, height: 1.5),
              softWrap: true,
              textAlign: TextAlign.justify),
          AppDimensions.hSBSm,
          const Text(AppStrings.introCourse,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
