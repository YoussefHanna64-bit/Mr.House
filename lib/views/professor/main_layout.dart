import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:mr_house/views/professor/home_view.dart';
import 'package:mr_house/views/student/settings_view.dart';

class ProfessorMainLayout extends StatefulWidget {
  const ProfessorMainLayout({super.key});

  @override
  State<ProfessorMainLayout> createState() => _ProfessorMainLayoutState();
}

class _ProfessorMainLayoutState extends State<ProfessorMainLayout> {
  int _page = 0;
  final PageController _ctrl = PageController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => setState(() => _page = _ctrl.page!.round()));
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
            ProfessorHomeView(),
            SettingsView(role: UserRole.professor)
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
                icon: FaIcon(FontAwesomeIcons.gear), label: "Settings"),
          ],
        ),
      ),
    );
  }
}
