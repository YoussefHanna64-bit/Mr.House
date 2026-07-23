import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mr_house/core/constants/app_dimensions.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:mr_house/viewmodels/auth/auth_cubit.dart';
import 'package:mr_house/viewmodels/profile/profile_cubit.dart';
import 'package:mr_house/viewmodels/auth/auth_state.dart';
import 'package:mr_house/viewmodels/profile/profile_state.dart';
import 'package:mr_house/views/shared/app_text_field.dart';

class PersonalInfoView extends StatefulWidget {
  final UserRole role;

  const PersonalInfoView({super.key, required this.role});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  void _changePassDialog(BuildContext context) {
    final curCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confCtrl = TextEditingController();

    bool curObscure = true;
    bool newObscure = true;
    bool confObscure = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text(AppStrings.changePassword),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                  controller: curCtrl,
                  label: AppStrings.currentPassword,
                  obscure: curObscure,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setDialogState(() => curObscure = !curObscure),
                    icon: Icon(
                        curObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.green,
                        size: 24),
                  )),
              AppDimensions.hSBXs,
              AppTextField(
                  controller: newCtrl,
                  label: AppStrings.newPassword,
                  obscure: newObscure,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setDialogState(() => newObscure = !newObscure),
                    icon: Icon(
                        newObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.green,
                        size: 24),
                  )),
              AppDimensions.hSBXs,
              AppTextField(
                  controller: confCtrl,
                  label: AppStrings.confirmPassword,
                  obscure: confObscure,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setDialogState(() => confObscure = !confObscure),
                    icon: Icon(
                        confObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.green,
                        size: 24),
                  )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().changePassword(
                    currentPassword: curCtrl.text,
                    newPassword: newCtrl.text,
                    confirmPassword: confCtrl.text);
                Navigator.pop(context);
              },
              child: const Text(AppStrings.submit,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(AppStrings.cancel,
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(AppStrings.profile, style: TextStyle(fontSize: 30)),
          centerTitle: true),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.passwordChanged)));
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProfileLoaded) {
                final user = state.user;

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      const CircleAvatar(
                          radius: 85,
                          child: FaIcon(FontAwesomeIcons.user, size: 85)),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                _field(
                                    context,
                                    AppStrings.fullName,
                                    user.name,
                                    user.role == UserRole.student
                                        ? "name"
                                        : "Fullname",
                                    user),
                                const Divider(thickness: 1),
                                _field(context, AppStrings.address,
                                    user.address, "address", user),
                                const Divider(thickness: 1),
                                _dateField(context, user),
                                const Divider(thickness: 1),
                                _field(context, AppStrings.phoneNumber,
                                    user.phoneNumber, "phoneNumber", user),
                                const Divider(thickness: 1),
                                _field(context, AppStrings.email, user.email,
                                    "email", user,
                                    isEmail: true),
                                const Divider(thickness: 1),
                                _genderField(context, user),
                                const Divider(thickness: 1),
                                _passwordField(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text(AppStrings.noUserData));
            },
          ),
        ),
      ),
    );
  }

  Widget _field(BuildContext context, String label, String initial,
      String field, UserModel user,
      {bool isEmail = false}) {
    final ctrl = TextEditingController(text: initial);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppTextField(
                controller: ctrl,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                border: InputBorder.none,
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (isEmail) {
                  try {
                    await context
                        .read<ProfileCubit>()
                        .updateEmail(user.role, ctrl.text);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Verification email sent")),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$e")),
                      );
                    }
                  }
                } else {
                  context
                      .read<ProfileCubit>()
                      .updateProfile(user.role, field, ctrl.text);
                }
              },
              child: const FaIcon(FontAwesomeIcons.penToSquare,
                  color: Colors.grey, size: 24),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dateField(BuildContext context, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(AppStrings.birthday,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.selectBirthday,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now());

                if (picked != null && context.mounted) {
                  context.read<ProfileCubit>().updateProfile(
                      user.role, "birthDate", Timestamp.fromDate(picked));
                }
              },
              child: const FaIcon(FontAwesomeIcons.penToSquare,
                  color: Colors.grey, size: 24),
            ),
          ],
        ),
      ],
    );
  }

  Widget _genderField(BuildContext context, UserModel user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(AppStrings.gender,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
        DropdownButton<String>(
          value: user.gender,
          onChanged: (v) => context
              .read<ProfileCubit>()
              .updateProfile(user.role, "gender", v),
          items: ["Male", "Female"]
              .map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(g,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))))
              .toList(),
        ),
      ],
    );
  }

  Widget _passwordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(AppStrings.changePassword,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
        AppDimensions.hSBXs,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("**************",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            GestureDetector(
                onTap: () => _changePassDialog(context),
                child: const FaIcon(FontAwesomeIcons.penToSquare,
                    color: Colors.grey, size: 24)),
          ],
        ),
      ],
    );
  }
}
