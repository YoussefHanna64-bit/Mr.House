import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_house/core/constants/app_dimensions.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/models/course_model.dart';
import 'package:mr_house/viewmodels/course/course_cubit.dart';
import 'package:mr_house/viewmodels/course/course_state.dart';
import 'package:mr_house/views/shared/app_text_field.dart';
import 'package:mr_house/views/shared/primary_button.dart';

class CreateCourseView extends StatefulWidget {
  final CourseModel? courseToEdit;

  const CreateCourseView({super.key, this.courseToEdit});

  @override
  State<CreateCourseView> createState() => _CreateCourseViewState();
}

class _CreateCourseViewState extends State<CreateCourseView> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _lectureCtrl = TextEditingController();
  final _videoCtrl = TextEditingController();

  String? _nameErr, _descErr, _lectureErr, _videoErr;

  @override
  void initState() {
    super.initState();
    if (widget.courseToEdit != null) {
      final c = widget.courseToEdit!;
      _nameCtrl.text = c.name;
      _descCtrl.text = c.desc;
      if (c.videos.isNotEmpty) {
        _lectureCtrl.text = c.videos.first["name"] ?? "";
        _videoCtrl.text = c.videos.first["url"] ?? "";
      } else {
        _videoCtrl.text = c.introVid;
      }
    }
  }

  void _submit() {
    setState(() {
      _nameErr = _nameCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
      _descErr = _descCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
      _lectureErr = _lectureCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
      _videoErr = _videoCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
    });

    if (_nameErr != null ||
        _descErr != null ||
        _lectureErr != null ||
        _videoErr != null) {
      return;
    }

    final courseData = <String, dynamic>{
      "name": _nameCtrl.text,
      "desc": _descCtrl.text,
      "introvid": _videoCtrl.text,
    };

    if (widget.courseToEdit == null) {
      courseData["Rating"] = "0.0";
      courseData["Students"] = 0;
    }

    if (widget.courseToEdit != null) {
      final oldVids = widget.courseToEdit!.videos;

      if (oldVids.isEmpty) {
        courseData["videos"] = [
          {"name": _lectureCtrl.text, "url": _videoCtrl.text}
        ];
      } else {
        final newVids = List<Map<String, dynamic>>.from(oldVids);
        newVids[0] = {"name": _lectureCtrl.text, "url": _videoCtrl.text};
        courseData["videos"] = newVids;
      }
      context
          .read<CourseCubit>()
          .updateCourse(widget.courseToEdit!.id, courseData);
    } else {
      courseData["videos"] = [
        {"name": _lectureCtrl.text, "url": _videoCtrl.text}
      ];
      context.read<CourseCubit>().createCourse(courseData);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _lectureCtrl.dispose();
    _videoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.courseToEdit != null;
    return Scaffold(
      appBar: AppBar(
          title: Text(isEditing ? "Edit Course" : AppStrings.createCourse,
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: BlocListener<CourseCubit, CourseState>(
        listener: (context, state) {
          if (state is CourseLoaded) Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  _field(
                      _nameCtrl, AppStrings.courseName, Icons.folder, _nameErr),
                  AppDimensions.hSBSm,
                  _field(_descCtrl, AppStrings.courseDesc, Icons.text_snippet,
                      _descErr,
                      maxLines: 3),
                  AppDimensions.hSBSm,
                  _field(_lectureCtrl, AppStrings.lectureName, Icons.folder,
                      _lectureErr),
                  AppDimensions.hSBSm,
                  _field(_videoCtrl, AppStrings.introVideo,
                      FontAwesomeIcons.youtube, _videoErr,
                      keyboardType: TextInputType.url),
                  AppDimensions.hSBSm,
                  PrimaryButton(
                      label: isEditing
                          ? "Update Course"
                          : AppStrings.createCourseBtn,
                      onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
      TextEditingController ctrl, String label, IconData icon, String? err,
      {TextInputType? keyboardType, int maxLines = 1}) {
    return AppTextField(
      controller: ctrl,
      label: label,
      errorText: err,
      prefixIcon: icon,
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines,
      onChanged: (value) => setState(() {}),
    );
  }
}
