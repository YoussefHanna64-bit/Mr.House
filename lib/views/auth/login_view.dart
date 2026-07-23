import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_house/core/constants/app_colors.dart';
import 'package:mr_house/core/constants/app_dimensions.dart';
import 'package:mr_house/core/constants/app_strings.dart';
import 'package:mr_house/models/user_model.dart';
import 'package:mr_house/viewmodels/auth/auth_cubit.dart';
import 'package:mr_house/viewmodels/auth/auth_state.dart';
import 'package:mr_house/views/auth/signup_view.dart';
import 'package:mr_house/views/shared/app_text_field.dart';
import 'package:mr_house/views/shared/auth_rich_text.dart';
import 'package:mr_house/views/shared/gradient_background.dart';
import 'package:mr_house/views/shared/primary_button.dart';

class LoginView extends StatefulWidget {
  final UserRole role;

  const LoginView({super.key, required this.role});

  @override
  State<LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginView> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _forgotPassDialog(BuildContext context) {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.resetPassword),
        content: AppTextField(
          controller: ctrl,
          label: AppStrings.enterEmail,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().sendPasswordReset(ctrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text(AppStrings.submit,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(AppStrings.cancel,
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(
                context,
                state.user.role == UserRole.student
                    ? "/studentHome"
                    : "/professorHome",
                (context) => false);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Center(
          child: GradientBackground(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.role == UserRole.student
                          ? AppStrings.welcomeText
                          : AppStrings.welcomeTextProf,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w600)),
                  AppDimensions.hSBSm,
                  Text(AppStrings.loginText,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: AppColors.textSecondary)),
                  AppDimensions.hSBSm,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        label: AppStrings.email,
                        hint: "Email address",
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        controller: _passCtrl,
                        keyboardType: TextInputType.visiblePassword,
                        obscure: _obscure,
                        label: AppStrings.password,
                        hint: "Password",
                        prefixIcon: Icons.lock_outlined,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                          icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.green,
                              size: 24),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: RichText(
                          text: TextSpan(
                            text: AppStrings.forgotPassword,
                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _forgotPassDialog(context),
                          ),
                        ),
                      ),
                      AppDimensions.hSBSm,
                      PrimaryButton(
                        label: AppStrings.login,
                        onPressed: () {
                          final cubit = context.read<AuthCubit>();
                          cubit.login(_emailCtrl.text.trim(), _passCtrl.text,
                              widget.role);
                        },
                        height: 55,
                      ),
                    ],
                  ),
                  AppDimensions.hSBSm,
                  AuthRichText(
                    prefix: AppStrings.noAccount,
                    linkText: AppStrings.signUp,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupView(role: widget.role),
                        ),
                      );
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
}
