import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/views/student/enrolled_courses_view.dart';
import 'package:mr_house/views/student/favorites_view.dart';
import 'package:mr_house/views/student/home_view.dart';
import 'package:mr_house/views/student/settings_view.dart';

class StudentMainLayout extends StatefulWidget {
  const StudentMainLayout({super.key});

  @override
  State<StudentMainLayout> createState() => _StudentMainLayoutState();
}

class _StudentMainLayoutState extends State<StudentMainLayout> {
  int _page = 0;
  final PageController _ctrl = PageController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() => _page = _ctrl.page!.round()));
    context.read<CourseCubit>().loadCourses();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PageView(
          controller: _ctrl,
          children: const [
            StudentHomeView(),
            FavoritesView(),
            EnrolledCoursesView(),
            SettingsView()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          onTap: (i) => _ctrl.animateToPage(i,
              duration: const Duration(milliseconds: 500), curve: Curves.ease),
          items: const [
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house), label: "Home"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidHeart), label: "Favorite"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
                label: "Your Courses"),
            BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.gear), label: "Settings"),
          ],
        ),
      ),
    );
  }
}
