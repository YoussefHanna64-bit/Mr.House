import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/core/constants/app_dimensions.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:mr_house/viewmodels/auth/auth_cubit.dart';
import 'package:mr_house/viewmodels/auth/auth_state.dart';
import 'package:flutter/services.dart';
import 'package:mr_house/views/auth/login_view.dart';
import 'package:mr_house/views/shared/app_text_field.dart';
import 'package:mr_house/views/shared/auth_rich_text.dart';
import 'package:mr_house/views/shared/gradient_background.dart';
import 'package:mr_house/views/shared/primary_button.dart';

class SignupView extends StatefulWidget {
  final UserRole role;

  const SignupView({super.key, required this.role});

  @override
  State<SignupView> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupView> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  String _gender = "Male";
  String _specialty = "Math";
  bool _obscure = true;
  bool _confObscure = true;

  String? _nameErr,
      _emailErr,
      _passErr,
      _confirmErr,
      _phoneErr,
      _addressErr,
      _bioErr,
      _ageErr,
      _expErr;

  bool _validPhone(String v) => RegExp(r'^01[0125]\d{8}$').hasMatch(v);
  bool _validEmail(String v) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v);

  void _validate() {
    setState(() {
      _nameErr = _nameCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
      _addressErr = _addressCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
      _phoneErr = _phoneCtrl.text.isEmpty
          ? AppStrings.fieldRequired
          : (_validPhone(_phoneCtrl.text) ? null : AppStrings.invalidPhone);
      _emailErr = _emailCtrl.text.isEmpty
          ? AppStrings.fieldRequired
          : (_validEmail(_emailCtrl.text) ? null : AppStrings.invalidEmail);
      _passErr = _passCtrl.text.isEmpty
          ? AppStrings.fieldRequired
          : (_passCtrl.text.length < 6 ? AppStrings.passwordLength : null);
      _confirmErr = _confirmCtrl.text.isEmpty
          ? AppStrings.fieldRequired
          : (_confirmCtrl.text != _passCtrl.text
              ? AppStrings.passwordMismatch
              : null);

      if (widget.role == UserRole.professor) {
        _bioErr = _bioCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
        _ageErr = _ageCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
        _expErr = _expCtrl.text.isEmpty ? AppStrings.fieldRequired : null;
      }
    });
  }

  void _submit() {
    _validate();
    if (_nameErr != null ||
        _addressErr != null ||
        _phoneErr != null ||
        _emailErr != null ||
        _passErr != null ||
        _confirmErr != null ||
        _bioErr != null ||
        _ageErr != null ||
        _expErr != null) {
      return;
    }

    context.read<AuthCubit>().signUp(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
          name: _nameCtrl.text,
          address: _addressCtrl.text,
          phoneNumber: _phoneCtrl.text,
          gender: _gender,
          role: widget.role,
          bio: widget.role == UserRole.professor ? _bioCtrl.text : null,
          specialty: widget.role == UserRole.professor ? _specialty : null,
          age: widget.role == UserRole.professor ? _ageCtrl.text : null,
          experience: widget.role == UserRole.professor ? _expCtrl.text : null,
        );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _bioCtrl.dispose();
    _ageCtrl.dispose();
    _expCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginView(role: widget.role)));
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.accountCreated)));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Center(
          child: GradientBackground(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                          widget.role == UserRole.student
                              ? AppStrings.welcomeText
                              : AppStrings.welcomeTextProf,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                  AppDimensions.hSBSm,
                  Text(AppStrings.signupText,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  AppDimensions.hSBSm,
                  _field(
                      _nameCtrl,
                      AppStrings.name,
                      Icons.person,
                      _nameErr,
                      TextInputType.name,
                      (v) => _nameErr =
                          v.isEmpty ? AppStrings.fieldRequired : null),
                  AppDimensions.hSBSm,
                  if (widget.role == UserRole.professor) ...[
                    _field(
                        _ageCtrl,
                        AppStrings.age,
                        Icons.calendar_today,
                        _ageErr,
                        TextInputType.number,
                        (v) => _ageErr =
                            v.isEmpty ? AppStrings.fieldRequired : null),
                    AppDimensions.hSBSm,
                    _genderDropdown(),
                    AppDimensions.hSBSm,
                    _field(
                        _expCtrl,
                        AppStrings.experience,
                        Icons.calendar_today,
                        _expErr,
                        TextInputType.number,
                        (v) => _expErr =
                            v.isEmpty ? AppStrings.fieldRequired : null),
                    AppDimensions.hSBSm,
                    _specialtyDropdown(),
                    AppDimensions.hSBSm,
                    _field(
                        _bioCtrl,
                        AppStrings.bio,
                        Icons.text_snippet,
                        _bioErr,
                        TextInputType.multiline,
                        (v) => _bioErr =
                            v.isEmpty ? AppStrings.fieldRequired : null),
                    AppDimensions.hSBSm,
                  ] else ...[
                    _genderDropdown(),
                    AppDimensions.hSBSm,
                  ],
                  _field(
                      _addressCtrl,
                      AppStrings.address,
                      Icons.location_pin,
                      _addressErr,
                      TextInputType.streetAddress,
                      (v) => _addressErr =
                          v.isEmpty ? AppStrings.fieldRequired : null),
                  AppDimensions.hSBSm,
                  _field(
                      _phoneCtrl,
                      AppStrings.phoneNumber,
                      Icons.phone,
                      _phoneErr,
                      TextInputType.phone,
                      (v) => _phoneErr = v.isEmpty
                          ? AppStrings.fieldRequired
                          : (_validPhone(v) ? null : AppStrings.invalidPhone),
                      formatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11)
                      ]),
                  AppDimensions.hSBSm,
                  _field(
                      _emailCtrl,
                      AppStrings.email,
                      Icons.email_outlined,
                      _emailErr,
                      TextInputType.emailAddress,
                      (v) => _emailErr = v.isEmpty
                          ? AppStrings.fieldRequired
                          : (_validEmail(v) ? null : AppStrings.invalidEmail)),
                  AppDimensions.hSBSm,
                  _passwordField(
                      _passCtrl,
                      AppStrings.password,
                      _passErr,
                      _obscure,
                      () => setState(() => _obscure = !_obscure),
                      (v) => _passErr = v.isEmpty
                          ? AppStrings.fieldRequired
                          : (v.length < 6 ? AppStrings.passwordLength : null)),
                  AppDimensions.hSBSm,
                  _passwordField(
                      _confirmCtrl,
                      AppStrings.confirmPassword,
                      _confirmErr,
                      _confObscure,
                      () => setState(() => _confObscure = !_confObscure),
                      (v) => _confirmErr = v.isEmpty
                          ? AppStrings.fieldRequired
                          : (v != _passCtrl.text
                              ? AppStrings.passwordMismatch
                              : null)),
                  AppDimensions.hSBSm,
                  PrimaryButton(
                      label: AppStrings.signUpBtn, onPressed: _submit),
                  AppDimensions.hSBSm,
                  AuthRichText(
                    prefix: AppStrings.haveAccount,
                    linkText: AppStrings.logIn,
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginView(role: widget.role)));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      String? err, TextInputType kt, ValueChanged<String>? onChange,
      {List<TextInputFormatter>? formatters}) {
    return AppTextField(
      controller: ctrl,
      label: label,
      errorText: err,
      prefixIcon: icon,
      keyboardType: kt,
      inputFormatters: formatters,
      onChanged: onChange,
    );
  }

  Widget _passwordField(TextEditingController ctrl, String label, String? err,
      bool obscure, VoidCallback toggle, ValueChanged<String>? onChange) {
    return AppTextField(
      controller: ctrl,
      label: label,
      errorText: err,
      prefixIcon: Icons.lock_outlined,
      keyboardType: TextInputType.visiblePassword,
      obscure: obscure,
      suffixIcon: IconButton(
        onPressed: toggle,
        icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.green,
            size: 24),
      ),
      onChanged: onChange,
    );
  }

  Widget _genderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      items: ["Male", "Female"]
          .map((g) => DropdownMenuItem(
              value: g,
              child: Text(g,
                  style: const TextStyle(color: Colors.green, fontSize: 14))))
          .toList(),
      onChanged: (v) => setState(() => _gender = v!),
      decoration: const InputDecoration(
        labelText: AppStrings.gender,
        hintText: "Select gender",
        prefixIcon: Icon(Icons.person, size: 24),
        prefixIconColor: Colors.green,
        labelStyle: TextStyle(color: Colors.black, fontSize: 14),
        hintStyle: TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }

  Widget _specialtyDropdown() {
    return DropdownButtonFormField<String>(
      value: _specialty,
      items: ["Math", "Science", "Arabic", "English", "Physics"]
          .map((s) => DropdownMenuItem(
              value: s,
              child: Text(s,
                  style: const TextStyle(color: Colors.green, fontSize: 14))))
          .toList(),
      onChanged: (v) => setState(() => _specialty = v!),
      decoration: const InputDecoration(
        labelText: AppStrings.specialty,
        hintText: "Select specialty",
        prefixIcon: Icon(Icons.person, size: 24),
        prefixIconColor: Colors.green,
        labelStyle: TextStyle(color: Colors.black, fontSize: 14),
        hintStyle: TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }
}
