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

class CreateLectureView extends StatefulWidget {
  final CourseModel courseData;
  final Map<String, dynamic>? lectureToEdit;

  const CreateLectureView(
      {super.key, required this.courseData, this.lectureToEdit});

  @override
  State<CreateLectureView> createState() => _CreateLectureViewState();
}

class _CreateLectureViewState extends State<CreateLectureView> {
  final _nameCtrl = TextEditingController();
  final _videoCtrl = TextEditingController();
  String? _nameErr, _videoErr;

  @override
  void initState() {
    super.initState();
    if (widget.lectureToEdit != null) {
      _nameCtrl.text = widget.lectureToEdit!["name"] ?? "";
      _videoCtrl.text = widget.lectureToEdit!["url"] ?? "";
    }
  }

  void _submit() {
    setState(() {
      _nameErr = _nameCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
      _videoErr = _videoCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
    });

    if (_nameErr != null || _videoErr != null) {
      return;
    }

    final newLecture = <String, dynamic>{
      "name": _nameCtrl.text,
      "url": _videoCtrl.text
    };

    if (widget.lectureToEdit != null) {
      context.read<CourseCubit>().updateLecture(
          widget.courseData.id, widget.lectureToEdit!, newLecture);
    } else {
      context.read<CourseCubit>().addLecture(widget.courseData.id, newLecture);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _videoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.lectureToEdit != null;
    return Scaffold(
      appBar: AppBar(
          title: Text(isEditing ? "Edit Lecture" : AppStrings.createLecture,
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
                  AppTextField(
                    controller: _nameCtrl,
                    label: "Name",
                    errorText: _nameErr,
                    prefixIcon: Icons.person,
                    keyboardType: TextInputType.name,
                    onChanged: (value) => setState(() {
                      _nameErr = null;
                    }),
                  ),
                  AppDimensions.hSBSm,
                  AppTextField(
                    controller: _videoCtrl,
                    label: AppStrings.introVideo,
                    errorText: _videoErr,
                    prefixIcon: FontAwesomeIcons.youtube,
                    keyboardType: TextInputType.url,
                    onChanged: (value) => setState(() {
                      _videoErr = null;
                    }),
                  ),
                  AppDimensions.hSBSm,
                  PrimaryButton(
                      label: isEditing
                          ? "Update Lecture"
                          : AppStrings.createLectureBtn,
                      onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
