import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/core/constants/app_colors.dart';
import 'package:mr_house/models/course_model.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/views/course/lecture_playback_view.dart';
import 'package:mr_house/views/professor/create_lecture_view.dart';

class LecturesView extends StatelessWidget {
  final CourseModel course;
  final bool isProfessor;

  const LecturesView(
      {super.key, required this.course, required this.isProfessor});

  void _showRatingDialog(BuildContext context, CourseModel course) {
    int rating = 5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Rate Course"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                );
              }),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<CourseCubit>()
                      .rateCourse(course, rating.toDouble());
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(course.name, style: const TextStyle(fontSize: 30)),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...course.videos.map((video) {
              final name = video["name"] ?? "No Name";
              return Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onLongPress: () {
                      if (!isProfessor) {
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Lecture Options"),
                          content:
                              const Text("Choose an action for this lecture."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateLectureView(
                                            courseData: course,
                                            lectureToEdit: video)));
                              },
                              child: const Text("Edit"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context
                                    .read<CourseCubit>()
                                    .deleteLecture(course.id, video);
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
                          title: Text(name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LecturePlaybackView(videoData: video)));
                          }),
                    ),
                  ));
            }),
            if (!isProfessor)
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () => _showRatingDialog(context, course),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      const Text("Rate Course"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: isProfessor
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateLectureView(courseData: course),
                  ),
                );
              },
              backgroundColor: Colors.green,
              tooltip: "Create Lecture",
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
